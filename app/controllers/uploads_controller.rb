# frozen_string_literal: true

class UploadsController < ApplicationController
  def create
    @uploads_result = AwsS3Uploader.call(params[:files])
  end
end
