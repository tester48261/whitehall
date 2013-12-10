require "test_helper"

class Edition::WorldwideOrganisationsTest < ActiveSupport::TestCase
  class FakeEdition < Edition
    include Edition::WorldwideOrganisations
  end

  test "can be associated with worldwide organisations" do
    assert WorldwidePriority.new.can_be_associated_with_worldwide_organisations?
  end

  test "#destroy removes association with organisations" do
    organisation = create(:worldwide_organisation)
    edition = create(:draft_worldwide_priority, worldwide_organisations: [organisation])
    edition.destroy
    refute edition.edition_worldwide_organisations.any?
    assert WorldwideOrganisation.exists?(organisation)
  end

  test "new editions carry over worldwide organisations" do
    organisation = create(:worldwide_organisation)
    priority = create(:published_worldwide_priority, worldwide_organisations: [organisation])
    new_edition = priority.create_draft(create(:policy_writer))
    new_edition.change_note = 'change-note'
    force_publish(new_edition)

    assert_equal [organisation], new_edition.worldwide_organisations
  end

  test '#metadata should be empty if worldwide organisations is empty' do
    edition = FakeEdition.new(attributes_for_edition)

    assert_equal ({}), edition.metadata
  end

  test '#metadata should include names and links for worldwide organisations' do
    embassy = create(:worldwide_organisation, name: 'British Embassy Paris')
    dfid = create(:worldwide_organisation, name: 'DFID Gambia')
    edition = FakeEdition.new(attributes_for_edition)
    edition.worldwide_organisations = [embassy, dfid]

    metadata = edition.metadata[:worldwide_organisations]

    assert_equal 'British Embassy Paris', metadata.first.text
    assert_equal '/government/world/organisations/british-embassy-paris', metadata.first.href

    assert_equal 'DFID Gambia', metadata.second.text
    assert_equal '/government/world/organisations/dfid-gambia', metadata.second.href
  end

  test '#metadata should include only names for worldwide organisations if world_feature flag is off' do
    Whitehall.stubs(:world_feature?).returns(false)

    embassy = create(:worldwide_organisation, name: 'British Embassy Paris')
    dfid = create(:worldwide_organisation, name: 'DFID Gambia')
    edition = FakeEdition.new(attributes_for_edition)
    edition.worldwide_organisations = [embassy, dfid]

    metadata = edition.metadata[:worldwide_organisations]

    assert_equal 'British Embassy Paris', metadata.first.text
    assert_equal nil, metadata.first.href

    assert_equal 'DFID Gambia', metadata.second.text
    assert_equal nil, metadata.second.href
  end

private
  def attributes_for_edition
    attributes_for(:edition).merge(creator: build(:creator))
  end
end
