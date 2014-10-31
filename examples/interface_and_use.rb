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

ReferenceBook.library.dwarf.charisma
ReferenceBook.library.dwarf[:charisma]
# => -2

ReferenceBook.library[:halfling].widsom
ReferenceBook.library[:halfling][:wisdom]
# => 0

# Books implement fetching with defaults:

ReferenceBook.library.halfling.fetch :strength
# => -2
ReferenceBook.library.halfling.fetch :strength, 100
# => -2
ReferenceBook.library.halfling.fetch :luck, 100
# => 100



# The Library supports horizontal queries

ReferenceBook.library.pluck :constitution
ReferenceBook.library.array_for :constitution
# => [-2, 2, 0]


ReferenceBook.library.hash_pluck :constitution
ReferenceBook.library.hash_for :constitution
# => {:elf => -2, :dwarf => 2, :halfling => 0}



# and complete serializations to Ruby
ReferenceBook.library.to_h
# => { :elf => { :strength => 0,
#                :dexterity => 2,
#                :constitution => -2,
#                :intelligence => 0,
#                :wisdom => 0,
#                :charisma => 0 },
#      :dwarf => { :strength => 0,
#                  :dexterity => 0,
#                  :constitution => 2,
#                  :intelligence => 0,
#                  :wisdom => 0,
#                  :charisma => -2 },
#      :halfling => { :strength => -2,
#                     :dexterity => 2,
#                     :constitution => 0,
#                     :intelligence => 0,
#                     :wisdom => 0,
#                     :charisma => 0 }
#     }

# You can pass 'true' to include 'title' and 'library_key' to the serialized results
ReferenceBook.library.to_h(true)
# => { :elf => { # ...like the one above, plus:
#                :title => "Elf",
#                :library_key => :elf },
#      :dwarf => { # ...like the one above, plus:
#                  :title => "Dwarf",
#                  :library_key => :dwarf },
#      :halfling => { # ...like the one above, plus:
#                     :title => "Halfling",
#                     :library_key => :halfling }
#    }


ReferenceBook.library.rotate
# => { :strength => {:elf => 0, :dwarf => 0, :halfling => -2},
#      :dexterity => {:elf => 2, :dwarf => 0, :halfling => 2},
#      :constitution => {:elf => -2, :dwarf => 2, :halfling => 0},
#      :intelligence => {:elf => 0, :dwarf => 0, :halfling => 0},
#      :wisdom => {:elf => 0, :dwarf => 0, :halfling => 0},
#      :charisma => {:elf => 0, :dwarf => -2, :halfling => 0}}


# You can pass 'true' to include 'title' and 'library_key' to the serialized results
ReferenceBook.library.rotate(true)
# => { # ...like the one above, plus:
#      :title => {:elf => "Elf", :dwarf => "Dwarf", :halfling => "Halfling"},
#      :library_key => {:elf => :elf, :dwarf => :dwarf, :halfling => :halfling}}




# You can wrap it with your own logic:

def modifier_for(race, stat)
  race_key = race.downcase.to_sym
  stat_key = stat.downcase.to_sym
  ReferenceBook.library[race_key][stat_key]
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

