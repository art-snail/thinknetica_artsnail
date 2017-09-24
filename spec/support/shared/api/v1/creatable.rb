shared_examples_for 'creatable' do
  it 'return status 201' do
    request
    expect(response.status).to eq 201
  end

  it 'creates new object' do
    expect { request }.to change(model, :count).by(1)
  end

  it 'sets a current_user to the new object' do
    request
    expect(response.body).to be_json_eql(access_token.resource_owner_id).at_path("user_id")
  end
end
