require 'test_helper'
require './test/mocks/fake_app'
require './lib/ruby-prof/rails/runner_button'
require 'mocha'


describe RubyProf::Rails::Profiles do

  describe 'draw' do
    it 'it returns exact response if header is not html' do
      response_orig = [mock_status, mock_header('application/json'), mock_html]
      response = RubyProf::Rails::RunnerButton.new( app: mock_app, response: response_orig ).draw
      response.must_equal response_orig
    end

    it 'it modified body if header is not html' do
      response_orig = [mock_status, mock_header, mock_html]
      response = RubyProf::Rails::RunnerButton.new( app: mock_app, response: response_orig ).draw
      (response == response_orig).must_equal false
      response.last.body.first.include?('ruby-prof-rails-button').must_equal true
    end

  end

  private

  def mock_html
    '<html><head></head><body></body></html>'
  end

  def mock_app
    app = FakeApp.new
    app.stubs(:routes).returns(mock_routes)
    app
  end

  def mock_routes
    stub(named_routes: {'ruby_prof_rails_engine' => stub(
           app: stub(routes: stub(named_routes: stub(
           routes: {ruby_prof_rails_home_index: stub(
           path: stub(spec: '/ruby_prof_rails(.:format)'))})))) })
  end

  def mock_status
    200
  end

  def mock_header(content_type = 'text/html')
    {'Content-Type' => content_type}
  end

  def mock_body
    ''
  end

end
