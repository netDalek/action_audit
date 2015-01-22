require "active_support/core_ext/module/delegation.rb"
require 'micromachine'

require "action_auditor/version"
require "action_auditor/factory"
require "action_auditor/event_processor"

module ActionAuditor
  class << self
    delegate :add_change, :add_params, :with_auditor, to: ActionAuditor::Factory

    attr_accessor :store
    attr_accessor :logger

    self.store = LogStore.new

    def info(message)
      logger.info(message) if logger
    end

    def error(message)
      return unless logger
      if message.respond_to?(:backtrace)
        bt = Rails.backtrace_cleaner.clean(message.backtrace)
        logger.error("[action_auditor] #{message}: #{bt}")
      else
        logger.error("[action_auditor] #{message}")
      end
    end
  end
end
