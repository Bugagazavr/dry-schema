# frozen_string_literal: true

require 'dry/equalizer'
require 'dry/configurable'

require 'dry/schema/constants'
require 'dry/schema/predicate_registry'

module Dry
  module Schema
    # Schema definition configuration class
    #
    # @see DSL#configure
    #
    # @api public
    class Config
      include Dry::Configurable
      include Dry::Equalizer(:predicates, :messages)

      # @!method predicates
      #
      # Return configured predicate registry
      #
      # @return [Schema::PredicateRegistry]
      #
      # @api public
      setting(:predicates, Schema::PredicateRegistry.new)

      # @!method messages
      #
      # Return configuration for message backend
      #
      # @return [Dry::Configurable::Config]
      #
      # @api public
      setting(:messages) do
        setting(:backend, :yaml)
        setting(:namespace)
        setting(:load_paths, Set[DEFAULT_MESSAGES_PATH], &:dup)
        setting(:top_namespace, DEFAULT_MESSAGES_ROOT)
      end

      # @api private
      def respond_to_missing?(meth, include_private = false)
        super || config.respond_to?(meth, include_private)
      end

      private

      # Forward to the underlying config object
      #
      # @api private
      def method_missing(meth, *args, &block)
        super unless config.respond_to?(meth)
        config.public_send(meth, *args)
      end
    end
  end
end
