defmodule High do
#map([a()], ( a() -> b())) :: [b()]
  def map([],_) do
   []
  end
  def map([head|tail], op) do
    [op.(head)| map(tail, op)]
  end

#reduce([a()], b(), (a(), b() -> b())) :: b()
  def reducer([],startVal,_) do
    startVal
  end
  def reducer([head|tail], startVal, op) do
    op.(head, reducer(tail, startVal, op))
  end

  def reduce1([],finalVal,_) do
    finalVal
  end
  def reduce1([head|tail], currentVal, op) do
    reduce1(tail, op.(head, currentVal), op)
  end

#filter([a()], (a() -> boolean())) :: [a()]
  def filter([],_) do
    []
  end
  def filter([head|tail], op) do
    if (op.(head)) do
      [head|filter(tail, op)]
    else
      filter(tail, op)
    end
  end


  def inc(list, opVal) do map(list, fn(a) -> a + opVal end) end
  def dec(list, opVal) do map(list, fn(a) -> a - opVal end) end
  def mul(list, opVal) do map(list, fn(a) -> a * opVal end) end
  def rem1(list, opVal) do map(list, fn(a) -> rem(a, opVal) end) end

  def length1(list) do reduce1(list, 0, fn(_,b) -> 1 + b end) end
  def length2(list) do reducer(list, 0, fn(_,b) -> 1 + b end) end
  def sum1(list) do reduce1(list, 0, fn(a,b) -> a + b end) end
  def sum2(list) do reducer(list, 0, fn(a,b) -> a + b end) end
  def prod(list) do reduce1(list, 0, fn(a,b) -> a * b end) end

  def even(list) do filter(list, fn(a) -> rem(a,2)==0 end) end
  def odd(list) do filter(list, fn(a) -> rem(a,2)==1 end) end
  def div(list, opVal) do filter(list, fn(a) -> rem(a,opVal)==0 end) end


end
