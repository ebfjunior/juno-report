module JunoReport
	module Pdf
		module Behaviors
			def self.sum old_value, new_value
				value = (old_value.to_f + new_value.to_f).to_s
				(/^[0-9]+(?=\.)/.match value).nil? ? value : value[/^[0-9]+(?=\.)/]
			end

			def self.substract old_value, new_value
				old_value.to_f - new_value.to_f
			end

			def self.count old_value, new_value = nil
				old_value.to_i + 1
			end
		end
	end
end