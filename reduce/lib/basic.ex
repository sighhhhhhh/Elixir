defmodule Basic do

  def length1([_head|tail]) do
    if (tail != []) do
      1 + length1(tail)
    else
      1
    end
  end

  def even([]) do [] end
  def even([head|tail]) do
    if rem(head,2)==0 do
      [head|even(tail)]
    else
      even(tail)
    end
  end

  def odd([]) do [] end
  def odd([head|tail]) do
    if rem(head,2)==1 do
      [head|odd(tail)]
    else
      odd(tail)
    end
  end

  def inc([],_) do [] end
  def inc([head|tail],inc) do
    [head+inc|inc(tail,inc)]
  end

  def dec([],_) do [] end
  def dec([head|tail], dec) do
    [head - dec|dec(tail, dec)]
  end

  def sum([]) do 0 end
  def sum([head|tail]) do
    head + sum(tail)
  end

  def mul([],_) do [] end
  def mul([head|tail], val) do
    [head * val|mul(tail, val)]
  end

  def rem1([],_) do [] end
  def rem1([head|tail], val) do
    [rem(head,val)|rem1(tail, val)]

  end

  def prod([]) do 1 end
  def prod([head|tail]) do
    head * prod(tail)
  end

  def div1([],_) do [] end
  def div1([head|tail], val) do
    if (rem(head,val)==0) do
      [head|div1(tail, val)]
    else
      div1(tail,val)
    end
  end

end
