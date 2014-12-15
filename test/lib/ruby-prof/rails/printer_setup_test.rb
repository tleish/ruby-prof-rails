require 'test_helper'
require './lib/ruby-prof/rails/printer_setup'

describe RubyProf::Rails::PrinterSetup do

  describe 'setup' do
    it 'return a printer setup object' do
      RubyProf::Rails::Printers.hash.each do |printer, filename|
        @setup = RubyProf::Rails::PrinterSetup.new( request: mock_request(mock_env(printer)), type: printer )
        @setup.key.must_equal printer
        @setup.printer_class.must_equal "RubyProf::#{printer}".constantize
        @setup.filename.must_match /.*#{filename}$/
      end
    end

  end

  private

  def mock_request(env)
    Rack::Request.new(env)
  end

  def mock_env(printer)
    {
      'rack.session' => {
        ruby_prof_rails: {
          printers: printer
        }
      },
      'rack.session.options' => {
        id: SecureRandom.hex
      }
    }
  end

end
