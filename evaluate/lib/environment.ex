defmodule Env do
  def new(bindings) do bindings end #assign variables their values in a list. ex: [{:x, 1345}, {:y, 3456}]

  def find(x, []) do
    :havent_binded_that_variable
  end

  def add({x, val}, []) do
    [{x,val}]
  end
  def add({x, val}, [h | t]) do
      z = add({x, val}, t)
      [ h | z ]
  end

  def find(x, [head | tail]) do
    {h, t} = head
    if (x == h) do
      t
    else
      find(x, tail)
    end
  end
end
