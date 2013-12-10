require "test_helper"

class Edition::WorldLocationsTest < ActiveSupport::TestCase
  class FakeEdition < Edition
    include Edition::WorldLocations
  end

  test "#destroy should also remove the relationship" do
    edition = create(:draft_policy, world_locations: [create(:world_location)])
    relation = edition.edition_world_locations.first
    edition.destroy
    refute EditionWorldLocation.find_by_id(relation.id)
  end

  test '#metadata should be empty if world locations is empty' do
    edition = FakeEdition.new(attributes_for_edition)

    assert_equal ({}), edition.metadata
  end

  test '#metadata should include names and links for world locations' do
    france = create(:world_location, name: 'France')
    germany = create(:world_location, name: 'Germany')
    edition = FakeEdition.new(attributes_for_edition.merge(world_locations: [france, germany]))

    metadata = edition.metadata[:world_locations]

    assert_equal 'France', metadata.first.text
    assert_equal '/government/world/france', metadata.first.href

    assert_equal 'Germany', metadata.second.text
    assert_equal '/government/world/germany', metadata.second.href
  end

  test '#metadata should include only names for world locations if world_feature flag is off' do
    Whitehall.stubs(:world_feature?).returns(false)

    france = create(:world_location, name: 'France')
    germany = create(:world_location, name: 'Germany')
    edition = FakeEdition.new(attributes_for_edition.merge(world_locations: [france, germany]))

    metadata = edition.metadata[:world_locations]

    assert_equal 'France', metadata.first.text
    assert_equal nil, metadata.first.href

    assert_equal 'Germany', metadata.second.text
    assert_equal nil, metadata.second.href
  end

private
  def attributes_for_edition
    attributes_for(:edition).merge(creator: build(:creator))
  end
end
