# frozen_string_literal: true

module SupabaseApi
  class Sample < Record
    class << self
      attr_accessor :table_name
    end
  end
end