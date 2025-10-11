source "https://rubygems.org"
# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll", "4.2.2"   # Note: newer versions upgrade SAAS and need some rework with bootstrap scoping
# Speed up Liquid tags (optional)
gem "liquid-c"
# This is the default theme for new Jekyll sites. You may change this to anything you like.
gem "minima"
# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins
# If you have any plugins, put them here!
group :jekyll_plugins do
  gem 'jekyll-fontawesome-svg', '~> 0.3.4'   # SVG names are modified in 0.4
  gem 'jekyll-paginate'
  gem 'jekyll-sitemap'
  gem 'jekyll-seo-tag'
  gem 'jekyll-relative-links'
  gem "webrick"   # Seems to be required by jekyll-admin
  gem 'kramdown'
  gem 'rouge' 
  gem 'jekyll_picture_tag', '~> 2.0'  # apt install libvips libvips-tools libwebp6
  gem 'jekyll-archives'
  gem 'jekyll-include-cache'
  gem 'jekyll-redirect-from'

  # Create Service Workers for PWA  https://github.com/lavas-project/jekyll-pwa
  # TODO: create & customize configuation in _config and service-worker.js
  # gem 'jekyll-pwa-plugin'

  # gem 'jekyll-admin'   # Only in Gemfile-dev

  # To use LSI but does not produces good results
  # gem 'classifier-reborn'
  # gem 'numo-narray' 
  # gem 'numo-linalg'  # apt-get install liblapacke-dev libopenblas-dev
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
#gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
#gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]
