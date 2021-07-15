# frozen_string_literal: true

require "rails_helper"

RSpec.describe AwsS3Uploader do
  describe '.call' do
    let(:files) { [file1, file2] }
    let(:file1) { instance_double(ActionDispatch::Http::UploadedFile) }
    let(:file2) { instance_double(ActionDispatch::Http::UploadedFile) }
    let(:original_filename1) { 'image1.jpg' }
    let(:original_filename2) { 'image2.jpg' }

    let(:bucket) { instance_double(Aws::S3::Bucket) }

    let(:object) { instance_double(Aws::S3::Object) }
    let(:public_url) { 'public_url' }

    let(:s3_error) { Aws::S3::Errors::ServiceError.new(nil, error_message) }
    let(:error_message) { 'message' }

    let(:result1) { instance_double(described_class::Result) }
    let(:result2) { instance_double(described_class::Result) }

    before do
      allow(described_class::BucketFetcher).to receive(:call).and_return(bucket)

      allow(file1).to receive(:original_filename).and_return(original_filename1)
      allow(file2).to receive(:original_filename).and_return(original_filename2)

      allow(bucket).to receive(:put_object).with(body: file1, key: original_filename1).and_return(object)
      allow(bucket).to receive(:put_object).with(body: file2, key: original_filename2).and_raise(s3_error)

      allow(object).to receive(:public_url).and_return(public_url)

      allow(described_class::Result).to receive(:success).with(file: file1, remote_url: public_url).and_return(result1)
      allow(described_class::Result).to receive(:failure).with(file: file2, message: error_message).and_return(result2)
    end

    it 'returns array of upload results' do
      expect(described_class.call(files)).to eq([result1, result2])
    end
  end
end
