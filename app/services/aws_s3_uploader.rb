# frozen_string_literal: true

class AwsS3Uploader
  def self.call(files)
    new(files).call
  end

  def initialize(files)
    @files = files
  end

  def call
    in_threads do |file|
      object = bucket.put_object(body: file, key: file.original_filename)

      Result.success(file: file, remote_url: object.public_url)
    rescue StandardError => e
      Result.failure(file: file, message: e.message)
    end
  end

  private

  def in_threads
    threads = @files.map do |file|
      Thread.new do
        Thread.current[:result] = yield(file)
      end
    end.each(&:join)

    threads.map { |thread| thread[:result] }
  end

  def bucket
    @bucket ||= BucketFetcher.call
  end
end
