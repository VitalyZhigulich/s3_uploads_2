# frozen_string_literal: true

class AwsS3Uploader
  def self.call(file)
    bucket = BucketFetcher.call
    object = bucket.put_object(body: file, key: file.original_filename)

    Result.success(file: file, remote_url: object.public_url)
  rescue StandardError => e
    Result.failure(file: file, message: e.message)
  end
end
