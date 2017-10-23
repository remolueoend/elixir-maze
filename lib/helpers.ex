defmodule Helper do
  def times(num, handler) do
    Enum.map(Enum.to_list(0..num - 1), handler)
  end
  
  def times_str(num, handler, joiner \\ "") do
    Enum.join(times(num, handler), joiner)
  end
end