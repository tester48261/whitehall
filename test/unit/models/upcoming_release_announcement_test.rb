require 'test_helper'

class UpcomingReleaseAnnouncementTest < ActiveSupport::TestCase

  ### Validations

  test "validates presence of title" do
    refute build(:upcoming_release_announcement, title: '').valid?
  end

  test "validates presence of summary" do
    refute build(:upcoming_release_announcement, summary: '').valid?
  end

  test "validates presence of release_date" do
    refute build(:upcoming_release_announcement, release_date: nil).valid?
  end

  test "validates presence of document" do
    refute build(:upcoming_release_announcement, document: nil).valid?
  end


  ### Building

  def test_edition
    @test_edition ||= create(:edition)
  end

  def built_from_edition
    UpcomingReleaseAnnouncement.build_from_edition(test_edition)
  end

  test ".build_from_edition should make a UpcomingReleaseAnnouncement" do
    assert built_from_edition.is_a? UpcomingReleaseAnnouncement
  end

  test ".build_from_edition should use the edition's document" do
    assert_equal test_edition.document, built_from_edition.document
  end

  test ".build_from_edition should use the edition's title" do
    assert_equal test_edition.title, built_from_edition.title
  end

  test ".build_from_edition should use the edition's scheduled_publication date if present" do
    date = 1.year.from_now
    test_edition.scheduled_publication = date
    assert_equal date, built_from_edition.release_date
  end
end
