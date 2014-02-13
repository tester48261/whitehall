class Frontend::NewsArticleProvider
  def self.get(slug, locale = :en)
    news_article_hash = Api::NewsArticleProvider.get(slug, locale)
    build_news_article(news_article_hash)
  end

private
  def self.build_news_article(news_article_hash)
    Frontend::NewsArticle.new news_article_hash.dup.tap { |hash|
      hash[:lead_image] = Frontend::Image.new(hash[:lead_image])
    }
  end
end
