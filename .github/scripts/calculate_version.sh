#!/bin/bash

# Fetch tags from the remote
git fetch --tags

# Get the latest tag from Git
latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)

if [[ "$latest_tag" == "" ]]; then
  latest_tag="v0.0.0"
fi

echo "Latest tag: $latest_tag"

# Split the tag into major, minor, and patch numbers
IFS='.' read -ra VER <<< "${latest_tag#v}"
major="${VER[0]}"
minor="${VER[1]}"
patch="${VER[2]}"

echo "Current version: Major: $major, Minor: $minor, Patch: $patch"


# Function to increment version numbers
increment_version() {
  local version=$1
  version=$((version+1))
  echo $version
}

# Debug: Output commit messages
echo "Commit messages since $latest_tag:"
git log $latest_tag..HEAD --pretty=format:"%s"
echo "1"

# Analyze commits for version bumps
for commit in $(git log $latest_tag..HEAD --pretty=format:"%s")
do
  if [[ "$commit" == *"breaking:"* ]]; then
    echo "Found breaking change in commit: $commit"
    major=$(increment_version $major)
    minor=0
    patch=0
    echo "New version after BREAKING CHANGE: Major: $major, Minor: $minor, Patch: $patch"
    break
  elif [[ "$commit" == *"feat:"* ]]; then
    echo "3"
    minor=$(increment_version $minor)
    patch=0
  elif [[ "$commit" == *"fix:"* ]]; then
    echo "4"
    patch=$(increment_version $patch)
  fi
done

# Construct new tag
new_tag="v${major}.${minor}.${patch}"
echo "New tag: $new_tag"

# Set output for GitHub Actions
echo "::set-output name=new_tag::$new_tag"
