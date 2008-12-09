module SheepInYourShoes

  # The Pasture
  class Pasture

    attr_reader :sheep, :dog

    def initialize(num_sheep=0)
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

  end

  # Sheep
  class Sheep

    attr_reader :x, :y, :shape

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
      $app.para "Baaa!" and @off = true unless @off
    end

    def off?
      @y < 15
    end

  end

  # Dog
  class Dog

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


Shoes.app do

  $app = self
  @pasture = SheepInYourShoes::Pasture.new(25)

  animate(30) do
    unless @pasture.empty?
      @sheep = @pasture.random_sheep
      @sheep.run! if @sheep
    end
  end

  keypress do |key|
    @pasture.dog.run!(key)
  end

end
