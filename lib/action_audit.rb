require "active_support/core_ext/module/delegation.rb"
require 'micromachine'

require "action_audit/version"
require "action_audit/factory"
require "action_audit/event_processor"
require "action_audit/log_store"

module ActionAudit
  class << self
    delegate :add_change, :add_params, :with_auditor, to: ActionAudit::Factory

    def store
      @store ||= LogStore.new
    end
    attr_writer :store

    attr_accessor :logger

    def info(message)
      return unless logger
      logger.info("[action_audit] #{message}")
    end

    def error(message)
      return unless logger
      if message.respond_to?(:backtrace)
        bt = Rails.backtrace_cleaner.clean(message.backtrace)
        logger.error("[action_audit] #{message}: #{bt}")
      else
        logger.error("[action_audit] #{message}")
      end
    end
  end
end
