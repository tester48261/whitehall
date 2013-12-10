require "test_helper"

class Edition::NationInapplicabilityTest < ActiveSupport::TestCase
  class FakeEdition < Edition
    include Edition::NationalApplicability
  end

  test "#destroy should also remove the relationship" do
    edition = create(:draft_policy, nation_inapplicabilities_attributes: [{nation: Nation.potentially_inapplicable.first}])
    relation = edition.nation_inapplicabilities.first
    edition.destroy
    refute NationInapplicability.find_by_id(relation.id)
  end

  test '#metadata should be empty when edition applies to all nations' do
    edition = FakeEdition.new

    assert_equal ({}), edition.metadata
  end

  test '#metadata should list applicable nations when edition only applies to some nations' do
    scotland = create(:nation_inapplicability, nation: Nation.scotland)
    edition = FakeEdition.new(nation_inapplicabilities: [scotland])

    metadata = edition.metadata[:applies_to_nations]

    assert_equal 'England', metadata.first.text
    assert_equal nil, metadata.first.href

    assert_equal 'Wales', metadata.second.text
    assert_equal nil, metadata.second.href

    assert_equal 'Northern Ireland', metadata.third.text
    assert_equal nil, metadata.third.href
  end

  test '#metadata should list alternatives for nations when urls exists' do
    scotland = create(:nation_inapplicability, nation: Nation.scotland, alternative_url: 'http://example.com/scotland')
    edition = FakeEdition.new(nation_inapplicabilities: [scotland])

    metadata = edition.metadata[:applies_to_nations]

    assert_equal 'England', metadata.first.text
    assert_equal nil, metadata.first.href

    assert_equal 'Wales', metadata.second.text
    assert_equal nil, metadata.second.href

    assert_equal 'Northern Ireland', metadata.third.text
    assert_equal nil, metadata.third.href

    assert_equal 'Scotland', metadata.fourth.text
    assert_equal 'http://example.com/scotland', metadata.fourth.href
  end
end
