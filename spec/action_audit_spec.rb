require 'spec_helper'

RSpec.describe ActionAudit do
  let(:params1) { {a: 1} }
  let(:params2) { {b: 1} }

  let(:entity) { {b: 1} }
  let(:was) { {c: 1} }
  let(:become) { {d: 1} }

  let(:store) { spy(:store) }

  it "saves changes when auditor started" do
    ActionAudit.store = store
    expect(store).to receive(:upsert_action).with(params1, nil).and_return(1)
    expect(store).to receive(:save_change).with(1, entity, was, become)

    ActionAudit.with_auditor do
      ActionAudit.add_params(params1)
      ActionAudit.add_change(entity, was, become)
    end
  end
end
