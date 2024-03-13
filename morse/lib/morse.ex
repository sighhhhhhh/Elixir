defmodule MorseCode do
  @long ?-
  @short ?.
  @pause ?\s
  # The codes that you should decode:

  def base, do: '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ...'

  def rolled, do: '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .----'

  def test do
    decode(rolled(), tree())
  end
  def decode(signal, tree) do
    to_string(decode_signal([], signal, tree, []))
  end

  def decode_signal(currentChar,[], tree, message) do
    char = decodeChar(currentChar,tree)
    message ++ [char]
  end
  def decode_signal(currentChar,[s1|signal], tree, message) do
    if (s1 == @pause) do #or signal == @pause
      char = decodeChar(currentChar,tree)
      decode_signal([],signal,tree, message ++ [char])
    else
      currentChar = currentChar ++ [s1]
      decode_signal(currentChar,signal,tree, message)
    end
  end

  def decodeChar([],{:node,char,long,short}) do
    char
  end
  def decodeChar([c1|charRest],{:node,char,long,short}) do
    if (c1 == @long) do
      decodeChar(charRest,long)
    else if(c1 == @short) do
      decodeChar(charRest, short)
    end
    end
  end

  def encode(message, tree) do
    map = tree_to_map(tree, Map.new())
    signal = message_to_signal(message,[],map)
    to_string(signal)
  end

  def tree_to_map({:node, character, long, short}, map) do
    map = longBranch = branch_to_map(long, [@long], map)
    map = shortBranch = branch_to_map(short, [@short], map)
    #Map.merge(longBranch, shortBranch)
  end

  def branch_to_map(nil,path, map) do
    map
  end
  def branch_to_map({:node, character, long, short},path, map) do
    map = Map.put(map,character,path)
    map = longBranch = branch_to_map(long, path ++ [@long], map)
    map = shortBranch = branch_to_map(short, path ++ [@short], map)
    #Map.merge(longBranch, shortBranch)
  end

  def message_to_signal([],signal,map) do
    signal
  end
  def message_to_signal([m1|message],signal,map) do
    if (m1 == @pause) do
      signal = signal ++ [@pause]
      message_to_signal(message, signal, map)
    else
      {:ok,s} = Map.fetch(map, m1)
      IO.inspect s
      signal = signal ++ [s]
      message_to_signal(message, signal, map)
    end
  end
  # The decoding tree.
  #
  # The tree has the structure  {:node, char, long, short} | :nil
  #
  def tree do
    {:node, :na,
      {:node, 116,
        {:node, 109,
          {:node, 111,
            {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
            {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
          {:node, 103,
            {:node, 113, nil, nil},
            {:node, 122,
              {:node, :na, {:node, 44, nil, nil}, nil},
              {:node, 55, nil, nil}}}},
        {:node, 110,
          {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
          {:node, 100,
            {:node, 120, nil, nil},
            {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
      {:node, 101,
        {:node, 97,
          {:node, 119,
            {:node, 106,
              {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
              nil},
            {:node, 112,
              {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
              nil}},
          {:node, 114,
            {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
            {:node, 108, nil, nil}}},
        {:node, 105,
          {:node, 117,
            {:node, 32,
              {:node, 50, nil, nil},
              {:node, :na, nil, {:node, 63, nil, nil}}},
            {:node, 102, nil, nil}},
          {:node, 115,
            {:node, 118, {:node, 51, nil, nil}, nil},
            {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  end
