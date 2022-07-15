require 'spec_helper'

RSpec.describe SupabaseApi::Record do
  let(:sample_table_name) { 'resources' }
  let(:sample_id) { 100 }

  before do
    allow(described_class).to receive(:table_name).and_return(sample_table_name)
  end

  describe "#table_name" do
    before do
      allow(described_class).to receive(:table_name).and_call_original
    end

    it 'should raise error if not overriden' do
      expect { described_class.table_name }.to raise_error ArgumentError
    end
  end

  describe "#find" do
    context 'with record NOT found' do
      before do
        @request_object = HTTParty::Request.new Net::HTTP::Get, '/'
        @response_object = Net::HTTPOK.new('1.1', 404, 'OK')
        allow(@response_object).to receive_messages(body: [].to_json)
        @parsed_response = lambda { [] }
        @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

        allow_any_instance_of(SupabaseApi::Client).to receive(:find).and_return(
          @response
        )
      end

      subject { described_class.find(sample_id) }

      it "should raise an exception" do
        expect { subject }.to raise_error(SupabaseApi::RecordNotFound)
      end
    end

    context 'with record found' do
      before do
        @request_object = HTTParty::Request.new Net::HTTP::Get, '/'
        @response_object = Net::HTTPOK.new('1.1', 200, 'OK')
        allow(@response_object).to receive_messages(body: [{ id: sample_id }].to_json)
        @parsed_response = lambda { [{ "id" => sample_id }] }
        @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

        allow_any_instance_of(SupabaseApi::Client).to receive(:find).and_return(
          @response
        )
      end

      subject { described_class.find(sample_id) }

      it "should call .find method of Client class" do
        expect_any_instance_of(SupabaseApi::Client).to receive(:find).with(sample_table_name, sample_id)

        subject
      end

      it "should return an instance of the class" do
        record = subject

        expect(record.class).to eq described_class
        expect(record.id).to eq described_class.new(id: sample_id).id
      end
    end    
  end

  describe "#find_by_id" do
    context 'with record NOT found' do
      before do
        @request_object = HTTParty::Request.new Net::HTTP::Get, '/'
        @response_object = Net::HTTPOK.new('1.1', 404, 'OK')
        allow(@response_object).to receive_messages(body: [].to_json)
        @parsed_response = lambda { [] }
        @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

        allow_any_instance_of(SupabaseApi::Client).to receive(:find).and_return(
          @response
        )
      end

      subject { described_class.find_by_id(sample_id) }

      it "should NOT raise an exception" do
        expect { subject }.to_not raise_error(SupabaseApi::RecordNotFound)
      end
    end

    context 'with record found' do
      before do
        @request_object = HTTParty::Request.new Net::HTTP::Get, '/'
        @response_object = Net::HTTPOK.new('1.1', 200, 'OK')
        allow(@response_object).to receive_messages(body: [{ id: sample_id }].to_json)
        @parsed_response = lambda { [{ "id" => sample_id }] }
        @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

        allow_any_instance_of(SupabaseApi::Client).to receive(:find).and_return(
          @response
        )
      end

      subject { described_class.find(sample_id) }

      it "should call .find method of Client class" do
        expect_any_instance_of(SupabaseApi::Client).to receive(:find).with(sample_table_name, sample_id)

        subject
      end

      it "should return an instance of the class" do
        record = subject

        expect(record.class).to eq described_class
        expect(record.id).to eq described_class.new(id: sample_id).id
      end
    end    
  end

  describe "#all" do
    subject { described_class.all }

    context 'with record NOT found' do
      before do
        @request_object   = HTTParty::Request.new Net::HTTP::Get, '/'
        @response_object  = Net::HTTPOK.new('1.1', 200, 'OK')
        allow(@response_object).to receive_messages(body: [].to_json)

        @parsed_response = lambda { [] }
        @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

        allow_any_instance_of(SupabaseApi::Client).to receive(:list).and_return(
          @response
        )
      end

      it "should NOT raise an exception" do
        expect { subject }.to_not raise_error(SupabaseApi::RecordNotFound)
      end

      it "should return an empty array" do
        record = subject

        expect(record.class).to eq Array
      end      
    end

    context 'with record found' do
      before do
        @request_object = HTTParty::Request.new Net::HTTP::Get, '/'
        @response_object = Net::HTTPOK.new('1.1', 200, 'OK')
        allow(@response_object).to receive_messages(body: [{ id: sample_id }].to_json)
        @parsed_response = lambda { [{ "id" => sample_id }] }
        @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

        allow_any_instance_of(SupabaseApi::Client).to receive(:list).and_return(
          @response
        )
      end

      it "should call .list method of Client class" do
        expect_any_instance_of(SupabaseApi::Client).to receive(:list).with(sample_table_name, {})

        subject
      end

      it "should return an array of instances of the class" do
        record = subject

        expect(record.class).to eq Array
        expect(record.first.class).to eq described_class
      end
    end    
  end

  describe "#where" do
    subject { described_class.where(params) }

    context 'without any parameter' do
      let(:params) { {} }

      context 'with record NOT found' do
        before do
          @request_object   = HTTParty::Request.new Net::HTTP::Get, '/'
          @response_object  = Net::HTTPOK.new('1.1', 200, 'OK')
          allow(@response_object).to receive_messages(body: [].to_json)

          @parsed_response = lambda { [] }
          @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

          allow_any_instance_of(SupabaseApi::Client).to receive(:list).with(described_class.table_name, params).and_return(
            @response
          )
        end

        it "should NOT raise an exception" do
          expect { subject }.to_not raise_error(SupabaseApi::RecordNotFound)
        end

        it "should return an empty array" do
          record = subject

          expect(record.class).to eq Array
        end      
      end

      context 'with record found' do
        before do
          @request_object = HTTParty::Request.new Net::HTTP::Get, '/'
          @response_object = Net::HTTPOK.new('1.1', 200, 'OK')
          allow(@response_object).to receive_messages(body: [{ id: sample_id }].to_json)
          @parsed_response = lambda { [{ "id" => sample_id }] }
          @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

          allow_any_instance_of(SupabaseApi::Client).to receive(:list).with(described_class.table_name, params).and_return(
            @response
          )
        end

        it "should call .list method of Client class" do
          expect_any_instance_of(SupabaseApi::Client).to receive(:list).with(sample_table_name, {})

          subject
        end

        it "should return an array of instances of the class" do
          record = subject

          expect(record.class).to eq Array
          expect(record.first.class).to eq described_class
        end
      end
    end

    context 'with parameter' do
      let(:params) { { name: 'lorem' } }

      context 'with record NOT found' do
        before do
          @request_object   = HTTParty::Request.new Net::HTTP::Get, '/'
          @response_object  = Net::HTTPOK.new('1.1', 200, 'OK')
          allow(@response_object).to receive_messages(body: [].to_json)

          @parsed_response = lambda { [] }
          @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

          allow_any_instance_of(SupabaseApi::Client).to receive(:list).with(described_class.table_name, params).and_return(
            @response
          )
        end

        it "should NOT raise an exception" do
          expect { subject }.to_not raise_error(SupabaseApi::RecordNotFound)
        end

        it "should return an empty array" do
          record = subject

          expect(record.class).to eq Array
        end      
      end

      context 'with record found' do
        before do
          @request_object = HTTParty::Request.new Net::HTTP::Get, '/'
          @response_object = Net::HTTPOK.new('1.1', 200, 'OK')
          allow(@response_object).to receive_messages(body: [{ id: sample_id }].to_json)
          @parsed_response = lambda { [{ "id" => sample_id }] }
          @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

          allow_any_instance_of(SupabaseApi::Client).to receive(:list).with(described_class.table_name, params).and_return(
            @response
          )
        end

        it "should call .list method of Client class" do
          expect_any_instance_of(SupabaseApi::Client).to receive(:list).with(sample_table_name, params)

          subject
        end

        it "should return an array of instances of the class" do
          record = subject

          expect(record.class).to eq Array
          expect(record.first.class).to eq described_class
        end
      end
    end    
  end

  describe ".create" do
    context 'single row' do
      let(:params) { { name: 'new record', status: 'active' } }

      context 'when not successful due to parameter' do
        it "should call .create method of Client class"
        it "should return nil"
      end

      context 'when successful' do
        before do
          @request_object = HTTParty::Request.new Net::HTTP::Post, '/'
          @response_object = Net::HTTPCreated.new('1.1', 201, 'CREATED')
          allow(@response_object).to receive_messages(body: [ params.merge(id: sample_id) ].to_json)

          @parsed_response = lambda { [ params.merge(id: sample_id) ] }
          @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

          allow_any_instance_of(SupabaseApi::Client).to receive(:create).and_return(
            @response
          )        
        end

        subject { described_class.create(params) }

        it "should call .create method of Client class" do
          expect_any_instance_of(SupabaseApi::Client).to receive(:create).with(sample_table_name, params)

          subject
        end

        it "should return an instance of the class" do
          record = subject

          expect(record.class).to eq described_class
          expect(record.id).to eq described_class.new(id: sample_id).id
        end
      end
    end

    context 'multiple rows' do
      let(:params) do
        [
          { name: 'new first row record', status: 'active' },
          { name: 'new second row record', status: 'pending' }
        ]
      end

      context 'when not successful due to parameter' do
        it "should call .create method of Client class"
        it "should return nil"
      end

      context 'when successful' do
        let(:expected_output) do
          params.each_with_index do |key_value, index|
            key_value[:id] = index + 20
          end

          params
        end

        before do
          @request_object = HTTParty::Request.new Net::HTTP::Post, '/'
          @response_object = Net::HTTPCreated.new('1.1', 201, 'CREATED')
          allow(@response_object).to receive_messages(body: expected_output.to_json)

          @parsed_response = lambda { expected_output }
          @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

          allow_any_instance_of(SupabaseApi::Client).to receive(:create).and_return(
            @response
          )        
        end

        subject { described_class.create(params) }

        it "should call .create method of Client class" do
          expect_any_instance_of(SupabaseApi::Client).to receive(:create).with(sample_table_name, params)

          subject
        end

        it "should return an array containing instances of the class" do
          records = subject

          expect(records.class).to eq Array

          records.each do |record|
            expect(record.class).to       eq described_class
            expect(record.id).to_not      eq nil
            expect(record.name).to_not    eq nil
            expect(record.status).to_not  eq nil
          end
        end
      end
    end    
  end

  describe ".save" do
    let(:params) { { status: 'expired' } }

    context 'for existing record' do
      let(:existing_record) do
        SupabaseApi::Record.new(
          id: sample_id,
          name: 'existing record',
          status: 'active'
        )        
      end

      before do
        allow(described_class).to receive(:new).and_return(existing_record)

        @request_object = HTTParty::Request.new Net::HTTP::Patch, '/'
        @response_object = Net::HTTPOK.new('1.1', 200, 'OK')
        allow(@response_object).to receive_messages(body: [ params.merge(id: sample_id, name: 'Not Updated') ].to_json)

        @parsed_response = lambda { [ params.merge(id: sample_id, name: 'Not Updated') ] }
        @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

        allow_any_instance_of(SupabaseApi::Client).to receive(:update).and_return(
          @response
        )        
      end

      subject { existing_record.save }

      it "should call .update method of Client class" do
        existing_record.assign_attributes(params)
        expect_any_instance_of(SupabaseApi::Client).to receive(:update).with(sample_table_name, existing_record.id, existing_record.attributes)

        subject
      end

      it "should return an instance of the class" do
        record = subject

        expect(record.class).to eq described_class
        expect(record.id).to eq existing_record.id
      end
    end
  end

  describe ".destroy" do
    let(:existing_record) do
      SupabaseApi::Record.new(
        id: sample_id,
        name: 'existing record',
        status: 'active'
      )        
    end

    subject { existing_record.destroy }

    context 'with missing ID for delete' do
      it "should raise an exception" do
        existing_record.id = nil
        expect { subject }.to raise_error(SupabaseApi::InvalidRequest)
      end      
    end

    context 'with record failed to be deleted' do
      before do
        @request_object = HTTParty::Request.new Net::HTTP::Delete, '/'
        @response_object = Net::HTTPNotFound.new('1.1', 404, 'Not Found')
        allow(@response_object).to receive_messages(body: '')
        @parsed_response = lambda { [] }
        @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

        allow_any_instance_of(SupabaseApi::Client).to receive(:destroy).and_return(
          @response
        )
      end


      it "should raise an exception" do
        expect { subject }.to raise_error(SupabaseApi::RecordNotDestroyed)
      end
    end

    context 'with record found' do
      before do
        @request_object = HTTParty::Request.new Net::HTTP::Delete, '/'
        @response_object = Net::HTTPNoContent.new('1.1', 204, 'No Content')
        allow(@response_object).to receive_messages(body: '')
        @parsed_response = lambda { '' }
        @response = HTTParty::Response.new(@request_object, @response_object, @parsed_response)

        allow_any_instance_of(SupabaseApi::Client).to receive(:destroy).and_return(
          @response
        )
      end

      it "should call .find method of Client class" do
        expect_any_instance_of(SupabaseApi::Client).to receive(:destroy).with(sample_table_name, existing_record.id)

        subject
      end

      it "should return a true boolean" do
        expect(subject).to eq true
      end
    end    
  end
end