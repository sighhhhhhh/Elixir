defmodule Evaluate do
  @type literal():: {:num, integer()} | {:var, atom()} | {:rat, number(), integer()}

  @type expr() :: {:add, expr(), expr()}
  | {:sub, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:div, expr(), expr()}
  | literal()

  def eval({:num, n}, _) do n end
  def eval({:var, x}, env) do
    Env.find(x, env)
  end

  def eval({:rat, a, b}, env) do
    if (b == 1) do
      a
    else
    eval({:div, {:num, a}, {:num, a}}, env)
    end end

  def eval({:add, {:rat, c, d}, b}, env) do
    num = eval(b, env) * d + c
    den = d
    factor = (highestCommonFactor(num, den))
    if (factor == 1) do
      {:rat, num, den}
    else if(factor == den) do
      num/den
    else
      {:rat, num/factor, den/factor}
    end end
  end
  def eval({:add, a, {:rat, c, d}}, env) do
    num = eval(a, env) * d + c
    den = d
    factor = (highestCommonFactor(num, den))
    if (factor == 1) do
      {:rat, num, den}
    else if(factor == den) do
      num/den
    else
      {:rat, num/factor, den/factor}
    end end
  end
  def eval({:add, a, b}, env) do
    eval(a, env) + eval(b, env)
  end

  def eval({:sub, a, b}, env) do
    eval(a, env) - eval(b, env)
  end

  def eval({:mul, {:rat, c, d}, b}, env) do
    eval({:rat, eval({:num, c}, env) * eval({:num, b}, env), eval({:num, d}, env)}, env)
  end
  def eval({:mul, a, {:rat, c, d}}, env) do
    eval({:rat, eval({:num, c}, env) * eval({:num, a}, env), eval({:num, d}, env)}, env)
  end
  def eval({:mul, a, b}, env) do
    eval(a, env) * eval(b, env)
  end

  def eval({:div, a, b}, env) do
    newA = eval(a, env)
    newB = eval(b, env)
    num = 1
    if (newA == newB) do
      1
    else case newA < newB do
      true -> num = highestCommonFactor(newA, newB, newA)
      false -> num = highestCommonFactor(newA, newB, newB)
    end
    if (num == b) do
      a
    else
      finalA = newA/num
      finalB = newB/num
      {:rat, {:num, finalA}, {:num, finalB}}
    end end
  end

  def highestCommonFactor(a, b) do
    if (a == b) do
      a
    else case a < b do
      true -> highestCommonFactor(a, b, a)
      false -> highestCommonFactor(a, b, b)
    end end
  end
  def highestCommonFactor(a, b, mod) do
    if(rem(a, mod)==0 && rem(b, mod)==0) do
      mod
    else highestCommonFactor(a, b, mod - 1)
    end
  end
end
