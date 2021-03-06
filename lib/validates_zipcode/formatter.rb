module ValidatesZipcode
  class Formatter

    ZIPCODES_TRANSFORMATIONS = {
      AT: ->(z) { z.scan(/\d/).join },
      CZ: ->(z) { z.scan(/\d/).insert(3, ' ').join },
      DE: ->(z) { z.scan(/\d/).join.rjust(5, "0") },
      GB: ->(z) { z.upcase.scan(/[A-Z0-9]/).insert(-4, ' ').join },
      NL: ->(z) { z.upcase.scan(/[A-Z0-9]/).insert(4, ' ').join },
      PL: ->(z) { z.scan(/\d/).insert(2, '-').join },
      SK: :CZ,
      UK: :GB,
      US: ->(z) {
        digits = z.scan(/\d/)
        digits.insert(5, '-') if digits.count > 5
        digits.join
      }
    }

    def initialize(args = {})
      @zipcode        = args.fetch(:zipcode).to_s
      @country_alpha2 = args.fetch(:country_alpha2).to_s.upcase.to_sym
    end

    def format
      transformation = ZIPCODES_TRANSFORMATIONS[@country_alpha2]
      case transformation
      when Proc
        transformation.call(@zipcode)
      when Symbol
        ZIPCODES_TRANSFORMATIONS[transformation].call(@zipcode)
      else
        @zipcode.strip
      end
    end

  end
end