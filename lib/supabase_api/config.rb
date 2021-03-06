# frozen_string_literal: true

module SupabaseApi
  class Config
    class << self
      attr_accessor :base_url, :api_version, :api_key
    end
  end
end