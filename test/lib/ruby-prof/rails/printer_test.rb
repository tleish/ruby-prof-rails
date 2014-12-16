require 'test_helper'
require_relative 'profiles_mock_module'
require './lib/ruby-prof/rails/printer'
require './lib/ruby-prof/rails/printers'
require './lib/ruby-prof/rails/profiles'
require 'digest/sha1'
require 'securerandom'
require 'mocha'

describe RubyProf::Rails::Printer do

  include RubyProf::Rails::ProfilesMockModule

  after do
    cleanup_profiles
  end

  describe 'print' do
    it 'prints results to a file' do
      RubyProf::Rails::Printers.hash.each do |printer, extension|
        cleanup_profiles
        env = mock_env printer.to_s
        print(env)
        RubyProf::Rails::Profiles.list.first.filename.must_match /.*#{extension}$/
      end
    end

    it 'prints multiple results to a file' do
      printers = RubyProf::Rails::Printers.hash.slice(:FlatPrinter, :GraphHtmlPrinter, :DotPrinter, :CallStackPrinter, :CallStackPrinter)
      env = mock_env printers.keys.map(&:to_s)
      print(env)
      RubyProf::Rails::Profiles.list.length.must_equal printers.keys.length
    end
  end

  private

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

  def print(env)
    printer = RubyProf::Rails::Printer.new(env: env)
    RubyProf.start
    results = RubyProf.stop
    printer.print(results)
  end

  def mock_threads
    threads = [OpenStruct.new(id: 1, fiber_id: 1, self_time: 23, total_time: 23)]
    threads
  end

end
