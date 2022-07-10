# frozen_string_literal: true

module SupabaseApi
  class Record
    def self.table_name
      raise ArgumentError
    end

    def self.all
      # data = Client.new.list(table_name)
      # data.each do |record|
      # end
    end

    def self.find(id)
      data = Client.new.get(table_name, id)
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
      client = Client.new

      if id
        client.update(
          self.class.table_name,
          id,
          attributes
        )
      else
        client.create(
          self.class.table_name,
          attributes
        )
      end
    end
  end
end
