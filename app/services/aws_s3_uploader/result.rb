# frozen_string_literal: true

class AwsS3Uploader::Result
  Container = Struct.new(:success, :file, :remote_url, :message)

  class << self
    def success(file:, remote_url:)
      Container.new(true, file, remote_url, nil)
    end

    def failure(file:, message:)
      Container.new(false, file, nil, message.to_s)
    end
  end
end
