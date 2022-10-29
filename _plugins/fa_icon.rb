require 'jekyll/fontawesome/svg/fa-icon'

module Jekyll
  module FontAwesome
    module Svg
      class FontAwesomeSvgIconGenerator < Liquid::Tag
        def initialize(tag_name, markup, tokens)
          super
          @tmp_markup = markup
        end

        def render(context)
          faIcon = context[@markup] ||= @tmp_markup
          @icon = FontAwesomeIcon.new(faIcon.strip)
          
          "<svg class=\"icon\">
           <defs>#{@icon.to_svg_html}</defs>
           <use xlink:href='##{@icon.value}'></use>
           </svg>"
        end
      end
    end
  end
end

Liquid::Template.register_tag('fa_icon', Jekyll::FontAwesome::Svg::FontAwesomeSvgIconGenerator)
