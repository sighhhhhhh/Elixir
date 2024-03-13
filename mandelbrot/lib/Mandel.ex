defmodule Mandel do
  def mandelbrot(width, height, x, y, k, maxDepth) do
    trans = fn(w, h) ->
    Cmplx.new(x + k * (w - 1), y - k * (h - 1)) #gives complex number
    end
    image = rows(width, height, trans, maxDepth, [])
  end

  def rows(width, 0, trans, maxDepth, rows) do rows end #done with all rows

  def rows(width, height, trans, maxDepth, rows) do #does all the rows
    row = row(width, height, trans, maxDepth, [])
    rows(width, height - 1, trans, maxDepth, [row|rows])
  end

  def row(0, height, trans, maxDepth, row) do row end #done with one row

  def row(width, height, trans, maxDepth, row) do
    cmplxNum = trans.(width, height)
    depth = Brot.mandelbrot(cmplxNum, maxDepth)
    color = Colors.convert(depth, maxDepth)
    row(width - 1, height, trans, maxDepth, [color|row])
  end
end
