shared_context 'json_request' do
  let(:http_opts) { {:content_type => :json} }
end

shared_context 'get_request' do
  # Get direct access to request body by declaring this as the subject
  subject(:method) { instance.get(url, params, http_opts) }
  let(:params) { {:name => name} }
end

shared_context 'post_request' do
  # Get direct access to request body by declaring this as the subject
  subject(:method) { instance.post(url, params, http_opts) }
  let(:params) { {:name => name} }
end

shared_context 'put_request' do
  # Get direct access to request body by declaring this as the subject
  subject(:method) { instance.put(url, params, http_opts) }
  let(:params) { {:name => name} }
end

shared_context 'delete_request' do
  # Get direct access to request body by declaring this as the subject
  subject(:method) { instance.delete(url, params, http_opts) }
  let(:params) { {:name => name} }
end

shared_context 'webmock disabled' do
  before(:all) do
    WebMock.allow_net_connect!
  end

  after(:all) do
    WebMock.disable_net_connect!
  end
end
