# Description: Jekyll plugin to replace Markdown image syntax with HTML markup, written to work combined with Jekyll Picture Tag
# Adapted from https://ivovalchev.medium.com/jekyll-responsive-images-with-srcset-5da131415d0f

Jekyll::Hooks.register :documents, :pre_render do |document, payload|
    docExt = document.extname.tr('.', '')
    # only process if we deal with a markdown file
    if payload['site']['markdown_ext'].include? docExt
      # newContent = document.content.gsub(/!\[([^\]]*)\]\(([^\)\]]+)\)(?:{:([^}]+)})*/, '{% picture default \2 --alt \1 --link /img/\2 %}')
      newContent = document.content.gsub(/!\[([^\]]*)\]\((?!http)(?!data)([^\)\]\s]+)\s*([^)]*)?\)(?:{:([^}]+)})*/, '{% picture default \2 --alt \1 --title \3 %}')
      if newContent != document.content
        # print newContent
        document.content = newContent
      end
    end
  end