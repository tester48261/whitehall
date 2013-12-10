class Topic < Classification
  include HasTopTasks

  def search_link
    Whitehall.url_maker.topic_path(slug)
  end
end
