local copilot_source_registered = false

local function get_copilot_client(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "copilot" })) do
    if not client.is_stopped or not client.is_stopped() then
      return client
    end
  end
end

local function get_copilot_label(text)
  local first_line = vim.trim((text or ""):match("[^\n]*") or "")
  if first_line == "" then
    first_line = "Copilot Suggestion"
  end
  if text and text:find("\n", 1, true) then
    first_line = first_line .. " ..."
  end
  return first_line
end

local function get_formatting_options(bufnr)
  local options = vim.bo[bufnr]
  return {
    insertSpaces = options.expandtab,
    tabSize = options.shiftwidth > 0 and options.shiftwidth or options.tabstop,
  }
end

local function register_copilot_source(cmp)
  if copilot_source_registered then
    return
  end

  local types = require("cmp.types")
  local method = vim.lsp.protocol.Methods.textDocument_inlineCompletion

  local source = {
    request_ids = {},
  }

  local function request(self, client, params, callback)
    local key = client.id
    local previous_request = self.request_ids[key]
    if previous_request then
      client:cancel_request(previous_request)
      self.request_ids[key] = nil
    end

    local request_id
    local ok
    ok, request_id = client:request(method, params, function(err, result)
      if self.request_ids[key] ~= request_id then
        return
      end
      self.request_ids[key] = nil

      if err then
        if err.code == -32801 then
          request(self, client, params, callback)
          return
        end
        callback({ items = {}, isIncomplete = false })
        return
      end

      callback(result or { items = {}, isIncomplete = false })
    end)

    if ok and request_id then
      self.request_ids[key] = request_id
      return
    end

    callback({ items = {}, isIncomplete = false })
  end

  function source:is_available()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = get_copilot_client(bufnr)
    return client ~= nil and client:supports_method(method, bufnr)
  end

  function source:get_debug_name()
    return "copilot"
  end

  function source:get_position_encoding_kind()
    local client = get_copilot_client()
    return client and client.offset_encoding or "utf-16"
  end

  function source:get_trigger_characters()
    return { " ", ".", ":", "(", "[", "{", "," }
  end

  function source:complete(params, callback)
    local bufnr = params.context.bufnr
    local client = get_copilot_client(bufnr)
    if not client then
      callback({ items = {}, isIncomplete = false })
      return
    end

    local lsp_params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    local version = vim.lsp.util.buf_versions[bufnr]
    if version then
      ---@diagnostic disable-next-line: inject-field
      lsp_params.textDocument.version = version
    end
    lsp_params.context = {
      triggerCharacter = params.completion_context.triggerCharacter,
      triggerKind = params.completion_context.triggerKind,
    }
    lsp_params.formattingOptions = get_formatting_options(bufnr)

    ---@diagnostic disable-next-line: param-type-mismatch
    client:notify("textDocument/didFocus", { textDocument = { uri = lsp_params.textDocument.uri } })

    local filter_text = string.sub(params.context.cursor_before_line, params.offset)
    local default_range = {
      start = lsp_params.position,
      ["end"] = lsp_params.position,
    }

    request(self, client, lsp_params, function(response)
      local items = {}
      for index, item in ipairs(response.items or response or {}) do
        local insert_text = item.insertText or ""
        items[#items + 1] = {
          command = item.command,
          data = item.data,
          documentation = {
            kind = "plaintext",
            value = insert_text,
          },
          filterText = filter_text,
          insertTextFormat = types.lsp.InsertTextFormat.PlainText,
          kind = types.lsp.CompletionItemKind.Text,
          label = get_copilot_label(insert_text),
          labelDetails = {
            description = "[Copilot]",
          },
          sortText = string.format("%04d", index),
          textEdit = {
            newText = insert_text,
            range = item.range or default_range,
          },
        }
      end

      callback({
        isIncomplete = true,
        items = items,
      })
    end)
  end

  function source:resolve(completion_item, callback)
    callback(completion_item)
  end

  function source:execute(completion_item, callback)
    local client = get_copilot_client()
    if not client or not completion_item.command then
      callback()
      return
    end

    client:request("workspace/executeCommand", completion_item.command, function()
      callback()
    end)
  end

  cmp.register_source("copilot", source)
  copilot_source_registered = true
end

return {
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      -- Add other dependencies as needed
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      register_copilot_source(cmp)
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "copilot", priority = 1100 },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(_, item)
            local icons = require("config").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
  },
}
