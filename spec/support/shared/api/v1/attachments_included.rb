shared_examples_for 'attachments-included' do
  context 'attachments' do
    it 'included in object' do
      expect(response.body).to have_json_size(1).at_path(attachment_path)
    end

    it "contains file_url" do
      expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("#{attachment_path}/0/file/url")
    end
  end
end
