# Improvements Checklist

This document provides a quick checklist of recommended improvements identified in the comprehensive code review.

## High Priority 🔴

- [ ] **Fix mason.nvim configuration** (`lua/plugins/mason.lua`)
  - Change `config = function()` to `config = function(_, opts)`
  - Pass opts to setup: `require("mason").setup(opts)`

- [ ] **Add cross-platform support to bump_version.sh**
  - Detect OS type before running sed command
  - Use appropriate sed syntax for macOS vs Linux

- [ ] **Add error handling for plugin requires**
  - `lua/config/keymaps.lua` - Telescope require on line 82
  - `lua/plugins/nvim-cmp.lua` - Config icons require on line 48
  - Wrap critical requires in pcall()

- [ ] **Fix hardcoded Java path** (`lua/plugins/nvim-lspconfig.lua` line 46)
  - Use `vim.fn.exepath("java")` with fallback
  - Support multiple platform-specific paths

## Medium Priority 🟡

- [ ] **Remove duplicate highlight_yank autocmd** (`init.lua` lines 91-96)
  - Already defined in `lua/config/autocmds.lua`
  - Keep only one version

- [ ] **Add CI/CD pipeline** (`.github/workflows/ci.yml`)
  - Lua syntax checking with luacheck
  - Style checking with stylua
  - Documentation link checking

- [ ] **Clean up commented code**
  - `lua/plugins/nvim-lspconfig.lua` line 126
  - `lua/config/keymaps.lua` line 142-143
  - Either remove or document why kept

- [ ] **Add branch existence checks to bump_version.sh**
  - Verify main and develop branches exist
  - Check for uncommitted changes before starting
  - Add error handling for merge conflicts

## Low Priority 🟢

- [ ] **Add type annotations**
  - `lua/util/init.lua` - All utility functions
  - `lua/config/keymaps.lua` - Helper functions
  - Use LuaLS annotations format

- [ ] **Pin plugin versions**
  - Consider pinning major versions for stability
  - Especially for core plugins like telescope, nvim-cmp

- [ ] **Add inline documentation**
  - Document complex keybindings
  - Explain non-obvious configuration choices
  - Add comments for platform-specific code

- [ ] **Create troubleshooting guide**
  - Common setup issues
  - Platform-specific notes
  - Dependency requirements

## Optional Enhancements 💡

- [ ] **Add LSP progress indicator**
  - Show LSP attachment status in status line
  - Visual feedback for long operations

- [ ] **Create plugin template**
  - Standardize plugin configuration format
  - Make it easier to add new plugins consistently

- [ ] **Add health check**
  - Custom `:checkhealth` integration
  - Verify all dependencies are installed
  - Check for configuration issues

- [ ] **Document customization points**
  - How to add new language support
  - How to modify keybindings
  - How to add custom formatters

## Code Quality Improvements

### Error Handling Pattern
```lua
-- Before
local builtin = require("telescope.builtin")

-- After
local ok, builtin = pcall(require, "telescope.builtin")
if not ok then
  vim.notify("Telescope not available", vim.log.levels.WARN)
  return
end
```

### Configuration Pattern
```lua
-- Before
config = function()
  require("mason").setup()
end,

-- After
config = function(_, opts)
  require("mason").setup(opts)
end,
```

### Cross-platform Shell Script
```bash
# Before
sed -i '' "s/pattern/replacement/" file

# After
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s/pattern/replacement/" file
else
  sed -i "s/pattern/replacement/" file
fi
```

## Testing Strategy

When implementing improvements:

1. **Test in clean environment**
   - Clone config to new location
   - Test with fresh Neovim install
   - Verify all plugins load correctly

2. **Test cross-platform**
   - macOS
   - Linux (Ubuntu/Debian)
   - Consider Windows with WSL

3. **Test language support**
   - Open sample files for each supported language
   - Verify LSP attaches correctly
   - Test debugging configurations
   - Verify formatters work

4. **Test bump_version.sh**
   - Run in test repository
   - Verify branch creation
   - Check changelog generation
   - Test tag creation

## Review Completed By
- Date: October 24, 2025
- Reviewer: GitHub Copilot
- Review Document: CODE_REVIEW.md

## Progress Tracking

To track your progress:
1. Create an issue from this checklist
2. Convert items to GitHub issues/PRs
3. Use the "Projects" feature to track completion
4. Update this file as items are completed

---

**Note:** Not all items need to be completed immediately. Prioritize based on your actual usage patterns and pain points.
