shared_examples_for 'non-creatable' do
  it 'returns status 422' do
    request
    expect(response.status).to eq 422
  end

  it 'does not create new model' do
    expect { request }.to_not change(model, :count)
  end
end
