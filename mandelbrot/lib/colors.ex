defmodule Colors do
  def convert(depth, max) do
    f = depth/max
    float = f*5
    x = floor(float)
    y = floor(255*(float-x))
    case x do
      0 -> {:rgb, y, 0, 0}
      1 -> {:rgb, 255, y, 0}
      2 -> {:rgb, 255 - y, 255, 0}
      3 -> {:rgb, 0, 255, y}
      4 -> {:rgb, 0, 255 - y, 255}
      5 -> {:rgb, 0, 255 - y, 255}
    end
  end
end
