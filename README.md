# betacade.com

The marketing site for [Betacade](https://betacade.com): a landing page and the
legal pages (privacy, terms, data requests). A static
[Jekyll](https://jekyllrb.com) site on GitHub Pages, the same setup as
`../tend2thrive.com`. The app itself lives in `../betacade`.

The site has no scripts, no analytics, no trackers and sets no cookies. The
privacy policy says so; keep it that way.

## Preview locally (Docker, no Ruby needed)

Ruby, Bundler, the build toolchain and the gems all live in the container.

```sh
docker compose watch       # builds, serves, and syncs your edits live
```

Open <http://archmatt.local:4000> and edit any file; the page reloads. Stop
with `Ctrl-C`, then `docker compose down`.

Two things differ from a plain local Docker setup, both because the daemon runs
on **archmatt.local** over an SSH context:

- **It's `watch`, not `up`.** The remote daemon can't see this machine's
  filesystem, so the source is baked into the image and `watch` streams later
  edits into the running container over the Docker API. Requires Compose
  ≥ 2.22 (`docker compose version`).
- **Browse the host, not localhost.** Ports publish on archmatt.local. It uses
  the same ports as the tend2thrive.com preview (4000, 35729), so stop that one
  first if it's running.

For a one-off production build instead of the live server:

```sh
docker compose run --rm site bundle exec jekyll build   # output in _site/
```

<details>
<summary>Preview without Docker (native Ruby)</summary>

Requires Ruby ≥ 3.0 with headers, Bundler, and a C toolchain (`make`, `gcc`)
for native gems.

```sh
bundle install
bundle exec jekyll serve --livereload
```
</details>

`Gemfile.lock` is committed (copied from tend2thrive.com, same single
`github-pages` dependency) because the Dockerfile copies it.

## Structure

```
_config.yml             Site settings, and the app URLs every call to action uses
_layouts/default.html   Shared <head>, nav, footer; every page uses this
_includes/nav.html      The site-wide top bar
_includes/footer.html   The site-wide footer
assets/css/site.css     All styles (light and dark follow the system setting)
index.html              Landing          (/)
privacy.html            Privacy Policy   (/privacy.html)
terms.html              Terms of Service (/terms.html)
data-request.html       Data requests    (/data-request.html)
404.html                Not found
site.webmanifest        Name and colours
.github/workflows/      Builds and deploys to GitHub Pages on push to main
Dockerfile              Local preview image (source baked in, not mounted)
docker-compose.yml      Local preview + file-sync config
Gemfile                 Pins the github-pages gem (matches GitHub's build)
CNAME                   Custom domain (betacade.com)
```

The app links `https://betacade.com/terms.html` and `/privacy.html` from its
sign-in screens, so keep those paths. When either document changes materially,
bump its version in the app's `lib/legal.ts` so everyone accepts the new text.

## Icons

`favicon.ico` (16, 32, 48), `favicon.svg` (follows light and dark: a light square in dark mode), `apple-touch-icon.png` (180, full bleed: iOS rounds
it) and `icon-192.png` / `icon-512.png` (in `site.webmanifest`) are the play mark: an ink rounded
square with a white triangle. They were drawn by a small standard-library Python script; when
there's a real logo, replace these files and keep the names.

## Deployment

Push to `main`. `.github/workflows/jekyll.yml` builds the site with Jekyll and
deploys it to GitHub Pages, served at [betacade.com](https://betacade.com).

One-time setup:

1. Create the GitHub repo (`_config.yml`'s `repository:` assumes
   `mcdoco/betacade.com`).
2. Settings → Pages → Source: **GitHub Actions**. Custom domain: `betacade.com`,
   then Enforce HTTPS once the certificate is issued.
3. On Cloudflare, point betacade.com at GitHub Pages: apex `A` records
   185.199.108.153, 185.199.109.153, 185.199.110.153, 185.199.111.153 (and
   optionally `www` as a `CNAME` to `<owner>.github.io`). DNS only (grey cloud)
   until GitHub has issued the certificate.
