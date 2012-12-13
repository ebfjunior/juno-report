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
            set_pos_y

            collection = [collection] unless collection.is_a?(Array)
            print_section :page unless @sections[:page].nil?
            set_pos_y (@sections[:body][:settings][:posY] || 0)
            @current_groups = {}

            unless @sections[:groups].empty?
                @sections[:body][:settings][:groups].each { |field_name| @current_groups[field_name] = nil }
            else
                draw_columns
            end

            collection.each do |record|
                @record = ReportObject.new(record) if record.is_a?(Hash)
                
                headers_to_print, headers_height = calculate_header

                unless headers_to_print.empty? 
                    if @posY - headers_height < 2*@sections[:body][:settings][:height]
                        new_page 
                    else
                        headers_to_print.each { |group| print_section group, @record, true }
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
            set_pos_y (@sections[:body][:settings][:posY] || 0)
            @current_groups.each do |field, value|
                print_section field.to_sym, @record, true
            end
            draw_columns
        end


        def print_section(section_name, values = nil, group = false)
            section = !group ? @sections[section_name] : @sections[:groups][section_name] 
            set_pos_y(section[:settings][:posY] || 0) unless section_name.eql?(:body) || section[:settings].nil?
            new_page if @posY < 30

            section[:fields].each do |field, settings|
                symbolize! settings[1] unless settings[1].nil?
                set_pos_y settings[1][:posY] unless settings[1].nil? || settings[1][:posY].nil?
                settings = [settings[0], @posY, (@defaults.merge (settings[1] || { }))]
                set_options settings[2]

                value = settings[2][:value].nil? ? (values.respond_to?(field) ? values.send(field) : "") : settings[2][:value]
                draw_text value, settings
            end
            set_pos_y (section[:settings][:height]) unless section[:settings].nil? || section[:settings][:height].nil?
        end

        def draw_line(y)
            @pdf.stroke { @pdf.horizontal_line 0, 530, :at => y }
        end

        def set_pos_y(posY = nil)
            @posY = 750 if @posY.nil?
            @posY = posY.nil? ? 750 : @posY - posY
        end

        def symbolize! hash
            hash.symbolize_keys!
            hash.values.select{|v| v.is_a? Hash}.each{|h| symbolize!(h)}
        end

        def get_sections
            symbolize! @rules
            @sections = {:page => @rules[:page], :body => @rules[:body], :groups => {}}
            @sections[:body][:settings][:groups].each { |group|  @sections[:groups][group.to_sym] = @rules[group.to_sym] } unless @sections[:body][:settings][:groups].nil?
        end

        def clean_forward_groups current_group
            groups = @sections[:body][:settings][:groups]
            groups.each_with_index do |group, idx|
                @current_groups[group] = nil if groups.index(current_group.to_s) <= idx
            end
        end

        def calculate_header
            headers = []
            height = 0
            @current_groups.each do |field, value|
                if @record.send(field) != value
                    clean_forward_groups field
                    @current_groups[field] = @record.send(field)

                    headers << field.to_sym
                    height += @sections[:groups][field.to_sym][:settings][:height]
                end
            end unless @current_groups.empty?
            [headers, height]
        end

        def draw_columns
            @sections[:body][:fields].each do |field, settings|
                settings = [settings[0], @posY, (@defaults.merge (settings[1] || { }).symbolize_keys!)]
                set_options settings[2]
                draw_line(@posY + @sections[:body][:settings][:height]/2)
                field = settings[2][:column] || field.to_s.split('_').inject('') do |str, part|
                    str << part.camelize << " "
                end
                draw_text field, settings
            end
            draw_line(@posY - @sections[:body][:settings][:height]/2)
            set_pos_y @sections[:body][:settings][:height]
        end
    end
end
