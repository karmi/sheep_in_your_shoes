Shoes.app do

  # The Pasture
  background gradient( "#fff", "#00ff05")
  border black, :strokewidth => 6

  # The Sheep
  fill "#fff"
  stroke "#000"
  strokewidth 3
  @sheep = oval(0, 0, 15, 15)

  x, y = self.width / 2, self.height

  animate(20) do
    # x += 1
    y -= 1
    @sheep.move x.to_i, y.to_i
  end

end
