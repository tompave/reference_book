module ReferenceBook::Inflector
  class << self

    def make_title(raw)
      if raw
        title = raw.to_s.gsub(/[^a-zA-Z]/, '')
        title[0] = title[0].upcase
        title
      end
    end




    def make_key(raw)
      if raw
        raw.to_s.gsub(/[^a-zA-Z0-9]/, '_').downcase.to_sym
      end
    end

  end
end
