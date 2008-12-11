require 'pp'

# *** ANIMALS *****************************************************************

#-- file Animal.rb
class Animal
  
  attr_accessor :name, :position, :color
  
  def initialize(name)
    @name = name
    @position = 0
    @stuff_in_belly = 0
    @walk_increment = 1
    @run_increment = 10
    puts "Hello, I am a #{self.class.to_s.downcase} named #{self.name}!"
  end
  
  def talk
    puts "#{self.class}: ..."
    
  end
  
  def walk
    @position += @walk_increment
  end
  
  def run
    @position += @run_increment
  end
  
  def feed
    @stuff_in_belly += 1
    puts "[Chewing on some stuff and happy...]"
    self.poop if @stuff_in_belly > 3
  end
  
  def hungry?
    if @stuff_in_belly < 2
      true
    else
      false
    end
  end
  
  protected
  
  def poop
    puts "[Too much stuff in belly... pooping...]"
    @stuff_in_belly = 0
  end
  
end


#-- file Dog.rb
class Dog < Animal
  
  def initialize(name, color)
    super(name)
    @color = color
    @run_increment = 20
    
  end
  
  def talk
    puts "#{self.name}: Woof! woof!"
  end
  
  def fetch(what='stick')
    puts "[#{self.name} is fetching the #{what.downcase}...]"
  end
      
end


#-- file Sheep.rb
class Sheep < Animal

  def talk
    puts "#{self.name}: Beeeeee!"
  end
  
end

# === Dog =====================================================================

# --- Create a dog
dog = Dog.new('Bitzer', 'yellow')
pp dog

# --- Dog's properties (attributes)
puts "Our dog's name is '#{dog.name}'."
puts "And his color is #{dog.color}."

# --- Make the dog do something
puts "> Talk, Bitzer!"
dog.talk

puts "> Fetch, Bitzer!"
dog.fetch
dog.fetch('Ball')

puts "> Walk, Bitzer!"
dog.walk
puts "Dog is at position: #{dog.position}."
puts "> Run, Bitzer!"
dog.run
puts "Dog is at position: #{dog.position}."

puts "> Have a snack, Bitzer!"
dog.feed
puts dog.hungry?

dog.feed
dog.feed
puts dog.hungry?

# dog.poop
dog.feed


puts "\n---\n\n"
# === Sheep ===================================================================

sheep = Sheep.new('Shaun')
pp sheep

sheep.talk

puts sheep.position
sheep.run
puts sheep.position

# sheep.fetch # => NoMethodError