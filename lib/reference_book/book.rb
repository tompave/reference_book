class ReferenceBook::Book < Struct

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
