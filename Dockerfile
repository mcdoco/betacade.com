# Local preview image. The source is COPYed in rather than bind-mounted,
# because the Docker daemon is remote (an SSH context) and cannot see this
# machine's filesystem. `docker compose watch` streams edits into the running
# container over the Docker API instead. See docker-compose.yml.

# Full Debian-based Ruby (not -slim): the github-pages gem builds native
# extensions (sassc, nokogiri, eventmachine) that need gcc/make.
FROM ruby:3.3

WORKDIR /site

# Gems first, in their own layer, so editing a page doesn't reinstall them.
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# --force_polling: synced files arrive via the Docker API and do not reliably
# trip inotify inside the container.
CMD ["bundle", "exec", "jekyll", "serve", \
     "--host", "0.0.0.0", "--livereload", "--force_polling"]
