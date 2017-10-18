defmodule Grid do
  require IEx
  
  def create(rowsNum, colNum) do
    grid = Enum.map(
      Enum.to_list(1..rowsNum),
      fn(r) -> Enum.map(
        Enum.to_list(1..colNum),
        fn(c) -> Cell.create(r - 1, c - 1) end
      ) end
    )
    
    init_cells(grid)
  end
  
  def init_cells(grid) do
    to_uid = fn(c) ->
      if c == nil do nil else Cell.create_uid c end
    end

    Enum.map(
      grid,
      fn(r) -> Enum.map(
        r,
        fn(c) -> Map.merge(c, %{
          :north => get_cell(grid, c.row - 1, c.col) |> to_uid.(),
          :south => get_cell(grid, c.row + 1, c.col) |> to_uid.(),
          :east => get_cell(grid, c.row, c.col + 1) |> to_uid.(),
          :west => get_cell(grid, c.row, c.col - 1) |> to_uid.()
        }) end
      ) end
    )
  end
  
  def get_cells(grid) do
    List.flatten(grid)
  end
  
  def each_cell(grid, handler) do
    Enum.map(List.flatten(grid), fn(c) -> handler.(c) end)
  end
  
  def get_cell(grid, row, col) do
    row = Enum.at(grid, row)
    if row == nil do nil else Enum.at(row, col) end
  end
  
  def update_cell(grid, cell) do
    List.replace_at(
      grid,
      cell.row,
      Enum.at(grid, cell.row) |> List.replace_at(
        cell.col,
        cell
      )
    )
  end
  
  def link_cells(grid, cell1, cell2) do
    link_cells(grid, cell1.row, cell1.col, cell2.row, cell2.col)
  end
  def link_cells(grid, row1, col1, row2, col2) do
    { cell1, cell2 } = Cell.link(get_cell(grid, row1, col1), get_cell(grid, row2, col2))
    update_cell(grid, cell1) |> update_cell(cell2)
  end
end