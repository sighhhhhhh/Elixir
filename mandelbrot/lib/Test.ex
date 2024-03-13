defmodule Test do
  def demo() do
    small(-0.9, 1.0, 2.004)
  end

  def small(x0, y0, xn) do
    width = 7680
    height = 4320
    depth = 64
    k = (xn - x0) / width
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("small.ppm", image)
    end
end
