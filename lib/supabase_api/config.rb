# frozen_string_literal: true

module SupabaseApi
  class Config
    class << self
      attr_accessor :base_url, :api_version
    end
  end
end