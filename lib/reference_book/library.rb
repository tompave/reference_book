module ReferenceBook::Library
  class << self

    def store(book)
      verify_library_key!(book.library_key)

      shelf[book.library_key] = book
      index << book.library_key
      define_accessor_for(book)
      book
    end


    def shelf
      @shelf ||= {}
    end


    def index
      @index ||= []
    end


    def [](key)
      shelf[key]
    end


    def empty!
      index.each { |key| remove_accessor_for(key) }
      @index = []
      @shelf = {}
      nil
    end


    def verify_library_key!(key)
      if is_key_in_use?(key)
        raise ReferenceBook::BookDefinitionError, "the library key '#{key}' is already in use."
      end
    end



  private

    def define_accessor_for(book)
      self.define_singleton_method book.library_key do
        self.shelf[book.library_key]
      end
    end


    def remove_accessor_for(key)
      self.singleton_class.send :remove_method, key
    end


    def is_key_in_use?(key)
      index.include?(key)
    end
    
  end
end
