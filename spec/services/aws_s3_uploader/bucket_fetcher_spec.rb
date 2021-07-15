# frozen_string_literal: true

require "rails_helper"

RSpec.describe AwsS3Uploader::BucketFetcher do
  describe '.call' do
    let(:resource) { instance_double(Aws::S3::Resource) }
    let(:bucket_name) { 'bucket name' }
    let(:bucket) { instance_double(Aws::S3::Bucket) }

    before do
      allow(Aws::S3::Resource).to receive(:new).and_return(resource)
      allow(ENV).to receive(:[]).with('AWS_S3_BUCKET_NAME').and_return(bucket_name)
      allow(resource).to receive(:bucket).with(bucket_name).and_return(bucket)
    end

    it 'return AWS::S3::Bucket object' do
      expect(described_class.call).to eq(bucket)
    end
  end
end
