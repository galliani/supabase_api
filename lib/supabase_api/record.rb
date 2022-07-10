# frozen_string_literal: true

module SupabaseApi
  class Record
    def self.table_endpoint
      raise ArgumentError
    end

    def self.find(id)
      data = Client.find(id)
      
      new(data)
    end

    attr_accessor :id

    def initialize(params = {})
      params.each { |key,value| instance_variable_set("@#{key}", value) }
      instance_variables.each {|var| self.class.send(:attr_accessor, var.to_s.delete('@'))}
    end

    def attributes
      instance_variables.each_with_object({}) do |var, hash|
        hash[var.to_s.delete("@").to_sym] = instance_variable_get(var)
      end
    end

    def save
      Client.save(attributes)
    end
  end
end
