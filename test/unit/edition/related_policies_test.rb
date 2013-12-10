require "test_helper"

class Edition::RelatedPoliciesTest < ActiveSupport::TestCase
  class FakeEdition < Edition
    include Edition::RelatedPolicies
  end

  test "#destroy should also remove the relationship to existing policies" do
    edition = create(:draft_consultation, related_editions: [create(:draft_policy)])
    relation = edition.outbound_edition_relations.first
    edition.destroy
    refute EditionRelation.exists?(relation.id)
  end

  test "can set the policies without removing the other documents" do
    edition = create(:world_location_news_article)
    worldwide_priority = create(:worldwide_priority)
    old_policy = create(:policy)
    edition.related_editions = [worldwide_priority, old_policy]

    new_policy = create(:policy)
    edition.related_policy_ids = [new_policy.id]
    assert_equal [worldwide_priority], edition.worldwide_priorities
    assert_equal [new_policy], edition.related_policies
  end

  test '#metadata should be empty if policies is empty' do
    edition = FakeEdition.new(attributes_for_edition)

    assert_equal ({}), edition.metadata
  end

  test '#metadata should include policy titles and links' do
    economy = create(:policy, title: 'Improving the Economy')
    crime = create(:policy, title: 'Reducing Crime')
    edition = FakeEdition.new(attributes_for_edition.merge(related_policies: [economy, crime]))

    metadata = edition.metadata[:policies]

    assert_equal 'Improving the Economy', metadata.first.text
    assert_equal '/government/policies/improving-the-economy', metadata.first.href

    assert_equal 'Reducing Crime', metadata.second.text
    assert_equal '/government/policies/reducing-crime', metadata.second.href
  end

private
  def attributes_for_edition
    attributes_for(:edition).merge(creator: build(:creator))
  end
end
