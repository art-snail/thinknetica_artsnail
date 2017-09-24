shared_examples_for 'render-templatable' do
  it 'render create template' do
    request
    expect(response).to render_template action
  end
end