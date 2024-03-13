defmodule EnvList do
  def hello do
    :world
  end
  def new() do
    []
  end
#sample = [{:a, 12}, {:b, 13}]

  def add([], key, value) do
    [{key,value}]
  end

  def add([h | t], key, value) do
    {k, _} = h
    if(k==key) do
      [{key, value}|t]
    else
      z = add(t, key, value)
      [ h | z ]
    end
  end


  def lookup(map, key) do
    if(length(map) < 1) do
      :no_map_here
    else
      lookup2(map, key)
    end
  end

  def lookup2([head | tail], key) do
    {k,v} = head
    if(k == key) do
      {k,v}
    else if(length(tail)>0) do
        lookup2(tail, key)
    else
      :nah_its_not_here
    end
    end
  end


  def remove([head|tail],key) do
    {k,v} = head
    if(k==key) do
        tail
    else
      z = remove(tail,key)
      if (z == []) do
        [head]
      else
        [head,z]
      end
    end
  end

  def remove([],_) do
    :map_is_empty
  end

end
