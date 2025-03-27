#!/bin/bash

# Function to increment version numbers
increment_version() {
    local version=$1
    local part=$2

    IFS='.' read -r -a version_parts <<< "$version"
    major=${version_parts[0]}
    minor=${version_parts[1]}
    patch=${version_parts[2]}

    case $part in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            echo "Unknown part: $part. Must be one of: major, minor, patch."
            exit 1
            ;;
    esac

    echo "$major.$minor.$patch"
}

# Check for required tools
if ! command -v git &> /dev/null; then
    echo "git could not be found. Please install git to use this script."
    exit 1
fi

# Check if README.md exists
if [ ! -f "README.md" ]; then
    echo "README.md not found in the current directory."
    exit 1
fi

# Get the current version from README.md with debugging
echo "Attempting to extract version from README.md..."
current_version=$(sed -n 's/.*project-\(.*\)-.*/\1/p' README.md)
echo "Extracted version: '$current_version'"

if [ -z "$current_version" ]; then
    echo "Could not find the version in README.md. Expected format: 'project-X.Y.Z' (e.g., project-0.0.1)."
    echo "Here’s the content of README.md for reference:"
    cat README.md
    exit 1
fi

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "No version part supplied. Usage: $0 {major|minor|patch}"
    exit 1
fi

# Get the new version based on the input argument
new_version=$(increment_version "$current_version" "$1")

# Create a new git branch for the release
branch_name="release/$new_version"
git checkout -b "$branch_name"

# Update README.md with the new version (macOS-compatible sed -i)
sed -i '' "s/project-\(.*\)-\(.*\)/project-$new_version-\2/" README.md

# Generate the changelog
echo "## Version $new_version" > new_changelog.md
echo "" >> new_changelog.md
echo "### BREAKING CHANGES" >> new_changelog.md
echo '```markdown' >> new_changelog.md
git log --pretty=format:"%s" main..HEAD | grep "^BREAKING CHANGE" >> new_changelog.md
echo '```' >> new_changelog.md
echo "### Features" >> new_changelog.md
echo '```markdown' >> new_changelog.md
git log --pretty=format:"%s" main..HEAD | grep "^feat" >> new_changelog.md
echo '```' >> new_changelog.md
echo "" >> new_changelog.md
echo "### Fixes" >> new_changelog.md
echo '```markdown' >> new_changelog.md
git log --pretty=format:"%s" main..HEAD | grep "^fix" >> new_changelog.md
echo '```' >> new_changelog.md
echo "" >> new_changelog.md
if [ -f changelog.md ]; then
    cat changelog.md >> new_changelog.md
fi
mv new_changelog.md changelog.md

# Commit the changes
git add README.md changelog.md
git commit -m "Bump version to $new_version and update changelog"

# Merge the release branch into main
git checkout main
git merge --no-ff "$branch_name" -m "Merge release $new_version into main"

# Tag the new version on main
git tag "v$new_version"

# Merge the main branch into develop
git checkout develop
git merge --no-ff main -m "Merge main into develop after release $new_version"

# Delete the release branch
git branch -d "$branch_name"

echo "Version updated to $new_version, changelog updated, merged into main and develop branches, and tagged as v$new_version."
