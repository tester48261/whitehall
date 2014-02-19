class AddUpcomingReleaseAnnouncementsTable < ActiveRecord::Migration
  def change
    create_table :upcoming_release_announcements do |t|
      t.timestamps
      t.string :title
      t.text :summary
      t.datetime :release_date
      t.string :release_date_text, length: 64
      t.integer :document_id
    end

    add_index :upcoming_release_announcements, :document_id
  end
end
