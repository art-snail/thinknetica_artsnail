shared_examples_for 'non-changeable' do
  it 'not deletes the object' do
    expect { request }.to_not change(model, :count)
  end
end
