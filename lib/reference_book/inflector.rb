module ReferenceBook::Inflector
  class << self

    def constantize(raw)
      if raw && raw.length > 0
        title = raw.to_s.gsub(/[^a-zA-Z]/, '')
        title[0] = title[0].upcase
        title
      end
    end




    def make_key(raw)
      return nil unless raw
      if raw.is_a? Symbol
        raw
      else
        camel_to_snake(raw.to_s).gsub(/[^a-zA-Z0-9]/, '_').downcase.to_sym
      end
    end



  private

    CAMEL_REGEX = /([a-z])([A-Z])/
    def camel_to_snake(raw)
      raw.gsub(CAMEL_REGEX, '\1_\2').downcase
    end

  end
end
