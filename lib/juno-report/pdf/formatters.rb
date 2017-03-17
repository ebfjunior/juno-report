module JunoReport
  module Pdf
    module Formatters
      def self.date value
        value.strftime "%d/%m/%Y"
      end

      def self.datetime value
        value.strftime "%d/%m/%Y %H:%M"
      end
    end
  end
end