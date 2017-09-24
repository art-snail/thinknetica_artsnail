shared_examples_for 'response-403' do
  it 'return response status 403' do
    request
    expect(response.status).to eq 403
  end
end