require "test_helper"

class Edition::MinistersTest < ActiveSupport::TestCase
  class FakeEdition < Edition
    include Edition::Ministers
  end

  test "#destroy should also remove the relationship" do
    edition = create(:draft_policy, ministerial_roles: [create(:ministerial_role)])
    relation = edition.edition_ministerial_roles.first
    edition.destroy
    refute EditionMinisterialRole.find_by_id(relation.id)
  end

  test '#metadata should be empty if ministerial roles is empty' do
    edition = FakeEdition.new(attributes_for_edition)

    assert_equal ({}), edition.metadata
  end

  test '#metadata should include names and links for ministerial roles' do
    minister = create(:ministerial_role, name: 'Agriculture Minister')
    edition = FakeEdition.new(attributes_for_edition.merge(ministerial_roles: [minister]))

    metadata = edition.metadata[:ministerial_roles]

    assert_equal 'Agriculture Minister', metadata.first.text
    assert_equal '/government/ministers/agriculture-minister', metadata.first.href
  end

  test '#metadata should include names for people and links for ministerial roles' do
    minister = create(:ministerial_role, name: 'Agriculture Minister')
    person = create(:person, forename: 'John')
    create(:ministerial_role_appointment, role: minister, person: person)
    edition = FakeEdition.new(attributes_for_edition.merge(ministerial_roles: [minister]))

    metadata = edition.metadata[:ministerial_roles]

    assert_equal 'John', metadata.first.text
    assert_equal '/government/ministers/agriculture-minister', metadata.first.href
  end

private
  def attributes_for_edition
    attributes_for(:edition).merge(creator: build(:creator))
  end
end
