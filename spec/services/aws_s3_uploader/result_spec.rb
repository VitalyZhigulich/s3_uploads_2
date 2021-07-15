# frozen_string_literal: true

require "rails_helper"

RSpec.describe AwsS3Uploader::Result do
  let(:file) { instance_double(ActionDispatch::Http::UploadedFile) }

  describe '.success' do
    let(:remote_url) { 'url' }

    it 'returns valid result container' do
      result = described_class.success(file: file, remote_url: remote_url)

      expect(result).to have_attributes(success: true, file: file, remote_url: remote_url)
    end
  end

  describe '.failure' do
    let(:message) { 'Region is not provided' }

    it 'returns valid result container' do
      result = described_class.failure(file: file, message: message)

      expect(result).to have_attributes(success: false, file: file, message: message)
    end
  end
end
