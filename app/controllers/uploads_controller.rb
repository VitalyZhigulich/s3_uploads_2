class UploadsController < ApplicationController
  def create
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(ENV['AWS_S3_BUCKET'])

    file = params[:file]
    object = bucket.put_object(body: file, key: file.original_filename)

    @upload_url = object.public_url
  end
end
