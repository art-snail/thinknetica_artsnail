shared_examples_for 'questionable' do
  %w(id title body user_id created_at updated_at).each do |attr |
    it "question object contains #{attr}" do
      expect(response.body).
          to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{question_path}#{attr}")
    end
  end
end
