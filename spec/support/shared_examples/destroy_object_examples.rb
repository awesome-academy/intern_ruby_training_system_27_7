RSpec.shared_examples "not found to destroy" do |path|
  before do
    delete :destroy, params: {id: -1}
  end

  it "will redirect to #{path} page" do
    expect(response).to redirect_to path
  end

  it "will have flash danger present" do
    expect(flash[:danger]).to be_present
  end
end

RSpec.shared_examples "destroy object success" do |path|
  it "will redirect to #{path} page" do
    expect(response).to redirect_to path
  end

  it "will have flash success present" do
    expect(flash[:success]).to be_present
  end
end

RSpec.shared_examples "destroy object failed" do |path|
  it "will redirect to #{path} page" do
    expect(response).to redirect_to path
  end

  it "will have flash danger present" do
    expect(flash[:danger]).to be_present
  end
end
