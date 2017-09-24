shared_examples_for 'creatable' do
  it 'create the object' do
    expect { request }.to change(model, :count).by(1)
  end
end
