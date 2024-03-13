defmodule Deriv do
  @type literal():: {:num, number()}
                  | {:var, atom()}

  @type expr() :: {:add, expr(), expr()}
                | {:mul, expr(), expr()}
                | literal()

  def test1() do
    a = {:add, {:add, {:mul, {:num, 2}, {:pow, {:var, :x}, 2}},{:mul, {:num, 3}, {:var, :x}}}, {:num, 5}}
    d = {:pow, {:sin, {:mul, {:num, 2}, {:var, :x}}}, -1}
    e = {:add, {:mul, {:num, 0}, {:var, :x}}, {:num, 5}}
    test = {:pow, {:var, :x}, 2}
    de = deriv(d, :x)
    pprint(de)
  end

  def test2() do
    a = {:add, {:add, {:mul, {:num, 2}, {:pow, {:var, :x}, 2}},{:mul, {:num, 3}, {:var, :x}}}, {:num, 5}}
    d = {:pow, {:sin, {:mul, {:num, 2}, {:var, :x}}}, -1}
    e = {:mul, {:num, 0}, {:var, :x}}
    de = deriv(d, :x)
    ds = simplify(de)
    pprint(ds)
  end


  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end

  def deriv({:mul, e1, e2}, v)
    do ({:add,{:mul, deriv(e1,v), e2}, {:mul, e1, deriv(e2,v)}}) end
  def deriv({:add, e1, e2}, v)
    do ({:add, deriv(e1,v), deriv(e2,v)}) end
  def deriv({:pow, e1, p}, v)
    do ({:mul, {:mul, {:num, p}, {:pow, e1, p-1}}, deriv(e1,v)}) end
  def deriv({:ln, e1}, v)
    do ({:mul, deriv(e1, v), {:pow, e1, -1}}) end
  def deriv({:sin, e1}, v)
    do ({:mul, {:cos, e1}, deriv(e1, v)}) end

  def simplify({:num, n})
    do {:num, n} end
  def simplify({:var, v})
    do {:var, v} end
  def simplify({:add, e1, e2})
    do simplify_add(simplify(e1), simplify(e2)) end
  def simplify({:mul, e1, e2})
    do simplify_mul(simplify(e1), simplify(e2)) end
  def simplify({:pow, e1, 1})
    do e1 end
  def simplify({:pow, e1, 0})
    do {:num, 1} end
  def simplify({:pow, e1, p})
    do {:pow, simplify(e1), p} end
  def simplify({:cos, 1})
    do {:num, 0} end
  def simplify({:cos, 0})
    do {:num, 1} end
  def simplify({:cos, e1})
    do {:cos, simplify(e1)} end
  def simplify({:sin, 1})
    do {:num, 1} end
  def simplify({:sin, 0})
    do {:num, 0} end
  def simplify({:sin, e1})
    do {:cos, simplify(e1)} end

  def simplify_add({:num, 0}, e2)
    do e2 end
  def simplify_add(e1, {:num, 0})
    do e1 end
  def simplify_add({:num, n1}, {:num, n2})
    do {:num, n1 + n2} end
  def simplify_add(e1, e2)
    do {:add, e1, e2} end

  def simplify_mul({:num, 0}, e2)
    do {:num, 0} end
  def simplify_mul(e1, {:num, 0})
    do {:num, 0} end
  def simplify_mul({:num, 1}, e2)
    do e2 end
  def simplify_mul(e1, {:num, 1})
    do e1 end
  def simplify_mul({:num, n1}, {:num, n2})
    do {:num, n1*n2} end
  def simplify_mul(e1, e2)
    do {:mul, e1, e2} end

  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end
  def pprint({:add, e1, e2})
    do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:mul, e1, e2})
    do "(#{pprint(e1)} * #{pprint(e2)})" end
  def pprint({:pow, e1, p})
    do "(#{pprint(e1)}) ^ #{p}" end
  def pprint({:ln, e1})
    do "ln(#{pprint(e1)})" end
  def pprint({:sin, e1})
    do "sin(#{pprint(e1)})" end
  def pprint({:cos, e1})
    do "cos(#{pprint(e1)})" end

end
