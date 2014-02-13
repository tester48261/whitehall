class Api::NewsArticleProvider
  def self.get(slug, locale = :en)
    NewsArticlePresenter.new(NewsArticle.published_as(slug, locale)).to_hash
  end
end
