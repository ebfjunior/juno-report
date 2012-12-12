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

            symbolize! @rules
            get_sections

            collection = [collection] unless collection.is_a?(Array)

            print_section :page unless @sections[:page].nil?

            set_pos_y (@rules[@sections[:body]][:settings][:posY] || 0)

            @current_groups = {}
            @sections[:groups].each do |field_name, section_name|
                @current_groups[field_name] = nil
            end unless @sections[:groups].nil?

            collection.each do |record|
                @record = ReportObject.new(record) if record.is_a?(Hash)
                header = []
                header_height = 0
                @current_groups.each do |field, value|
                    if @record.send(field) != value
                        groups = @rules[@sections[:body]][:settings][:groups]
                        groups.each_with_index do |group, idx|
                            @current_groups[group.to_sym] = nil if groups.index(field.to_s) <= idx
                        end

                        @current_groups[field] = @record.send(field)
                        header << field.to_sym
                        header_height += @rules[@sections[field]][:settings][:height]
                    end
                end unless @current_groups.empty?

                unless header.empty? 
                    if @posY - header_height < 80
                        new_page 
                    else
                        header.each { |group| print_section group, @record, true }
                        draw_columns
                    end
                end
                print_section :body, @record
            end

            @pdf
        end

        protected

        def new_page
            @pdf.start_new_page
            set_pos_y
            print_section :page unless @sections[:page].nil?
            set_pos_y (@rules[@sections[:body]][:settings][:posY] || 0)
            @current_groups.each do |field, value|
                print_section field.to_sym, @record, true
            end
            draw_columns
        end


        def print_section(section, values = nil, group = false)
            section_name = !group ? @sections[section] : @sections[:groups][section]
            set_pos_y(@rules[section_name][:settings][:posY] || 0) unless section.eql?(:body)
            new_page if @posY < 30

            @rules[section_name][:fields].each do |field, settings|
                symbolize! settings[1] unless settings[1].nil?
                set_pos_y settings[1][:posY] unless settings[1].nil? || settings[1][:posY].nil?
                settings = [settings[0], @posY, (@defaults.merge (settings[1] || { }))]
                set_options settings[2]

                value = settings[2][:value].nil? ? (values.respond_to?(field) ? values.send(field) : "") : settings[2][:value]
                draw_text value, settings
            end
            set_pos_y (@rules[section_name][:settings][:height]) unless @rules[section_name][:settings][:height].nil?
        end

        def set_pos_y(posY = nil)
            @posY = 750 if @posY.nil?
            @posY = posY.nil? ? 750 : @posY - posY
        end

        private
        
        def get_sections
            @sections = {:groups => {}}
            @rules.each do |section, parameters|
                @sections[parameters[:settings][:type].to_sym] = section unless parameters[:settings][:type].nil?
                if(parameters[:settings][:type].to_sym == :body and !parameters[:settings][:groups].nil?)
                    parameters[:settings][:groups] = [parameters[:settings][:groups]] unless parameters[:settings][:groups].is_a? Array
                    parameters[:settings][:groups].each do |group|
                        @rules.each do |section, parameters|    
                            @sections[:groups][group.to_sym] =  section if parameters[:settings][:type] == group
                        end
                    end
                end
            end
            @sections
        end

        def draw_line(y)
            @pdf.stroke { @pdf.horizontal_line 0, 530, :at => y }
        end

        def draw_columns
            @rules[@sections[:body]][:fields].each do |field, settings|
                settings = [settings[0], @posY, (@defaults.merge (settings[1] || { }).symbolize_keys!)]
                set_options settings[2]
                draw_line(@posY + @rules[@sections[:body]][:settings][:height]/2)
                field = settings[2][:column] || field.to_s.split('_').inject('') do |str, part|
                    str << part.camelize << " "
                end
                draw_text field, settings
            end
            draw_line(@posY - @rules[@sections[:body]][:settings][:height]/2)
            set_pos_y @rules[@sections[:body]][:settings][:height]
        end

        def symbolize! hash
            hash.symbolize_keys!
            hash.values.select{|v| v.is_a? Hash}.each{|h| symbolize!(h)}
        end
    end
end
