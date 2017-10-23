ExUnit.start()

defmodule TH do
  def uid(row, col) do
    Cell.create_uid(row, col)
  end
end