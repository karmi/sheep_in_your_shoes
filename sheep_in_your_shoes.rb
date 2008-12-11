# = Sheep In Your Sheeps: A Game
#
# A simple game for the Shoes GUI toolkit by Why The Lucky Stiff (www.shoooes.net).
#
# An educational aid for teaching programming concepts.
#
# An illustration of OOP principles: mapping the problem domain, encapsulation, modularity, interface.
#
# A demo of modern 2D computer graphics and interactivity.
#
# A testament of iterative, organic cultivating of the code toward it's better self
#
# Written by Karel Minarik (www.karmi.cz). Published under MIT license.
#
# Source is available at http://github.com/karmi/sheep_in_your_shoes
#
# 
module SheepInYourShoes

  # == The game's canvas
  class Canvas
    class << self
      # Get reference to Shoes canvas
      def get; @@canvas; end
      # Set reference to Shoes canvas
      def set(canvas); @@canvas = canvas; end
      # Pass block of Shoes code as argument
      def draw(&b); @@canvas.instance_eval(&b) if block_given?; end
    end
  end

  # == The Pasture
  class Pasture

    attr_reader :sheep, :dog, :catched

    # Pass number of sheep as argument (game levels, anyone?)
    def initialize(num_sheep=0)
      @catched = 0
      @sheep = []
      # Draw the green pasture ...
      Canvas.draw do
        background gradient( "#fff", "#00ff05")
        border "#000", :strokewidth => 6
      end
      # ... and populate it with sheep
      1.upto(num_sheep) do |i|
        @sheep << Sheep.new( { :x => (i * 15),  :y => (Canvas.get.height - 10)} )
      end
      # ... and the dog!
      @dog = Dog.new
    end

    # Select random sheep from the herd (not including those who have run off or back already)
    def random_sheep
      sheep = @sheep[rand @sheep.size]
      if sheep && sheep.off?
        @sheep -= [sheep]
        random_sheep
      else
        sheep
      end
    end

    # Are there any sheeps on pasture?
    def empty?
      @sheep.empty?
    end

    # If there's a sheep in "dog's perimeter", run it back and remove it from the herd
    def remove_sheep_on(x, y)
      found = @sheep.select { |sheep| (x-13..x+13).include?(sheep.x) && (y-13..y+13).include?(sheep.y) }.first
      found.back! and @sheep.delete(found) and @catched += 1 unless found.nil? || found.off?
    end

  end

  # == The Sheep
  class Sheep

    attr_reader :x, :y

    # Pass position as argument
    def initialize(options={})
      @x, @y = options[:x] || 0, options[:y] || 0
      # Draw the sheep
      Canvas.draw { fill "#fff"; stroke "#000"; strokewidth 3 }
      @shape = Canvas.draw { oval 0, 0, 15, 15 }
      @shape.move @x, @y
    end

    # Make the sheep run off
    def run!
      @y -= 15 and @shape.move @x, @y unless off?
      baa! if off?
    end

    # Make the sheep say "Baaa!"
    def baa!
      baa = Canvas.draw { para("Baaa!") } and @off = true unless @off
      baa.move @x, @y
    end

    # Is the sheep off the pasture?
    def off?
      @y < 15
    end

    # Make the sheep run back
    def back!
      # Draw the woof
      woof = Canvas.draw { inscription( "Wooof!", :stroke => '#000', :fill => '#ceffcf', :margin => 5 ) }.move(@x, @y)
      Canvas.get.timer(1) { woof.hide }
      # Draw the star
      Canvas.draw { fill "#14c2d2"; stroke "#ceffcf"; strokewidth 1; star(0, 0, 10, 10, 8) }.move(@x, @y)
      @y = Canvas.get.height - 15
      @shape.move @x, @y                # Move sheep to bottom ...
      @shape.style :fill => '#000'      # ... and paint it black
    end

  end

  # == The Dog
  class Dog

    attr_reader :x, :y

    def initialize
      @x, @y = Canvas.get.width/2-13, Canvas.get.height/4
      # Draw the dog
      @shape = Canvas.draw do
        fill "#FFFC61"
        stroke "#000"
        strokewidth 4
        oval(0, 0, 26, 26)
      end
      @shape.move @x, @y
    end

    # Make the dog run in the +direction+ passed as argument
    def run!(direction)
      case direction
        when :left  then @x -= 26 unless @x < 26
        when :right then @x += 26 unless @x > Canvas.get.width-51
        when :down  then @y += 26 unless @y > Canvas.get.height-51
        when :up    then @y -= 26 unless @y < 0
      end
      @shape.move @x, @y
    end

  end

  # == The message
  class Message
    class << self
      # Display initial message (and hide it after 2 seconds)
      def initial
        @@initial_message = Canvas.draw do
          stack :margin => 30 do
            background '#fff', :stroke => '#000',:curve => 15
              title "Use arrow keys to catch sheep with the dog", :stroke => '#000', :align => 'center', :margin_top => 15
          end
        end.move(0, 150)
        Canvas.get.timer(3) do
          @@initial_message.clear
        end
      end
      # Display final message
      def final(message)
        Canvas.draw do
          stack :margin => 30, :margin_top => 0 do
            background '#fff', :stroke => '#000',:curve => 15
            title message, :stroke => '#082299', :align => 'center', :margin_top => 15
            stack(:attach => @finale, :align => 'center', :margin => 5) do
              b = button("Close", :align => 'center') { close }
              b.displace(self.width/2-70-b.width/2, 0) # Center the button
            end
          end
        end
      end
    end
  end

end

# == The Shoes application

Shoes.app :title => 'Sheep Running In Your Shoes' do

  # Get reference to game canvas
  SheepInYourShoes::Canvas.set( self )

  # Set up game
  @pasture = SheepInYourShoes::Pasture.new(25)

  # Display instructions
  SheepInYourShoes::Message.initial


  # Now... LET'S RUN! :)
  @timer = animate(30) do
    unless @pasture.empty?
      @sheep = @pasture.random_sheep
      @sheep.run! if @sheep
    else
      # ... or display game over / congratz message and stop the game
      message = @pasture.catched > 5 ? "Congratz! You have catched more than #{@pasture.catched-1} sheep!" : "Game Over!"
      SheepInYourShoes::Message.final( message )
      @timer.stop
    end
  end

  # Capture keypress and pass it to the dog
  keypress do |key|
    @pasture.dog.run!(key)
    @pasture.remove_sheep_on(@pasture.dog.x, @pasture.dog.y)
  end

end
