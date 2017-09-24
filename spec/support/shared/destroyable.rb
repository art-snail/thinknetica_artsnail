shared_examples_for 'destroyable' do
  it 'deletes the object' do
    expect { request }.to change(model, :count).by(-1)
  end
end
