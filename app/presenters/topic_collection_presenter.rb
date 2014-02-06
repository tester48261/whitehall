class TopicCollectionPresenter < Struct.new(:topic_collection)
  def as_json(opts = {})
    topic_collection.map { |topic| TopicPresenter.new(topic).as_json }
  end
end
