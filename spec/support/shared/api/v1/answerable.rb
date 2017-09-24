shared_examples_for 'answerable' do
  %w(id body created_at updated_at).each do |attr|
    it "answer object contains #{attr}" do
      expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{answer_path}#{attr}")
    end
  end
end
