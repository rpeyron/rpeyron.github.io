Jekyll::Hooks.register :documents, :pre_render do |document, payload|
    docExt = document.extname.tr('.', '')
    # only process if we deal with a markdown file
    if payload['site']['markdown_ext'].include? docExt
        # Protect fenced code blocks by marking them as raw content.
        newContent = document.content.gsub(/^(```[^`]*?^```)$|(`(?<!``)[^`]+`(?!`))/m, "{% raw %}\\1\\2{% endraw %}")
        # newContent = document.content.gsub(/^(```.*?^```)$/m, "{% raw %}\n\\1\n{% endraw %}")# Description: Jekyll plugin to replace Markdown image syntax with HTML markup, written to work combined with Jekyll Picture Tag
        # newContent = newContent.gsub(/(`(?<!``)[^`]+`(?!`))/, "{% raw %}\\1{% endraw %}")# Description: Jekyll plugin to replace Markdown image syntax with HTML markup, written to work combined with Jekyll Picture Tag
        document.content = newContent
    end
  end