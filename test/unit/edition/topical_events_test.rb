require 'test_helper'

class Edition::TopicalEventsTest < ActiveSupport::TestCase
  class FakeEdition < Edition
    include Edition::TopicalEvents
  end

  test "#destroy should also remove the classification memebership relationship" do
    topical_event = create(:topical_event)
    edition = create(:published_news_article, topical_events: [topical_event])
    relation = edition.classification_memberships.first
    edition.destroy
    refute ClassificationMembership.find_by_id(relation.id)
  end

  test "new edition of document that is a member of a topical event should remain a member of that topical event" do
    topical_event = create(:topical_event)
    edition = create(:published_news_article, topical_events: [topical_event])

    new_edition = edition.create_draft(create(:policy_writer))
    new_edition.change_note = 'change-note'
    force_publish(new_edition)

    assert_equal topical_event, new_edition.topical_events.first
  end

  test "#destroy should also remove the classification featuring relationship" do
    topical_event = create(:topical_event)
    edition = create(:published_news_article)
    rel = topical_event.feature(edition_id: edition.id, alt_text: 'Woooo', image: create(:classification_featuring_image_data))
    relation = edition.classification_featurings.first
    edition.destroy
    refute ClassificationFeaturing.find_by_id(relation.id)
  end

  test "new edition of document featured in topical event should remain featured in that topic event with image, alt text and ordering" do
    featured_image = create(:classification_featuring_image_data)
    topical_event = create(:topical_event)
    edition = create(:published_news_article)
    topical_event.feature(edition_id: edition.id, image: featured_image, alt_text: "alt-text", ordering: 12)

    new_edition = edition.create_draft(create(:policy_writer))
    new_edition.change_note = 'change-note'
    force_publish(new_edition)

    featuring = new_edition.classification_featurings.first
    assert featuring.persisted?
    assert_equal featured_image, featuring.image
    assert_equal "alt-text", featuring.alt_text
    assert_equal 12, featuring.ordering
    assert_equal topical_event, featuring.classification
  end

  test '#metadata should be empty if topical events is empty' do
    edition = FakeEdition.new(attributes_for_edition)

    assert_equal ({}), edition.metadata
  end

  test '#metadata should include topical event names and links' do
    jubilee = create(:topical_event, name: 'Jubilee')
    centenary = create(:topical_event, name: 'Centenary')
    edition = FakeEdition.new(attributes_for_edition.merge(topical_events: [jubilee, centenary]))

    metadata = edition.metadata[:topical_events]

    assert_equal 'Jubilee', metadata.first.text
    assert_equal '/government/topical-events/jubilee', metadata.first.href

    assert_equal 'Centenary', metadata.second.text
    assert_equal '/government/topical-events/centenary', metadata.second.href
  end

private
  def attributes_for_edition
    attributes_for(:edition).merge(creator: build(:creator))
  end
end
