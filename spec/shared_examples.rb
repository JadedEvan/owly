# Shared examples for testing Hootsuite::Requestable
shared_examples 'get_response_body' do
  it 'response body is a Hash' do
    expect(subject).to be_a Hash
  end

  it 'includes request parameters' do
    expect(subject['args']).to include "name"
  end

  it 'has correct request parameter value' do
    expect(subject['args']['name']).to eq name
  end

end

# Shared examples for testing Hootsuite::Requestable
shared_examples 'post_response_body' do
  it 'response body is a Hash' do
    expect(subject).to be_a Hash
  end

  it 'includes request parameters' do
    expect(subject['json']).to include "name"
  end

  it 'has correct request parameter value' do
    expect(subject['json']['name']).to eq name
  end
end

# Shared examples for testing Hootsuite::Requestable
shared_examples 'delete_response_body' do
  it 'response body is a Hash' do
    expect(subject).to be_a Hash
  end

  it 'returns no data' do
    expect(subject['data']).to be_empty
  end

  it 'returns no json data' do
    expect(subject['json']).to be_nil
  end
end

# Shared examples for testing Hootsuite::Configuration
#
shared_examples 'correct configuration values' do
  describe '#api_domain' do
    subject(:api_domain) { instance.api_domain } 
    it { expect(subject).to eq api_domain }
  end

  describe '#api_version' do
    subject(:api_version) { instance.api_version } 
    it { expect(subject).to eq api_version }
  end

  describe '#use_ssl' do
    subject(:use_ssl) { instance.use_ssl } 
    it { expect(subject).to eq use_ssl }
  end
end

# Shared examples for Hootsuite::Message::BaseMessage
shared_examples 'array assignment only' do
  before(:each) do
    instance.send(field) << "123"
    instance.send(field) << "456"
  end

  it { expect(subject).to be_a Array }

  it 'has correct count' do
    expect(subject.count).to eq 2
  end

  it 'includes expected entries' do
    expect(subject).to include "123"
  end

  it 'only allows assignment of Array' do
    expect{instance.social_profile_ids = 'foo'}.to raise_error(ArgumentError)
  end

end

