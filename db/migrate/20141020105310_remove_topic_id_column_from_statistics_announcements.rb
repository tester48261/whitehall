class RemoveTopicIdColumnFromStatisticsAnnouncements < ActiveRecord::Migration
  def change
    remove_column :statistics_announcements, :topic_id
  end
end
