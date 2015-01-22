require 'active_support/concern'
require 'ostruct'

module ActionAudit::ControllerConcern
  extend ActiveSupport::Concern

  included do
    around_filter :audit
  end

  def audit
    ActionAudit.info("start audit controller")
    ActionAudit.with_auditor do
      ActionAudit.add_params(params.slice("action", "controller"))
      ActionAudit.add_params(user_id: current_user.id) if current_user
      begin
        yield
      ensure
        ActionAudit.add_params(status: response.status)
        ActionAudit.info("add params audit controller #{response.status}")
        ActionAudit.info("finish audit controller")
      end
    end
  end
end
