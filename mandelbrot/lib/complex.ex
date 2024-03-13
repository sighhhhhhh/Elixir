defmodule Cmplx do
  def new(a,b) do {a,b} end

  def add({aR,aI},{bR, bI}) do {aR + bR, aI + bI} end

  def sqr({r,i}) do {r*r - i*i, 2*r*i} end

  def abs({r,i}) do :math.sqrt(r*r + i*i) end
end
