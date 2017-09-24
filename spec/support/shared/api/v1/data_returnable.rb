shared_examples_for 'data-returnable' do
  it 'returns a list of objects' do
    expect(response.body).to have_json_size(2)
  end
end
