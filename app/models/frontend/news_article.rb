class Frontend::NewsArticle
  attr_reader :slug, :title, :summary, :body,
              :lead_image, :related_policies, :related_topics,
              :organisations

  def initialize(attrs = {})
    @slug = attrs[:slug]
    @title = attrs[:title]
    @summary = attrs[:summary]
    @body = attrs[:body]
    @lead_image = attrs[:lead_image]
    @related_policies = attrs[:related_policies]
    @related_topics = attrs[:related_topics]
    @organisations = []
  end

  def archived?
    false
  end

  def available_in_multiple_languages?
    false
  end

  def national_statistic?
    false
  end

  def state
    'published'
  end

  def has_operational_field?
    false
  end

  def allows_attachments?
    false
  end

  def alternative_format_contact_email
    nil
  end
end
