class NewsArticlePresenter < Whitehall::Decorators::Decorator
  include EditionPresenterHelper
  include LeadImagePresenterHelper

  delegate_instance_methods_of NewsArticle

  def to_hash
    {
      slug: slug,
      title: title,
      summary: summary,
      body: body,
      lead_image: {
        url: lead_image_path,
        alt_text: lead_image_alt_text,
        caption: lead_image_caption
      },
      related_policies: [],
      related_topics: []
    }
  end

  private

  def find_asset(asset)
    Rails.application.assets.find_asset(asset)
  end
end
