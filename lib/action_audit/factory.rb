class ActionAudit::Factory
  class << self
    def current
      Thread.current[:action_auditor]
    end

    def start
      Thread.current[:action_auditor] = ActionAudit::EventProcessor.new(ActionAudit.store)
    end

    def flush
      Thread.current[:action_auditor] = nil
    end

    def with_auditor(params = {})
      start
      add_params(params)
      yield
    ensure
      flush
    end

    def add_params(*args)
      current.add_params(*args) if current
    end

    def add_change(*args)
      current.add_change(*args) if current
    end
  end
end
