require_relative 'lib/active_record_lite'


# open database connection
DBConnection.reset

# define cat model
class Cat < SQLObject
  my_attr_accessor :id, :name, :owner_id

  belongs_to :human, foreign_key: :owner_id
  has_one_through :house, :human, :house
end

# define human model
class Human < SQLObject
  self.table_name = 'humans' # override table_name (default is 'humen')
  my_attr_accessor :id, :fname, :lname, :house_id

  has_many :cats, foreign_key: :owner_id
  belongs_to :house
end

# define house model
class House < SQLObject
  my_attr_accessor :id, :address

  # specify class_name, foreign_key, primary_key (defaults are identical in this case)
  has_many :humans,
    class_name: 'Human',
    foreign_key: :house_id,
    primary_key: :id

  has_many_through :cats, :humans, :cats
end

puts 'simple find queries:'
puts '-------------------'
cat = Cat.find(2)
puts "cat = Cat.find(2)       => #{cat.inspect}"
puts "cat.name                => #{cat.name}"

puts

human = Human.find(3)
puts "human = Human.find(1)   => #{human.inspect}"
puts "human.fname             => #{human.fname}"

puts

puts 'simple where queries:'
puts '-------------------'
cat2 = Cat.where(owner_id: 3)
puts "Cat.where(owner_id: 3)  => #{cat2.inspect}"
puts "cat.first.name          => #{cat2.first.name}"
puts "cat.last.name           => #{cat2.last.name}"

puts

puts 'belongs_to associations:'
puts '-----------------------'
puts "cat.human               => #{cat.human.inspect}"
puts "cat.human.fname:        => #{cat.human.fname}"
puts "human.house.address:    => #{human.house.address}"

puts

puts 'has_many associations:'
puts '---------------------'
puts "human.cats              => #{human.cats.inspect}"
puts "human.cats.count        => #{human.cats.count}"

puts

puts 'has_one_through associations:'
puts '----------------------------'
puts "cat.house               => #{cat.house.inspect}"
puts "cat.house.address:      => #{cat.house.address}"

puts

house = House.find(1)
puts 'has_many_through associations:'
puts '----------------------------'
puts "house.cats               => #{house.cats}"
puts "human.cats.count         => #{house.cats.count}"
