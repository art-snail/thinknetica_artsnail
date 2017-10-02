module SphinxHelpers
  def index
    ThinkingSphinx::Test.index
    # Wait for Sphinx to finish loading in the new index files.
    sleep 10
  end
end

RSpec.configure do |config|
  config.include SphinxHelpers
end