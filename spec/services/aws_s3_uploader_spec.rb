# frozen_string_literal: true

require "rails_helper"

RSpec.describe AwsS3Uploader do
  describe '.call' do
    let(:file) { instance_double(ActionDispatch::Http::UploadedFile) }
    let(:original_filename) { 'image.jpg' }
    let(:bucket) { instance_double(Aws::S3::Bucket) }
    let(:result) { instance_double(described_class::Result) }

    before do
      allow(file).to receive(:original_filename).and_return(original_filename)
      allow(described_class::BucketFetcher).to receive(:call).and_return(bucket)
    end

    context 'with no occurring errors' do
      let(:object) { instance_double(Aws::S3::Object) }
      let(:public_url) { 'public_url' }

      before do
        allow(bucket).to receive(:put_object).with(body: file, key: original_filename).and_return(object)
        allow(object).to receive(:public_url).and_return(public_url)
        allow(described_class::Result).to receive(:success).with(file: file, remote_url: public_url).and_return(result)
      end

      it 'returns success result structure' do
        expect(described_class.call(file)).to eq(result)
      end
    end

    context 'with occurring errors' do
      let(:s3_error) { Aws::S3::Errors::ServiceError.new(nil, error_message) }
      let(:error_message) { 'message' }

      before do
        allow(bucket).to receive(:put_object).and_raise(s3_error)
        allow(described_class::Result).to receive(:failure).with(file: file, message: error_message).and_return(result)
      end

      it 'returns failure result structure' do
        expect(described_class.call(file)).to eq(result)
      end
    end
  end
end
