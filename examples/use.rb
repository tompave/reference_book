# Given this configuration:

ReferenceBook.write_book(title: "Elf") do |book|
  book.strength     = 0
  book.dexterity    = +2
  book.constitution = -2
  book.intelligence = 0
  book.wisdom       = 0
  book.charisma     = 0
end

ReferenceBook.write_book(title: "Dwarf") do |book|
  book.strength     = 0
  book.dexterity    = 0
  book.constitution = +2
  book.intelligence = 0
  book.wisdom       = 0
  book.charisma     = -2
end

ReferenceBook.write_book(title: "Halfling") do |book|
  book.strength     = -2
  book.dexterity    = +2
  book.constitution = 0
  book.intelligence = 0
  book.wisdom       = 0
  book.charisma     = 0
end




# The books can be retrieved with:

ReferenceBook.library.index
# => [:elf, :dwarf, :halfling]

ReferenceBook.library.elf
ReferenceBook.library[:elf]

ReferenceBook::Library.elf
ReferenceBook::Library[:elf]

# => #<struct ReferenceBook::Book::Elf
#               strength = 0,
#               dexterity = 2,
#               constitution = -2,
#               intelligence = 0,
#               wisdom = 0,
#               charisma = 0,
#               title = "Elf",
#               library_key = :elf>


# And each book can be queried with:

ReferenceBook.library.elf.dexterity
ReferenceBook.library.elf[:dexterity]
# => 2

ReferenceBook.library.dwarf.dexterity
ReferenceBook.library.dwarf[:dexterity]
# => 0

ReferenceBook.library[:halfling].widsom
ReferenceBook.library[:halfling][:wisdom]
# => 0




# You can wrap it with your own logic:

def modifier_for(race, stat)
  race = race.downcase.to_sym
  stat = stat.downcase.to_sym
  ReferenceBook.library[race][stat]
end

modifier_for('Dwarf', 'Charisma')
# => -2



# Books are read-only:

ReferenceBook.library.dwarf.strength = 10
# RuntimeError: can't modify frozen ReferenceBook::Book::Dwarf






# Also, books are a thin subclass of the base Ruby Struct.
# They are frozen, but expose the same interface:

book = ReferenceBook.library.elf

book.to_h
# => {:strength => 0,
#     :dexterity => 2,
#     :constitution => -2,
#     :intelligence => 0,
#     :wisdom => 0,
#     :charisma => 0,
#     :title => "Elf",
#     :library_key => :elf}

book.to_a
# => [0, 2, -2, 0, 0, 0, "Elf", :elf]

book.members
# => [:strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma, :title, :library_key]

book.select { |value| value != 0 }
# => [2, -2, "Elf", :elf]


book.each_pair { |k, v| puts "#{k}: #{v}" }
# strength: 0
# dexterity: 2
# constitution: -2
# intelligence: 0
# wisdom: 0
# charisma: 0
# title: Elf
# library_key: elf

