module Prawml
    class PDF
        def generate(collection)
            defaults = {
                :style => :normal,
                :size => 12,
                :align => :left,
                :format => false,
                :font => 'Times-Roman',
                :type => :text,
                :color => '000000',
                :fixed => false
            }

            @rules.each do |field, draws|
                unless draws[0].is_a? Array
                    draws = [draws]
                end

                draws.each do |params|
                    params[2] = defaults.merge(params[2] || { })
                    params[2].symbolize_keys!
                    params[2][:style] = params[2][:style].to_sym

                    @pdf.fill_color params[2][:color]
                    @pdf.font params[2][:font], params[2]

                    value = collection.respond_to?(field.to_sym) ? collection.send(field.to_sym) : collection[field.to_sym]

                    send :"draw_#{params[2][:type]}", value, params unless value.nil?
                end
            end

            @pdf
        end
    end
end