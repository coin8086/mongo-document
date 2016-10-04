require 'mongo'
require 'yaml'
require 'active_support'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/hash/keys'

module Mongo
  module DocumentClass
    def client
      if !@client
        raise "No connection! You should call Mongo::Document.establish_connection before."
      end
      @client
    end
    alias connection client

    def collection
      @collection ||= client[collection_name]
    end

    def collection_name
      @collection_name ||= name.underscore.pluralize
    end

    def collection_name=(name)
      @collection_name = name
    end

    # A little optimazation for the most frequently-used method.
    def find(*args)
      collection.find(*args)
    end

    # For other methods on collection(or not), just send to it.
    def method_missing(name, *args)
      collection.send(name, *args)
    end

    def respond_to_missing?(name, include_private = false)
      collection.respond_to?(name, include_private) || super
    end

  end

  module Document
    class << self
      def included(cls)
        cls.extend DocumentClass
        set_connection(cls)
        descendants << cls
      end

      def descendants
        @descendants ||= []
      end

      def client
        @client
      end
      alias connection client

      def establish_connection(spec)
        spec = spec.symbolize_keys
        hosts_or_uri = nil
        spec.delete_if do |k, v|
          if k == :hosts || k == :uri
            hosts_or_uri = v
          end
        end
        @client = Mongo::Client.new(hosts_or_uri, spec)

        descendants.each do |model|
          set_connection(model)
        end
      end

      def database_file=(file)
        config = YAML.load(File.read(file))
        env = ENV['RAILS_ENV'] || ENV['RACK_ENV']
        spec = config[env]
        establish_connection(spec)
      end

      private

      def set_connection(cls)
        cls.instance_variable_set(:@client, @client) if @client
      end

    end

    # Auto read database config
    if !ENV["MD_NO_AUTO_CONFIG"] && File.exist?("#{Dir.pwd}/config/database.yml")
      self.database_file = "#{Dir.pwd}/config/database.yml"
    end

  end

end
