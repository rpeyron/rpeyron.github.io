# bundle config set --local path 'vendor/bundle'
bundle install --path vendor/bundle

bundle exec jekyll build --profile --trace

#bundle exec jekyll serve  --livereload --trace 
#bundle exec jekyll serve  --livereload --drafts --host 0.0.0.0
#bundle exec jekyll serve  --livereload --incremental --host 0.0.0.0

bundle exec jekyll serve  --livereload --incremental --drafts --profile --config "_config.yml,_config_dev.yml" --host 0.0.0.0

#bundle exec jekyll serve  --livereload --incremental --detach --host 0.0.0.0

# bundle exec jekyll build 
# /!\  --lsi  produces  non sense related posts...
