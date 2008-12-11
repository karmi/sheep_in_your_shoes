module SheepInYourShoes

  # The Pasture
  class Pasture

    attr_reader :sheep, :dog, :catched

    def initialize(num_sheep=0)
      @catched = 0
      @sheep = []
      $app.background gradient( "#fff", "#00ff05")
      $app.border "#000", :strokewidth => 6
      1.upto(num_sheep) do |i|
        @sheep << Sheep.new( { :x => (i * 15),  :y => ($app.height - 10)} )
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
      $app.fill "#fff"; $app.stroke "#000"; $app.strokewidth 3
      @shape = $app.oval 0, 0, 15, 15 # Draw the sheep
      @shape.move @x, @y
    end

    def run!
      @y -= 15 and @shape.move @x, @y unless off?
      baa! if off?
    end

    def baa!
      baa = $app.para("Baaa!") and @off = true unless @off
      baa.move @x, @y
    end

    def off?
      @y < 15
    end

    def back!
      woof = $app.inscription( "Wooof!", :stroke => '#000', :fill => '#ceffcf', :margin => 5 ).move(@x, @y)
      $app.timer(1) { woof.hide }
      $app.fill "#14c2d2"; $app.stroke "#ceffcf"; $app.strokewidth 1
      $app.star(@x, @y, 10, 10, 8)
      @y = $app.height - 15
      @shape.move @x, @y
      @shape.style :fill => '#000'
    end

  end

  # Dog
  class Dog

    attr_reader :x, :y

    def initialize
      @x, @y = $app.width/2-13, $app.height/4
      $app.fill "#FFFC61"; $app.stroke "#000"; $app.strokewidth 4
      @shape = $app.oval(@x, @y, 26, 26) # Draw the dog
    end

    def run!(direction)
      case direction
        when :left  then @x -= 26 unless @x < 26
        when :right then @x += 26 unless @x > $app.width-51
        when :down  then @y += 26 unless @y > $app.height-51
        when :up    then @y -= 26 unless @y < 0
      end
      @shape.move @x, @y
    end

  end

end


Shoes.app :title => 'Sheep Running In Your Shoes' do

  $app = self
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
