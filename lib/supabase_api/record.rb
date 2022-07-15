# frozen_string_literal: true

module SupabaseApi
  class Record
    def self.table_name
      raise ArgumentError
    end

    def self.all
      where()
    end

    def self.where(params = {})
      output = []

      response = Client.new.list(table_name, params)

      response.parsed_response.each do |record_hash|
        output << new(record_hash)
      end

      output      
    end

    def self.find(id)
      response = Client.new.find(table_name, id)

      if response.success? && !response.parsed_response.empty?
        new(response.parsed_response.first)
      else
        raise RecordNotFound
      end
    end

    def self.find_by_id(id)
      find(id)
    rescue RecordNotFound
      nil
    end

    def self.create(params)
      is_multi_rows = params.kind_of? Array

      client = Client.new
      response = client.create(
        table_name,
        params
      )

      if response.success? && !response.parsed_response.empty?
        if is_multi_rows
          response.parsed_response.map do |data|
            new(data)
          end
        else
          new(response.parsed_response.first)
        end
      else
        nil
      end      
    end

    def initialize(params = {})
      params.each do |key,value|
        instance_variable_set("@#{key}", value)
      end

      instance_variables.each {|var| self.class.send(:attr_accessor, var.to_s.delete('@'))}
    end

    def attributes
      instance_variables.each_with_object({}) do |var, hash|
        hash[var.to_s.delete("@").to_sym] = instance_variable_get(var)
      end
    end

    def assign_attributes(params = {})
      params.each do |key,value|
        instance_variable_set("@#{key}", value)
      end      
    end

    def save
      if id.nil?
        self.class.create(attributes)
      else
        response = Client.new.update(
          self.class.table_name,
          id,
          attributes
        )
        self.class.new(response.parsed_response.first)
      end
    end

    def destroy
      raise InvalidRequest if id.nil?

      response = Client.new.destroy(
        self.class.table_name,
        id
      )
      
      return true if response.success?

      raise RecordNotDestroyed
    end    
  end
end
