require 'test_helper'

class Edition::RoleAppointmentsTest < ActiveSupport::TestCase
  class EditionWithRoleAppointments < Edition
    include ::Edition::RoleAppointments
  end

  include ActionDispatch::TestProcess

  def valid_edition_attributes
    {
      title:   'edition-title',
      body:    'edition-body',
      summary: 'edition-summary',
      creator: build(:user)
    }
  end

  def bob_home_secretary
    @bob ||= build :role_appointment, person: build(:person, forename: "bob")
  end

  def jim_home_secretary
    @jim ||= build :role_appointment, person: build(:person, forename: "jim")
  end

  def appointments
    @appointments ||= [bob_home_secretary, jim_home_secretary]
  end

  setup do
    @edition = EditionWithRoleAppointments.new(valid_edition_attributes.merge(role_appointments: appointments))
  end

  test "edition can be created with role appointments" do
    assert_equal appointments, @edition.role_appointments
  end

  test "editions with role appointments can have no appointments set" do
    assert EditionWithRoleAppointments.new(valid_edition_attributes).valid?
  end

  test "copies the role appointments over to a new draft" do
    published = build :published_news_article, role_appointments: appointments
    assert_equal appointments, published.create_draft(build(:user)).role_appointments
  end

  test '#metadata should be empty if role appointments is empty' do
    edition = EditionWithRoleAppointments.new(valid_edition_attributes)

    assert_equal ({}), edition.metadata
  end

  test '#metadata should include names and links for role appointments' do
    amy = create(:role_appointment, person: create(:person, forename: 'Amy'))
    sid = create(:role_appointment, person: create(:person, forename: 'Sid'))
    edition = EditionWithRoleAppointments.new(valid_edition_attributes.merge(role_appointments: [amy, sid]))

    metadata = edition.metadata[:role_appointments]

    assert_equal 'Amy', metadata.first.text
    assert_equal '/government/people/amy', metadata.first.href

    assert_equal 'Sid', metadata.second.text
    assert_equal '/government/people/sid', metadata.second.href
  end
end
