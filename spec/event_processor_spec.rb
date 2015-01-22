require 'spec_helper'

RSpec.describe ActionAudit::EventProcessor do
  let(:params1) { {a: 1} }
  let(:params2) { {b: 1} }

  let(:entity) { {b: 1} }
  let(:was) { {c: 1} }
  let(:become) { {d: 1} }

  let(:store) { spy(:store) }

  subject { described_class.new(store) }

  it "doesn't save action without changes" do
    subject.add_params(params1)
    subject.add_params(params2)
  end

  it "saves action with params after first change" do
    expect(store).to receive(:upsert_action).with(params1.merge(params2), nil).and_return(1)
    expect(store).to receive(:save_change).with(1, entity, was, become)

    subject.add_params(params1)
    subject.add_params(params2)
    subject.add_change(entity, was, become)
  end

  it "after change added saves action params every time" do
    expect(store).to receive(:upsert_action).with(params1, nil).ordered.and_return(1)
    expect(store).to receive(:save_change).with(1, entity, was, become).ordered
    expect(store).to receive(:upsert_action).with(params1.merge(params2), 1).ordered.and_return(1)

    subject.add_params(params1)
    subject.add_change(entity, was, become)
    subject.add_params(params2)
  end
end
