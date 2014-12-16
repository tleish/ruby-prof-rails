
module RubyProf
  module Rails
    # RubyProf Rails Printers
    class Printers

      LIST = {
        FlatPrinter: 'flat.txt',
        FlatPrinterWithLineNumbers: 'flat.num.txt',
        GraphPrinter: 'graph.txt',
        GraphHtmlPrinter: 'graph.html',
        DotPrinter: 'graph.dot',
        CallTreePrinter: 'grind.dat',
        CallStackPrinter: 'stack.html',
        FlameGraphPrinter: 'flame.txt'
      }

      class << self
        def hash
          LIST
        end

        def valid?(printers)
          printers = Array(printers)
          return false if printers.blank?
          valid_printers = types & printers
          valid_printers.present? && valid_printers == printers
        end

        def types
          LIST.keys.map(&:to_s)
        end

        def formats
          LIST.values
        end

        def default
          find_by(types.first)
        end

        def find_by(type)
          key = type.to_sym
          return unless LIST[key]
          OpenStruct.new(
            type: key,
            printer_class: "RubyProf::#{key}".constantize,
            suffix: LIST[key]
          )
        end

        def find_type_by(filename)
          LIST.key(filename)
        end
      end

    end
  end
end
