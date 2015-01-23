module ActionAudit
  module Ar
    class UpdateObserver
      include Singleton
      def after_commit(record)
        changes = record.previous_changes
        if changes.present?
          was = Hash[changes.map{|key, value| [key, value.first]}]
          become = Hash[changes.map{|key, value| [key, value.last]}]
          ActionAudit.add_change(record, was, become)
        end
      rescue Exception => e
        ActionAudit.error(e)
      end
    end

    class DestroyObserver
      include Singleton
      def after_commit(record)
        ActionAudit.add_change(record, record.attributes, {})
      rescue Exception => e
        ActionAudit.error(e)
      end
    end

    class CreateObserver
      include Singleton
      def after_commit(record)
        ActionAudit.add_change(record, {}, record.attributes)
      rescue Exception => e
        ActionAudit.error(e)
      end
    end

    def self.observe(*models)
      models.flatten.each do |e|
        cl = e.to_s.camelize.constantize
        cl.after_commit CreateObserver.instance, on: :create
        cl.after_commit UpdateObserver.instance, on: :update
        cl.after_commit DestroyObserver.instance, on: :destroy
      end
    end
  end
end
