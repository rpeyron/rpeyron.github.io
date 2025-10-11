module Jekyll
  class RedirectGenerator < Generator
    safe true
    priority :low

    def generate(site)
      # Charger le fichier JSON depuis _data
      redirects = site.data['redirects'] || {}

      redirects.each do |old_url, new_url|
        # Nettoyer le chemin pour générer un nom de fichier unique
        filename = old_url.gsub('/', '_').gsub(/[^0-9A-Za-z_]/, '')
        filename = "root" if filename.empty?

        # Définir le permalink et les données front matter
        redirect_page = RedirectPage.new(site, site.source, filename, old_url, new_url)

        # Ajouter la page au site
        site.pages << redirect_page
      end
    end
  end

  class RedirectPage < Page
    def initialize(site, base, filename, old_url, new_url)
      @site = site
      @base = base
      @dir  = "/"  # racine ou personnaliser selon besoin
      @name = "#{filename}.html"

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'redirect.html')

      self.data['layout'] = 'redirect'
      self.data['permalink'] = old_url
      self.data['redirect_to'] = new_url
      self.data['title'] = "Redirection"
    end
  end
end