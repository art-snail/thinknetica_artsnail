shared_examples_for 'answers-included' do
  context 'answers' do
    it 'included in object' do
      expect(response.body).to have_json_size(1).at_path(answer_path)
    end

    %w(id body user_id created_at updated_at).each do |attr|
      it "contains #{attr}" do
        expect(response.body).
            to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{answer_path}/0/#{attr}")
      end
    end
  end
end
