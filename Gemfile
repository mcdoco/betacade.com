# Local preview only. GitHub Pages builds the site server-side from this repo,
# so nothing here needs to run in production — it just lets you `jekyll serve`
# locally against the exact same toolchain GitHub uses.
source "https://rubygems.org"

# The github-pages gem pins Jekyll and every allowed plugin (including
# jekyll-feed) to the versions GitHub Pages runs. One dependency, no drift.
gem "github-pages", group: :jekyll_plugins

# Ruby 3.0+ dropped webrick from the stdlib; Jekyll's local server needs it.
gem "webrick", "~> 1.8"
