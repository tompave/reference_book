require 'ostruct'

class ReferenceBook::Setup::Collector < OpenStruct
  def title=(*args)
    raise ReferenceBook::BookDefinitionError, "You can't set a Book's title in its definition block"
  end

  def library_key=(*args)
    raise ReferenceBook::BookDefinitionError, "You can't set a Book's library_key in its definition block"
  end
end
