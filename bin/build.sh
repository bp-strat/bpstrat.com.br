#!/usr/bin/env bash
set -euo pipefail

destination="${1:-_site}"
commit_sha="$(git rev-parse --short HEAD)"

export JEKYLL_ENV=production
export SASS_SILENCE_DEPRECATIONS=all

printf 'commit_sha: "%s"\n' "$commit_sha" > _config_build.yml
bundle exec jekyll build \
  --config _config.yml,_config_build.yml \
  --destination "$destination"
ruby test/validate_agent_markdown.rb "$destination"
