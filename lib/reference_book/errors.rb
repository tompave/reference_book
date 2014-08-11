class ReferenceBook::Error < StandardError
end


class ReferenceBook::BookDefinitionError < ReferenceBook::Error
end

class ReferenceBook::LockedBookSpecError < ReferenceBook::Error
end


# class ReferenceBook::BookLookupError < ReferenceBook::Error
# end
