# frozen_string_literal: true

require_relative "supabase_api/config"
require_relative "supabase_api/client"
require_relative "supabase_api/record"
require_relative "supabase_api/version"

module SupabaseApi
  class Error < StandardError; end
  class InvalidRequest < Error; end
  class RecordNotFound < Error; end
  class RecordNotDestroyed < Error; end
end
