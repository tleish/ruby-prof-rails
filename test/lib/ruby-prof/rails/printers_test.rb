require 'test_helper'
require './lib/ruby-prof/rails/printers'

describe RubyProf::Rails::Printers do

  describe 'valid?' do
    it 'returns true when the list of printers are valid' do
      RubyProf::Rails::Printers.valid?(%w{FlatPrinter FlatPrinterWithLineNumbers}).must_equal true
    end

    it 'returns false when the list of printers are not valid' do
      RubyProf::Rails::Printers.valid?(%w{FlatPrinter BogusPrinter}).must_equal false
    end

    it 'returns false with no printers' do
      RubyProf::Rails::Printers.valid?(%w{}).must_equal false
    end
  end

  describe 'types' do
    it 'returns a list of printers in string format' do
      RubyProf::Rails::Printers.types.must_equal RubyProf::Rails::Printers::LIST.keys.map(&:to_s)
    end
  end

  describe 'formats' do
    it 'returns a list of printer formats in an array' do
      RubyProf::Rails::Printers.formats.must_equal RubyProf::Rails::Printers::LIST.values.map(&:to_s)
    end
  end

  describe 'default' do
    it 'returns a default printer object' do
      printer = RubyProf::Rails::Printers.default
      printer.type.must_equal :FlatPrinter
      printer.printer_class.must_equal RubyProf::FlatPrinter
      printer.suffix.must_equal 'flat.txt'
    end
  end

  describe 'find_by' do
    it 'returns a printer object' do
      printer = RubyProf::Rails::Printers.find_by('GraphPrinter')
      printer.type.must_equal :GraphPrinter
      printer.printer_class.must_equal RubyProf::GraphPrinter
      printer.suffix.must_equal 'graph.txt'
    end
  end

  describe 'find_type_by' do
    it 'returns a printer type' do
      type = RubyProf::Rails::Printers.find_type_by('graph.txt')
      type.must_equal :GraphPrinter
    end
  end

end
