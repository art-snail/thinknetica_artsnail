require 'rails_helper'
require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    before { index }

    %w(question comment answer user all).each do |object|
      context "Search #{object}" do
        let(:request) { get :index, params: { object: object, text: 'sphinx' } }

        it 'calls search' do
          expect(Searcher).to receive(:search).with(object, 'sphinx')
          # expect(subject).to receive(:search).with(object, 'sphinx')
          request
        end

        it 'renders index view' do
          request
          expect(response).to render_template :index
        end
      end
    end
  end

  # describe 'search' do
  #   include ActionView::Helpers
  #   %w(question comment answer user all).each do |object|
  #     let(:klass) { object == 'all' ? 'ThinkingSphinx' : object }
  #     let(:request) { get :index, params: { object: object, text: 'sphinx' } }
  #
  #     it 'calls search' do
  #       expect(klass.classify.constantize).to receive(:search).with('sphinx', page: 1)
  #       request
  #     end
  #   end
  # end
end
