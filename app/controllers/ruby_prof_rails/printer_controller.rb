module RubyProfRails
  class PrinterController < RubyProfRails::ApplicationController

    RUBY_PROF_GEM_DIR = Gem::Specification.find_by_name('ruby-prof').gem_dir

    def show
      printer = printers[params[:id].to_sym] || 'no-printer'
      printer_path = File.join(RUBY_PROF_GEM_DIR, 'examples', printer)

      if printer && File.exist?(printer_path)
        send_file printer_path
      else
        render text: 'Printer example was not found.' # write some content to the body
      end
    end

    private

    def printers
      RubyProf::Rails::Printers.hash.merge(
        FlatPrinterWithLineNumbers: 'flat.txt',
        CallTreePrinter: 'multi.grind.dat'
      )
    end

  end
end