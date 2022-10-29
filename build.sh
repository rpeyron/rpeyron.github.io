# bundle config set --local path 'vendor/bundle'
bundle install --path vendor/bundle
bundle exec jekyll build --profile --trace --config "_config.yml,_config_prod.yml" 
