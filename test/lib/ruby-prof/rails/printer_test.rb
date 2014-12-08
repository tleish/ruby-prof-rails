require 'test_helper'
require_relative 'cleanup_profiles_module'
require './lib/ruby-prof/rails/printer'
require './lib/ruby-prof/rails/profiles'
require 'digest/sha1'
require 'securerandom'
require 'mocha'

describe RubyProf::Rails::Profiles do

  include RubyProf::Rails::CleanupProfilesModule

  after do
    cleanup_profiles
  end

  describe 'print' do
    it 'prints results to a file' do
      RubyProf::Rails::Printer::PRINTERS.each do |printer, extension|
        cleanup_profiles
        env = mock_env printer.to_s
        print(env)
        RubyProf::Rails::Profiles.list.first.filename.must_match /.*#{extension}$/
      end
    end

    it 'prints multiple results to a file' do
      printers = RubyProf::Rails::Printer::PRINTERS.slice(:FlatPrinter, :GraphHtmlPrinter, :DotPrinter, :CallStackPrinter, :CallStackPrinter)
      env = mock_env printers.keys.map(&:to_s)
      print(env)
      RubyProf::Rails::Profiles.list.length.must_equal printers.keys.length
    end
  end

  describe 'self.valid?' do
    it 'returns true when the list of printers are valid' do
      RubyProf::Rails::Printer.valid?(%w{FlatPrinter FlatPrinterWithLineNumbers}).must_equal true
    end

    it 'returns false when the list of printers are not valid' do
      RubyProf::Rails::Printer.valid?(%w{FlatPrinter BogusPrinter}).must_equal false
    end

    it 'returns false with no printers' do
      RubyProf::Rails::Printer.valid?(%w{}).must_equal false
    end
  end

  describe 'self.list' do
    it 'returns a list of printers in string format' do
      RubyProf::Rails::Printer.list.must_equal RubyProf::Rails::Printer::PRINTERS.keys.map(&:to_s)
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
