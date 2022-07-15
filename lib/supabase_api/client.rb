# frozen_string_literal: true

require 'httparty'
require 'rack'

module SupabaseApi
  class Client
    include HTTParty

    def self.base_url
      SupabaseApi::Config.base_url
    end

    def self.api_version
      SupabaseApi::Config.api_version || 'v1'
    end

    def self.api_key
      SupabaseApi::Config.api_key
    end

    def initialize
      @headers = {
        'apikey':         self.class.api_key,
        'Authorization':  "Bearer #{self.class.api_key}"
      }
    end

    def list(table_name, params = {})
      self.class.get(
        self.class.list_endpoint(table_name, params),
        headers: @headers.merge({
          'Range': '0-9'
        })
      )
    end

    def find(table_name, id)
      list(table_name, { id: id })
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
        self.class.list_endpoint(table_name, { id: id }),
        body:     body.to_json,
        headers:  @headers.merge({
          'Content-Type': 'application/json',
          'Prefer':       'return=representation'
        })
      )
    end

    def destroy(table_name, id)
      self.class.delete(
        self.class.list_endpoint(table_name, { id: id })
      )      
    end

    private

    def self.collection_endpoint(table_name)
      base_url + "/rest/#{api_version}/#{table_name}"
    end

    def self.list_endpoint(table_name, params = {})
      if params
        query_string = Rack::Utils.build_query(params)
        adjusted_query_string = query_string.gsub('=','=eq.')
      end

      url = "#{collection_endpoint(table_name)}?select=*"
      return url if adjusted_query_string.nil? || adjusted_query_string.empty?

      url + '&' + adjusted_query_string
    end
  end
end
