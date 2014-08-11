class ReferenceBook::Setup::LockedBookSpec
  

  def initialize(keys_array)
    if keys_array.any?
      @book_keys = symbolize_and_sort(keys_array)
    else
      raise ReferenceBook::LockedBookSpecError, "A LockedBookSpec must have at least one key"
    end
  end



  def verify_keys!(other_keys)
    if @book_keys == other_keys.sort
      true
    else
      missing    = @book_keys - other_keys
      unexpected = other_keys - @book_keys

      message = error_message_with(missing, unexpected)
      raise ReferenceBook::BookDefinitionError, message
    end
  end





private
  
  def symbolize_and_sort(keys)
    keys.map(&:to_sym).sort
  end



  def error_message_with(missing, unexpected)
    msg = "Couldn't create Book"
    if missing.any?
      msg << ", missing keys: [#{missing.join(', ')}]"
    end

    if unexpected.any?
      msg << ", unexpected keys: [#{unexpected.join(', ')}]"
    end

    msg
  end
end

