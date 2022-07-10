# frozen_string_literal: true

require 'httparty'

module SupabaseApi
  module Client
    include HTTParty
    base_uri ENV['SUPABASE_URL']

    def self.authorizations
      {
        'apikey':         ENV['SUPABASE_KEY'],
        'Authorization':  "Bearer #{ENV['SUPABASE_KEY']}"
      }      
    end

    def self.filtered_by_id_endpoint(id)
      "#{self.table_endpoint}?id=eq.#{id}&select=*"
    end

    def self.find(id)
      response = self.get(
        filtered_by_id_endpoint(id),
        headers: authorizations.merge({
          'Range': '0-9'
        })
      )

      JSON.parse(response.body).first
    end

    def self.save(attributes)
      options = {
        body:     attributes.to_json,
        headers:  Client.authorizations.merge({
          'Content-Type': 'application/json',
          'Prefer':       'return=representation'
        })
      }

      if @id.present?
        response = Client.patch(
          filtered_by_id_endpoint(@id),
          options
        )

        response.success?
      else
        response = Client.post(
          self.class.table_endpoint,
          options
        )

        JSON.parse(response.body).first['id'].present?
      end
    end

    def self.delete
    end    
  end
end
