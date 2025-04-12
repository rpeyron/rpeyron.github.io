# bundle config set --local path 'vendor/bundle'
BUNDLE_GEMFILE=Gemfile-dev bundle install --path vendor/bundle

bundle exec jekyll build --profile --trace

#bundle exec jekyll serve  --livereload --trace 
#bundle exec jekyll serve  --livereload --drafts --host 0.0.0.0
#bundle exec jekyll serve  --livereload --incremental --host 0.0.0.0

# bundle exec jekyll serve  --livereload --incremental --drafts --profile --config "_config.yml,_config_dev.yml" --host 0.0.0.0 -b /test
# BUNDLE_GEMFILE=Gemfile-dev bundle exec jekyll serve  --livereload --incremental --drafts --profile --config "_config.yml,_config_dev.yml" --host 0.0.0.0

# BUNDLE_GEMFILE=Gemfile-dev bundle exec jekyll serve  --livereload --incremental --future --drafts --profile --config "_config.yml,_config_dev.yml" --host 192.168.0.1

# incremental seems to be broken
BUNDLE_GEMFILE=Gemfile-dev bundle exec jekyll serve  --livereload --watch --future --drafts --profile --config "_config.yml,_config_dev.yml" --host 192.168.0.1 --port 4000

# --skip-initial-build will cause jekyll-admin does not show any item

# --no-watch to avoid content duplication with jekyll-admin (site.process in file_helper) -- FIXED
#BUNDLE_GEMFILE=Gemfile-dev bundle exec jekyll serve  --no-watch --livereload --incremental --drafts --profile --config "_config.yml,_config_dev.yml" --host 192.168.0.1


#bundle exec jekyll serve  --livereload --incremental --detach --host 0.0.0.0

# bundle exec jekyll build 
# /!\  --lsi  produces  non sense related posts...
