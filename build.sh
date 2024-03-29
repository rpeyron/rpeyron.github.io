# Requirements
# - ruby-dev
# - ruby-bundler
# - libffi-dev
# - gcc
# - libvips libvips-tools

# bundle config set --local path 'vendor/bundle'
# bundle update --all
bundle install --path vendor/bundle
bundle exec jekyll build --profile --trace --config "_config.yml,_config_prod.yml" 
