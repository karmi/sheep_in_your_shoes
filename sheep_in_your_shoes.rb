module SheepInYourShoes

  # The game's canvas
  class Canvas

    class << self

      def get; @@canvas; end

      def set(canvas); @@canvas = canvas; end

      def draw(&b); @@canvas.instance_eval(&b) if block_given?; end

    end

  end

  # The Pasture
  class Pasture

    attr_reader :sheep, :dog, :catched

    def initialize(num_sheep=0)
      @catched = 0
      @sheep = []
      # Draw the green pasture
      Canvas.draw do
        background gradient( "#fff", "#00ff05")
        border "#000", :strokewidth => 6
      end
      1.upto(num_sheep) do |i|
        @sheep << Sheep.new( { :x => (i * 15),  :y => (Canvas.get.height - 10)} )
      end
      @dog = Dog.new
    end

    def random_sheep
      sheep = @sheep[rand @sheep.size]
      if sheep && sheep.off?
        @sheep -= [sheep]
        random_sheep
      else
        sheep
      end
    end

    def empty?
      @sheep.empty?
    end

    def remove_sheep_on(x, y)
      found = @sheep.select { |sheep| (x-13..x+13).include?(sheep.x) && (y-13..y+13).include?(sheep.y) }.first
      found.back! and @sheep.delete(found) and @catched += 1 unless found.nil? || found.off?
    end

  end

  # Sheep
  class Sheep

    attr_reader :x, :y

    def initialize(options={})
      @x, @y = options[:x] || 0, options[:y] || 0
      Canvas.draw { fill "#fff"; stroke "#000"; strokewidth 3 }
      @shape = Canvas.draw { oval 0, 0, 15, 15 }
      @shape.move @x, @y
    end

    def run!
      @y -= 15 and @shape.move @x, @y unless off?
      baa! if off?
    end

    def baa!
      baa = Canvas.draw { para("Baaa!") } and @off = true unless @off
      baa.move @x, @y
    end

    def off?
      @y < 15
    end

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

  # Dog
  class Dog

    attr_reader :x, :y

    def initialize
      @x, @y = Canvas.get.width/2-13, Canvas.get.height/4
      @shape = Canvas.draw do
        fill "#FFFC61"
        stroke "#000"
        strokewidth 4
        oval(0, 0, 26, 26)
      end
      @shape.move @x, @y
    end

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

end


Shoes.app :title => 'Sheep Running In Your Shoes' do

  SheepInYourShoes::Canvas.set( self )
  @pasture = SheepInYourShoes::Pasture.new(25)

  def game_is_over(message)
    stack :margin => 30, :margin_top => 100 do
      background '#fff', :stroke => '#000',:curve => 15
      title message, :stroke => '#082299', :align => 'center', :margin_top => 15
      stack(:attach => @finale, :align => 'center', :margin => 5) do
        b = button("Close", :align => 'center') { close }
        b.displace(self.width/2-70-b.width/2, 0) # Center the button
      end
    end
    @timer.stop
  end

  @timer = animate(30) do
    unless @pasture.empty?
      @sheep = @pasture.random_sheep
      @sheep.run! if @sheep
    else
      message = @pasture.catched > 5 ? "Congratz! You have catched more than #{@pasture.catched-1} sheep!" : "Game Over!"
      game_is_over(message)
    end
  end

  keypress do |key|
    @pasture.dog.run!(key)
    @pasture.remove_sheep_on(@pasture.dog.x, @pasture.dog.y)
  end

end
