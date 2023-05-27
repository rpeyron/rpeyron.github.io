Jekyll::Hooks.register :documents, :post_render do |document|
    # Remove mathjax markers for asciimath code blocks (use $$` <asciimath> `$$)
    newContent = document.output.gsub(/\\\((`[^`]*`)\\\)/m, "\\1")
    newContent = newContent.gsub(/\\\[(`[^`]*`)\\\]/m, "\\1")
    document.output = newContent
  end