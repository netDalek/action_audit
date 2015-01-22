class ActionAuditor::EventProcessor
  delegate :info, to: ActionAuditor

  def initialize(store)
    @store = store
    @params = {}
  end

  def add_change(entity, was, become)
    info "adding changeset for entity #{entity}"
    changes_state.trigger(:entity_changed)
    @store.save_change(@action_id, entity, was, become)
  end

  def add_params(params)
    @params.merge!(params)
    changes_state.trigger(:params_added)
  end

  private

  def changes_state
    @changes_state ||= MicroMachine.new(:nothing).tap do |m|
      m.when(:entity_changed, :nothing => :changed)
      m.when(:params_added, :changed => :changed)
      m.on(:changed) do
        @action_id = @store.upsert_action(@params, @action_id)
      end
    end
  end
end
