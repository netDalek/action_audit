require 'spec_helper'

require 'action_audit/controller_concern'
require 'active_support/core_ext/hash/slice'

RSpec.describe ActionAudit::ControllerConcern do
  class TestController
    def self.around_filter(_smth)
    end

    def response
      OpenStruct.new(status: 200)
    end

    include ActionAudit::ControllerConcern
  end

  let(:params) { {"action" => "create", "controller" => "my_controller"} }
  let(:controller) { TestController.new }
  let(:response) { OpenStruct.new(status: 200) }

  let(:store) { spy(:store) }

  before do
    ActionAudit.store = store
    expect(store).to receive(:upsert_action).with(params, nil).and_return(1).ordered
    expect(store).to receive(:save_change).with(1, :a, :b, :c)
    expect(store).to receive(:upsert_action).with(params.merge(status: 200), 1).and_return(1).ordered
  end

  it "store change while controller action" do
    expect(controller).to receive_messages(current_user: nil, params: params, response: response)
    controller.audit do 
      ActionAudit.add_change(:a, :b, :c)
    end
  end
end
