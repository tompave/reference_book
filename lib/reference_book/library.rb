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




    def array_for(attribute)
      shelf.map do |key, book|
        book[attribute] if book.respond_to?(attribute)
      end
    end
    alias_method :pluck, :array_for


    def hash_for(attribute)
      Hash[
        shelf.map do |key, book|
          [key, (book[attribute] if book.respond_to?(attribute))]
        end
      ]
    end
    alias_method :hash_pluck, :hash_for



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
