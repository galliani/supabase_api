require 'spec_helper'

RSpec.describe SupabaseApi::Record do
  describe "#table_endpoint" do
    it 'should raise error if not overriden' do
      expect { described_class.table_endpoint }.to raise_error ArgumentError
    end
  end

  describe "#find" do
    before do
      allow(SupabaseApi::Client).to receive(:find).and_return(
        {
          id: 10
        }
      )
    end

    it "should call Client.find method" do
      expect(SupabaseApi::Client).to receive(:find).with(10)

      described_class.find(10)
    end

    it "should return an instance of the class" do
      record = described_class.find(10)

      expect(record.class).to eq described_class
      expect(record.id).to eq described_class.new(id: 10).id
    end    
  end

  describe ".save" do
    let(:sample) { described_class.new(name: 'new record') }

    before do
      allow(SupabaseApi::Client).to receive(:save).and_return(true)
    end

    subject { sample.save }

    it "should call Client.save method" do
      expect(SupabaseApi::Client).to receive(:save).with(
        { :name => 'new record' }
      )

      subject
    end

    it "should return true indicating success" do
      expect(subject).to eq true
    end    
  end
end