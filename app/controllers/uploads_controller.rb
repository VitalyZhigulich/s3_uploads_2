# frozen_string_literal: true

class UploadsController < ApplicationController
  def create
    @upload_result = AwsS3Uploader.call(params[:file])
  end
end
