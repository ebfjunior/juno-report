require "juno-report/version"
require "prawml"
require "prawml/prawml"

module JunoReport
    def self.generate(collection, options)
        rules = "report-#{options[:report]}.yml"
        report = Prawml::PDF.new rules
        report.generate(collection).render_file 'report.pdf'
    end
end
