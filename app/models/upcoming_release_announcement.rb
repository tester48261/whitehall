class UpcomingReleaseAnnouncement < ActiveRecord::Base
  belongs_to :document

  validates :title, :presence => true
  validates :summary, :presence => true
  validates :release_date, :presence => true
  validates :document, :presence => true

  after_save :push_to_rummager
  after_destroy :remove_from_rummager

  def self.build_from_edition(edition)
    new(
      document: edition.document,
      title: edition.title,
      release_date: edition.scheduled_publication
    )
  end

private
  def push_to_rummager
  end

  def remove_from_rummager
  end

end
