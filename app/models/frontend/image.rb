class Frontend::Image
  attr_reader :url, :alt_text, :caption

  def initialize(attrs = {})
    @url = attrs[:url]
    @alt_text = attrs[:alt_text]
    @caption = attrs[:caption]
  end
end
