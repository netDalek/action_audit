require 'active_support/concern'
require 'ostruct'

module ActionAuditor::ControllerConcern
  extend ActiveSupport::Concern

  included do
    around_filter :audit
  end

  def audit
    ActionAuditor.info("start audit controller")
    ActionAuditor.with_auditor do
      ActionAuditor.add_params(params.slice("action", "controller"))
      ActionAuditor.add_params(user_id: current_user.id) if current_user
      begin
        yield
      ensure
        ActionAuditor.add_params(status: response.status)
        ActionAuditor.info("add params audit controller #{response.status}")
        ActionAuditor.info("finish audit controller")
      end
    end
  end
end
