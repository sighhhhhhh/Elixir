defmodule Eager do
  def eval_expr({:atm, id}, _) do
    {:ok, id} end

  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil -> :error
      {id, str} -> {:ok, str}
    end
  end

  def eval_expr({:cons, e1, e2}, env) do
    case eval_expr(e1, env) do
      :error -> :error
      {:ok, str1} ->
    case eval_expr(e2, env) do
      :error -> :error
      {:ok, str2} -> {:ok, {str1, str2}}
    end end
  end

  def eval_expr({:case, expr, cls}, env) do
    IO.inspect :eval_expr_case
    IO.inspect env
    case eval_expr(expr, env) do
    :error -> :error
    {:ok, exprVal} ->
      eval_cls(cls, exprVal, env)
    end
  end

  def eval_expr({:lambda, par, free, seq}, env) do
    case Env.closure(free, env) do
      :error -> :error
      {:ok, closure} -> {:ok, {:closure, par, seq, closure}}
    end
  end

  def eval_expr({:apply, expr, args}, env) do
    case eval_expr(expr, env) do
      :error -> :error
      {:ok, {:closure, par, seq, closure}} ->
        case eval_args(args, env) do
        :error -> :error
        {:ok, strs} ->
          env = Env.args(par, strs, closure)
          eval_seq(seq, env)
        end
    end
  end

  def eval_expr({:fun, id}, env) do
    {par, seq} = apply(Prgm, id, [])
    {:ok, {:closure, par, seq, Env.new()}}
  end


  def eval_args([head|tail], env) do
    IO.inspect :eval_args

    IO.inspect env

    case eval_expr(head, env) do
      :error -> :error
      {:ok, value} ->
        if (tail != []) do
          case eval_args(tail, env) do
            :error -> :error
            {:ok, rest} -> {:ok, [value|rest]}
          end
        else
          {:ok, [value]}
        end
    end
  end

  def eval_cls([], _, _) do
    :error
  end


  def eval_cls([{:clause, ptr, seq} | cls], exprVal, env) do
    IO.inspect :eval_cls_clause

    IO.inspect env
    IO.inspect {ptr, exprVal,env}
    IO.inspect eval_match(ptr, exprVal,env)
    case (eval_match(ptr, exprVal,env)) do
      :fail -> eval_cls(cls, exprVal, env)
      {:ok, newEnv} -> eval_seq(seq, newEnv)
    end
  end

  def eval_match(:ignore, _, env) do

    {:ok, env}
  end
    def eval_match({:atm, id}, id, env) do
      IO.inspect :eval_match_atm
      IO.inspect env
    {:ok, env}
  end

  def eval_match({:var, id}, str, env) do
    IO.inspect :eval_match_var
    IO.inspect env

    case Env.lookup(id, env) do
      nil -> {:ok, Env.add(id, str, env)}
      {_, ^str} -> {:ok, env}
      {_, notstr} -> :fail
    end
  end
  def eval_match({:cons, hp, tp}, {head,tail}, env) do
    IO.inspect :eval_match_cons
    IO.inspect env

    if (hp == tp and head != tail) do
      :fail
    else
    case eval_match(hp, head, env) do
      :fail -> :fail
      {_,newEnv} ->
    eval_match(tp, tail, newEnv)
    end end
  end

  def eval_match(_, _, _) do :fail end

  def eval_seq([exp], env) do
    IO.inspect :eval_seq_exp
    IO.inspect env
    eval_expr(exp, env)
  end

  def eval_seq([{:match, pattern, val} | rest], env) do
    IO.inspect :eval_seq_match
    IO.inspect env

    case eval_expr(val, env) do
    :error -> :error
    {:ok,v} ->
      env = eval_scope(pattern, env)
    case eval_match(pattern, v, env) do
      :fail -> :error
    {:ok, newEnv} ->
      eval_seq(rest, newEnv)
    end end
  end


  def eval_scope(pattern, env) do
    IO.inspect :eval_scope
    IO.inspect env
    Env.remove(extract_vars(pattern), env)
  end
  def extract_vars({:var, x}) do
    [x]
  end
  def extract_vars({:cons, x, y}) do
    extract_vars(x)++extract_vars(y)
  end
  def extract_vars(_) do
    []
  end

  def eval(sequence) do
    eval_seq(sequence, Env.new())
  end
end
