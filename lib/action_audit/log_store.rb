class LogStore
  delegate :info, to: ActionAudit

  def upsert_action(params, id)
    id ||= SecureRandom.uuid
    info "[action] [#{id}] #{params}"
    id
  end

  def save_change(action_id, entity, was, become)
    params = {
      entity_id: entity.id,
      entity_type: entity.class.name,
      was: was,
      become: become
    }
    info "[changeset] [#{action_id}] #{params}"
  end
end
