defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'  end

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    #IO.inspect "this is the encode"
    #IO.inspect encode
    decode = decode_table(tree)
    #IO.inspect "this is the decode"
    #IO.inspect decode
    text = text()
    seq = encode(text, encode)
    #IO.inspect "this is the sequence"
    #IO.inspect seq
    #IO.inspect "this is the sentence"
    decode(seq, decode)
    :done
  end

  def benchmark do
    {microseconds,_} = :timer.tc(fn() -> benchmark_tester() end)
    microseconds/1000
  end

  def benchmark_tester do
    text1 = read("test16.txt")
    tree = tree(text1)
    encode = encode_table(tree)
    decode = decode_table(tree)

    text2 = read("test.txt")
    seq = encode(text2, encode)
    decode(seq, decode)
    :done
  end

  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} -> list
      list -> list
    end
  end

  def tree(sample) do
    #freq = freq(String.codepoints(sample))
    freq = freq(sample)
    huffman_tree(freq)
  end

  def freq(sample) do freq(sample, Map.new()) end
  def freq([], freq) do freq end
  def freq([char | rest], freq) do
    charFreq = Map.get(freq,char)
    case charFreq do
      nil -> freq(rest, Map.put(freq,char,1))
      _ -> freq(rest, Map.put(freq,char,charFreq + 1))
    end
  end

  def huffman_tree(freq) do
    sorted = Enum.sort(freq, fn({_,f1}, {_,f2}) -> f1 > f2 end)
    huffman(sorted)
  end

  def huffman([{tree,freq}]) do tree end
  def huffman([{leaf1,freq1},{leaf2,freq2}|rest]) do
    node ={{leaf1,leaf2},freq1+freq2}
    newTree = Enum.sort([node|rest], fn({_,f1}, {_,f2}) -> f1 > f2 end)
    huffman(newTree)
  end

  def encode_table(tree) do
    encode_branches(tree,[])
  end

  def encode_branches({left,right},path) do
    leftBranch = encode_branches(left,List.flatten([path,0]))
    rightBranch = encode_branches(right,List.flatten([path,1]))
    List.flatten([leftBranch, rightBranch])
  end
  def encode_branches(leaf,path) do {leaf,path} end

  def decode_table(tree) do
    decode_branches(tree,[])
  end
  def decode_branches({left,right},path) do
    leftBranch = decode_branches(left,List.flatten([path,0]))
    rightBranch = decode_branches(right,List.flatten([path,1]))
    List.flatten([leftBranch, rightBranch])
  end
  def decode_branches(leaf,path) do {path,leaf} end

  def encode(text, table) do
    #stringList = String.codepoints(text)
    stringList = text
    seqList = []
    Enum.map(stringList, fn x -> seqList ++ returnSeq(x,table)
      end)
  end

  def returnSeq(_, []) do "something went wrong" end
  def returnSeq(char, [{c,seq}|rest]) do
    if char == c do
      seq
    else
      returnSeq(char, rest)
    end
  end

  def decode([num|seq], tree) do
    to_string(decode2(num,seq,tree,[]))
  end

  def decode2([],[],table,string) do string end
  def decode2(currentSeq, seq,table,currentString) do
    if seq != [] do
      [nextNum|rest] = seq
      case returnChar(currentSeq, table) do
        nil -> decode2(currentSeq ++ nextNum,rest,table,currentString)
        char -> decode2(nextNum,rest,table,currentString ++ [char])
      end
    else #for when we are on the last letter
      nextNum = []
      rest = []
      case returnChar(currentSeq, table) do
        nil -> decode2(currentSeq ++ nextNum,rest,table,currentString)
        char -> decode2(nextNum,rest,table,currentString ++ [char])
      end
    end
  end

  def returnChar(_, []) do nil end
  def returnChar(seq, [{s,char}|rest]) do
    if seq == s do
      char
    else
      returnChar(seq, rest)
    end
  end

end
