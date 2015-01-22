module ActionAuditor::ResqueConcern
  extend ActiveSupport::Concern

  module ClassMethods
    def around_perform_auditor(*args)
      logger_info "audit job with args #{args}"
      Auditor.start
      Auditor.add_params(args: args, job_name: self.name)
      yield
    ensure
      Auditor.flush
    end

    private

    def logger_info(str)
      Rails.logger.info "[Audit] [#{name}] #{str}"
    end
  end

end
