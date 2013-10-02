module Whitehall
  module Uploader
    class ProgressLogger
      def initialize(import)
        @import = import
        @redis = Redis.new
        @errors_during = []
      end

      def with_transaction(row, &block)
        ActiveRecord::Base.transaction do
          begin
            @errors_during = []
            @redis.pipelined do
              @redis.sadd("imports:#{@import.id}:rows", row.row_number)
              @redis.del("imports:#{@import.id}:rows:#{row.row_number}")
              @redis.hmset("imports:#{@import.id}:rows:#{row.row_number}", row.row.flatten)
              @redis.publish("imports:#{@import.id}", {event: 'newRow', payload: row.row}.to_json)
            end

            yield

          # rescue => e
          #   self.error(e.to_s + "\n" + e.backtrace.join("\n"), row.row_number)
          end

          if @errors_during.any?
            @redis.hset("imports:#{@import.id}:rows:#{row.row_number}", 'errors', @errors_during.map(&:message).join("\n"))
            raise ActiveRecord::Rollback
          else
            @redis.hset("imports:#{@import.id}:rows:#{row.row_number}", 'success', true)
          end
        end
      end

      def start(rows)
        @import.update_column(:total_rows, rows.size)
        @import.update_column(:import_started_at, Time.zone.now)
      end

      def finish
        @import.update_column(:import_finished_at, Time.zone.now)
      end

      def info(message, row_number)
        write_log(:info, message, row_number)
      end

      def warn(message, row_number)
        write_log(:warning, message, row_number)
      end

      def error(error_message, row_number)
        @errors_during << @import.import_errors.create!(row_number: row_number, message: error_message)
      end

      def already_imported(document_source, row_number)
        error("#{document_source.url} already imported by import '#{document_source.import_id}' row '#{document_source.row_number}'", row_number)
      end

      def write_log(level, data, row_number)
        @import.import_logs.create(row_number: row_number, level: level, message: data)
      end
    end
  end
end
