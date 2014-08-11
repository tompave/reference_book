require 'ostruct'

class ReferenceBook::Setup::Collector < OpenStruct
  def title=(*args)
    protected_attribute_warning('title')
  end

  def library_key=(*args)
    protected_attribute_warning('library_key')
  end


  def []=(key, value)
    if key == :title || key == :library_key
      protected_attribute_warning(key)
    else
      super
    end
  end



private
  
  def protected_attribute_warning(key)
    raise ReferenceBook::BookDefinitionError, "You can't set a Book's #{key} in its definition block"
  end
end
