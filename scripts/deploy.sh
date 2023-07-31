#!/usr/bin/env bash

set -e # exit with nonzero exit code if anything fails

# Git user info configs
git config --global user.email "carbon@us.ibm.com"
git config --global user.name "carbon-bot"

# Add github token to git credentials
git config credential.helper "store --file=.git/credentials"
echo "https://${GH_TOKEN}:@github.com" > .git/credentials 2>/dev/null

# Get git into the right state, ensure local branch is up-to-date
# Should not be needed with actions/checkout@v3 in release.yml
# git checkout master

# Create version, changelogs and Github release
echo "Creating version, changelogs and publishing to Github..."
npx lerna version --yes --force-publish --conventional-commits --create-release github

echo "Rebuild packages and demos so dist and demo/bundle directories are updated..."
yarn build

# As angular publishes from dist, lerna does not replace the "workspace:*" with the version
node scripts/update-angular-dependency-version.mjs

# Authenticate with npm registry
npm config set //registry.npmjs.org/:_authToken=$NPM_TOKEN -q

echo "Publish to registry..."
# All packages except angular are published from their root with publishing content filtered via files array in package.json.
# The angular package adds the tag "next" automatically (package.json/publishConfig.tag).
npx lerna publish from-git --yes --force-publish
