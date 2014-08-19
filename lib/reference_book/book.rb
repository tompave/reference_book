class ReferenceBook::Book < Struct


  # default defaults to :no_default (hrm...)
  # to allow for using nil as a default
  #
  def fetch(key, default = :no_default)
    if members.include?(key)
      self[key]
    else
      if :no_default == default
        raise KeyError, "Key '#{key}' is not defined in #{self.class.name}."
      else
        default
      end
    end
  end


  # To hide a book's meta attributes.
  #
  # Since it would be necessary to override almost all methods,
  # it would be better to drop the inheritance and switch to
  # composition, with the Struct (or a Hash) as a private member.
  #
  # def to_h
  #   h = super
  #   h.delete(:title)
  #   h.delete(:library_key)
  #   h
  # end

end
