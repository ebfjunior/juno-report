require "juno-report/version"
require "juno-report/pdf"
require "juno-report/pdf/behaviors"
require "juno-report/pdf/formatters"
require "prawml"

module JunoReport
    autoload :ReportObject, 'juno-report/report_object'

    def self.generate(collection, options)
        rules = (File.open "#{options[:report]}.yml").read

        defaults = {
            :page_layout => :portrait
        }

        pdf = Prawml::PDF.new rules, defaults.merge(options)

        pdf.extend JunoReport::Pdf
        report  = pdf.generate(collection)

        options[:type] ||= :file

        if options[:type].eql? :file
            report.render_file (options[:filename] || "report.pdf")
        elsif options[:type].eql? :stream
            return report.render
        else
            raise "Type options must be :file or :stream."
        end

    end
end
