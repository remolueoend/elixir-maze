defmodule DrawAscii do
  def h_wall() do
    "---"
  end
  def v_wall() do
    "|"
  end
  def cross() do
    "+"
  end
  def cell_body() do
    "   "
  end
  
  def draw_row(row) do
    top = Enum.map(row, fn(cell) ->
      cell_body() <> if(Cell.linked_to_uid?(cell, cell.east)) do " " else v_wall() end
    end) |> Enum.join()
    bottom = Enum.map(row, fn(cell) ->
      if(Cell.linked_to_uid?(cell, cell.south)) do cell_body() else h_wall() end <> cross()
    end) |> Enum.join()
    
    v_wall() <> top <> "\n" <> cross() <> bottom
  end
  
  def draw(maze) do
    top_wall = cross() <> Helper.times_str(Grid.col_num(maze), fn(_) ->
      h_wall() <> cross()
    end)
    
    rows = Grid.map_rows(maze, &draw_row/1) |> Enum.join("\n")
    result = top_wall <> "\n" <> rows
    
    IO.puts result
  end
end