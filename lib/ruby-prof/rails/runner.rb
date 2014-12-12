require_relative 'config'
require_relative 'printer'

module RubyProf
  module Rails
    class Runner

      MEASUREMENTS = {
        PROCESS_TIME: :default,
        WALL_TIME: 'Wall Time',
        CPU_TIME: 'CPU Time',
        ALLOCATIONS: 'Allocation',
        MEMORY: 'Memory Usage',
        GC_RUNS: 'Garbage Collection',
        GC_TIME: 'Garbage Collection Time'
      }

      def initialize(options = {})
        @env = options.fetch(:env)
        @app = options.fetch(:app)
        @options = RubyProf::Rails::Config.extract_options_from @env
      end

      def enabled?
        @options[:enabled]
      end

      def disabled?
        !enabled?
      end

      def skip?
        is_config_uri? || disabled? || !is_valid_route?
      end

      def call(env)
        ruby_prof_start
        status, headers, @body = @app.call(env)
        ruby_prof_stop_and_save if @body.present?
        [status, headers, @body]
      end

      private

      def is_valid_route?
        begin
          route = @app.recognize_path(@env['REQUEST_PATH'])
          route.present? && valid_format?(route[:format])
        rescue ActionController::RoutingError
          false
        end
      end

      def is_config_uri?
        (@env['PATH_INFO'] =~ %r{/ruby_prof_rails}).present?
      end

      def valid_format?(type)
        exclude_formats = @options[:exclude_formats].to_s.split(',').map(&:strip)
        !exclude_formats.include?(type)
      end

      def ruby_prof_start
        RubyProf.measure_mode = get_measurement
        RubyProf.start
      end

      def ruby_prof_stop_and_save
        @results = RubyProf.stop
        return unless @results.present?
        @results.eliminate_methods!(array_to_regex(:eliminate_methods))
        print
      end

      def array_to_regex(param)
        return [] unless @options[param].present?
        Array(@options[param]).map { |regex| Regexp.new regex }
      end

      def get_measurement
        measurement = MEASUREMENTS.invert[@options[:measurement]] || MEASUREMENTS.invert[:default]
        "RubyProf::#{measurement}".constantize
      end

      def print
        printer = RubyProf::Rails::Printer.new(env: @env)
        printer.print(@results)
      end

    end
  end
end
