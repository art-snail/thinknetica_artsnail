shared_examples_for 'comments-included' do
  context 'comments' do
    it 'included in object' do
      expect(response.body).to have_json_size(1).at_path(comment_path)
    end

    %w(id user_id body created_at updated_at).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("#{comment_path}/0/#{attr}")
      end
    end
  end
end
