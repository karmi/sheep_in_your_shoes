Shoes.app do

  NUM_SHEEPS = 25

  # The Pasture
  background gradient( "#fff", "#00ff05")
  border black, :strokewidth => 6

  x, y = 10, self.height - 10

  # Sheeps
  @sheeps = []
  fill "#fff"
  stroke "#000"
  strokewidth 3
  1.upto NUM_SHEEPS do |i|
    sheep = oval(0, 0, 15, 15)
    sheep.move x + i * 15, y
    @sheeps << sheep
  end

  animate(20) do
    # x += 1
    y -= 5
    @sheeps[ rand NUM_SHEEPS ].move x.to_i, y.to_i
  end

end
