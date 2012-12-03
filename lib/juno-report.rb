require "juno-report/version"
require 'juno-report/report_object'
require "prawml"

module Juno
    module Report
        def self.generate(collection, options)
            rules = "report-#{options[:report]}.yml"
            report = Prawml::PDF.new rules

            report.extend Juno::PDF
            report.generate(collection).render_file 'report.pdf'
        end
    end

    module PDF
        def generate(collection)
            @defaults = {
                :style => :normal,
                :size => 12,
                :align => :left,
                :format => false,
                :font => 'Times-Roman',
                :type => :text,
                :color => '000000',
                :fixed => false
            }

            get_sections

            collection = [collection] unless collection.is_a?(Array)

            print_section :page

            set_pos_y (@rules[@sections[:body]]["settings"]["posY"] || 0)
            draw_columns
            collection.each do |record|
                record = ReportObject.new(record) if record.is_a?(Hash)
                print_section :body, record
            end

            @pdf
        end

        protected

        def new_page
            set_pos_y
            @pdf.start_new_page
            print_section :page, nil unless @sections[:page].nil?
        end


        def print_section(section, values = nil)
            set_pos_y(@rules[@sections[section]]["settings"]["posY"] || 0) unless section.eql?(:body)

            @rules[@sections[section]]["fields"].each do |field, settings|
                set_pos_y settings[1]["posY"] unless settings[1].nil? || settings[1]["posY"].nil?
                settings = [settings[0], @posY, (@defaults.merge (settings[1] || { }).symbolize_keys!)]
                set_options settings[2]

                value = settings[2][:value].nil? ? (values.respond_to?(field) ? values.send(field) : "") : settings[2][:value]
                draw_text value, settings
            end
            set_pos_y (@rules[@sections[section]]["settings"]["height"]) unless @rules[@sections[section]]["settings"]["height"].nil?
        end

        def set_pos_y(posY = nil)
            @posY = 750 if @posY.nil?
            @posY = posY.nil? ? 750 : @posY - posY
        end

        private
        def get_sections
            @sections = { }
            @rules.each do |section, parameters|
                @sections[parameters["settings"]['type'].to_sym] = section unless parameters["settings"]['type'].nil?
            end
        end

        def draw_line(y)
            @pdf.stroke { @pdf.horizontal_line 0, 530, :at => y }
        end

        def draw_columns
            @rules[@sections[:body]]["fields"].each do |field, settings|
                settings = [settings[0], @posY, (@defaults.merge (settings[1] || { }).symbolize_keys!)]
                set_options settings[2]
                draw_line(@posY + @rules[@sections[:body]]["settings"]["height"]/2)
                field = settings[2][:label] || field.split('_').inject('') do |str, part|
                    str << part.camelize << " "
                end
                draw_text field, settings
            end
            draw_line(@posY - @rules[@sections[:body]]["settings"]["height"]/2)
            set_pos_y @rules[@sections[:body]]["settings"]["height"]
        end
    end
end
