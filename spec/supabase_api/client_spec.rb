require 'spec_helper'

RSpec.describe SupabaseApi::Client do
  before { SupabaseApi::Config.base_url = 'https://thiswouldberandomstring.supabase.co' }

  let(:table_name)  { 'resources' }
  let(:sample_id)   { 2 }

  describe "#list" do
    let(:stubbed_body) do
      [
        {"id":1,"name":"sample_record_1","status":"active"},
        {"id":2,"name":"sample_record_2","status":"pending"}
      ]
    end

    subject { described_class.new.list(table_name) }

    before do
      @stub = stub_request(:get, described_class.list_endpoint(table_name)).
        to_return(
          status: 200,
          body: stubbed_body.to_json
        )
    end

    it 'should send GET request unfiltered' do
      subject

      expect(@stub).to have_been_requested
    end

    it 'should return an HTTParty Response instance' do
      expect(subject.class).to eq HTTParty::Response
    end

    it 'should have the returned body accessible' do
      response = JSON.parse(subject.body).first

      response.each do |key, value|
        expect(response[key]).to eq stubbed_body.first[key.to_sym]
      end
    end
  end

  describe "#find" do
    let(:stubbed_body) do
      [
        {"id":2,"name":"sample_record_2","status":"pending"}
      ]
    end

    subject { described_class.new.find(table_name, sample_id) }

    before do
      @stub = stub_request(:get, described_class.filtered_by_id_endpoint(table_name, sample_id)).
        to_return(
          status: 200,
          body: stubbed_body.to_json
        )
    end

    it 'should send GET request with ID in the path' do
      subject

      expect(@stub).to have_been_requested
    end

    it 'should return an HTTParty Response instance' do
      expect(subject.class).to eq HTTParty::Response
    end

    it 'should have the returned body accessible' do
      response = JSON.parse(subject.body).first

      response.each do |key, value|
        expect(response[key]).to eq stubbed_body.first[key.to_sym]
      end
    end
  end

  describe "#create" do
    let(:table_name) { 'resources' }

    context 'single rows' do
      let(:request_body) do
        { name: "sample_record_1", status: "active" }
      end

      subject { described_class.new.create(table_name, request_body) }

      before do
        @stub = stub_request(:post, described_class.collection_endpoint(table_name)).
          to_return(
            status: 201,
            body: [request_body.merge(id: 100)].to_json
          )
      end

      it 'should send POST request unfiltered' do
        subject

        expect(@stub).to have_been_requested
      end

      it 'should return an HTTParty Response instance' do
        expect(subject.class).to eq HTTParty::Response
      end

      it 'should return a parsed JSON' do
        response = JSON.parse(subject.body).first

        response.each do |key, value|
          if key == 'id'
            expect(response[key]).to_not eq nil
          else
            expect(response[key]).to eq request_body[key.to_sym]
          end
        end
      end
    end
  end

  describe "#update" do
    context 'single rows' do
      let(:request_body) do
        { status: "expired" }
      end

      subject { described_class.new.update(table_name, sample_id, request_body) }

      before do
        @stub = stub_request(:patch, described_class.filtered_by_id_endpoint(table_name, sample_id)).
          to_return(
            status: 200,
            body: [request_body].to_json
          )
      end

      it 'should send PATCH request' do
        subject

        expect(@stub).to have_been_requested
      end

      it 'should return an HTTParty Response instance' do
        expect(subject.class).to eq HTTParty::Response
      end

      it 'should return a parsed JSON' do
        response = JSON.parse(subject.body).first

        response.each do |key, value|
          if key == 'id'
            expect(response[key]).to_not eq nil
          else
            expect(response[key]).to eq request_body[key.to_sym]
          end
        end
      end
    end
  end

  describe "#destroy" do
    context 'single rows' do
      subject { described_class.new.destroy(table_name, sample_id) }

      before do
        @stub = stub_request(:delete, described_class.filtered_by_id_endpoint(table_name, sample_id)).
          to_return(
            status: 204,
            body: nil
          )
      end

      it 'should send DELETE request' do
        subject

        expect(@stub).to have_been_requested
      end

      it 'should return an HTTParty Response instance' do
        expect(subject.class).to eq HTTParty::Response
      end

      it 'should return a BLANK JSON response body' do
        expect(subject.body).to eq nil
      end
    end
  end
end
