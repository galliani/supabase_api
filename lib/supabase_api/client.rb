# frozen_string_literal: true

require 'httparty'

module SupabaseApi
  class Client
    include HTTParty

    def self.base_url
      SupabaseApi::Config.base_url
    end

    def self.api_version
      SupabaseApi::Config.api_version || 'v1'
    end

    def initialize
      @headers = {
        'apikey':         ENV['SUPABASE_KEY'],
        'Authorization':  "Bearer #{ENV['SUPABASE_KEY']}"
      }
    end

    def list(table_name)
      self.class.get(
        self.class.list_endpoint(table_name),
        headers: @headers.merge({
          'Range': '0-9'
        })
      )
    end

    def find(table_name, id)
      self.class.get(
        self.class.filtered_by_id_endpoint(table_name, id),
        headers: @headers.merge({
          'Range': '0-9'
        })
      )
    end

    def create(table_name, body)
      self.class.post(
        self.class.collection_endpoint(table_name),
        body:     body.to_json,
        headers:  @headers.merge({
          'Content-Type': 'application/json',
          'Prefer':       'return=representation'
        })
      )
    end

    def update(table_name, id, body)
      self.class.patch(
        self.class.filtered_by_id_endpoint(table_name, id),
        body:     body.to_json,
        headers:  @headers.merge({
          'Content-Type': 'application/json',
          'Prefer':       'return=representation'
        })
      )
    end

    def destroy(table_name, id)
      self.class.delete(
        self.class.filtered_by_id_endpoint(table_name, id),
        headers:  @headers.merge({
          'Content-Type': 'application/json',
          'Prefer':       'return=representation'
        })
      )      
    end

    private

    def self.collection_endpoint(table_name)
      base_url + "/rest/#{api_version}/#{table_name}"
    end

    def self.list_endpoint(table_name)
      "#{collection_endpoint(table_name)}?select=*"
    end

    def self.filtered_by_id_endpoint(table_name, id)
      "#{list_endpoint(table_name)}&id=eq.#{id}"
    end    
  end
end
