defmodule Brot do
  def mandelbrot(c={a,b}, m) do
    z0 = Cmplx.new(a, b)
    i = 0
    test(i, z0, c, m)
    end

  def test(i,num,c,maxDepth) do
    newNum = Cmplx.add(Cmplx.sqr(num),c)
    if (Cmplx.abs(newNum) > 2) do
      i+1
    else if(i + 1 == maxDepth) do
      0
    else
      test(i+1,newNum,c,maxDepth)
    end end
  end
end
