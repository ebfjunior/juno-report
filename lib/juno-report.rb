require "juno-report/version"
require "juno-report/pdf"
require "juno-report/pdf/behaviors"
require "prawml"

module JunoReport
    autoload :ReportObject, 'juno-report/report_object'

    def self.generate(collection, options)
        rules = "#{options[:report]}.yml"

        defaults = {
            :page_layout => :portrait
        }

        report = Prawml::PDF.new rules, defaults.merge(options)

        report.extend JunoReport::Pdf
        report.generate(collection).render_file (options[:filename] || "report.pdf")
    end
end
