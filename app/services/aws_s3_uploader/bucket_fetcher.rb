# frozen_string_literal: true

class AwsS3Uploader::BucketFetcher
  def self.call
    resource = Aws::S3::Resource.new
    bucket_name = ENV['AWS_S3_BUCKET_NAME']

    resource.bucket(bucket_name)
  end
end
