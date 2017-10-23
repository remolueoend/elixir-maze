defmodule Grid do
  @moduledoc """
  Manages a 2D list of cells.
  Use `Grid.create` to generate a new grid with the given size.
  Use `Grid.init_cells` to initialize the grid's cells before applying an algorithm on it.
  """
  
  require IEx
  
  @doc """
  Returns the number of rows of the given grid.
  
  ## Example
  iex>
  `Grid.create(2, 3) |> Grid.row_num() == 2`
  """
  def row_num(grid) do
    length(grid)
  end
  
  @doc """
  Returns the number of columns of the given grid.
  
  ## Example
  iex>
  `Grid.create(2, 3) |> Grid.col_num == 3`
  """
  def col_num(grid) do
    length(Enum.at(grid, 0, []))
  end
  
  @doc """
  Generates a new grid with the given number of rows and columns.
  The generated grid contains `rowNum * colNum` cells. Before applying an algorithm on the grid,
  use `Grid.init_cells` to initialize the cells of the grid.
  
  ## Example
  iex>
  `grid = Grid.create(5, 6)`
  """
  def create(rowNum, colNum) do
    Enum.map(
      Enum.to_list(0..rowNum - 1),
      fn(r) -> Enum.map(
        Enum.to_list(0..colNum - 1),
        fn(c) -> Cell.create(r, c) end
      ) end
    )
  end
  
  @doc """
  Initializes the cells of the given grid.
  Returns a new initialized grid.
  
  ## Example
  iex>
  `Grid.create(5, 6) |> Grid.init_cells()`
  """
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
  
  @doc """
  Returns a flattened list containing all cells of the given grid.
  
  ## Example
  iex>
  `Grid.create(5, 6) |> Grid.get_cells()`
  """
  def get_cells(grid) do
    List.flatten(grid)
  end
  
  @doc """
  Maps over the rows of the given grid by calling the provided handler.
  
  ## Example
  iex>
  `Grid.create(5, 6) |> Grid.map_rows(fn(row) -> length(row) end) == [6, 6, 6, 6, 6]`
  """
  def map_rows(grid, handler) do
    Enum.map(grid, fn(r) -> handler.(r) end)
  end
  
  @doc """
  Maps over all cells of the given grid by calling the provided handler.
  ## Example
  iex>
  `Grid.create(1, 2) |> Grid.map_cells(fn(cell) -> {cell.row, cell.col} end) == [{0, 0}, {0, 1}]`
  """
  def map_cells(grid, handler) do
    map_rows(grid, fn(r) ->
      Enum.map(r, fn(c) -> handler.(c) end)
    end)
  end
  
  @doc """
  Returns the cell or NIL at the given row and col of the provided grid.
  
  ## Example
  iex>
  `%{:col, :row} = Grid.create(2, 3) |> Grid.get_cell(1, 2) # row == 1, col == 2`
  """
  def get_cell(grid, row, col) do
    if row < 0 || col < 0 do
      nil
    else
      row = Enum.at(grid, row)
      if row == nil do
        nil
      else
        Enum.at(row, col) 
      end
    end
  end
  
  @doc """
  Returns the cell of NIL with the given uid of the provided grid.
  
  ## Example
  iex>
  ```
  uid = Cell.create_uid(1, 0)
  Grid.create(2, 3) |> Grid.get_cell(uid)
  ```
  """
  def get_cell(grid, cell_uid) do
    Enum.find(get_cells(grid), nil, fn(cell) -> cell.uid == cell_uid end)
  end
  
  @doc """
  Returns a new grid containing the provided cell.
  This function replaces the cell at the row and column of the provided cell.
  
  ## Example
  iex>
  ```
  grid = Grid.create(5, 6)
  cell = Grid.get_cell(1, 2)
  # update cell ...
  Grid.update_cell(grid, cell) # contains updated cell at (1, 2)
  ```
  """
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
  
  @doc """
  Links the two 
  """
  def link_cells(grid, cell1, cell2) do
    link_cells(grid, cell1.row, cell1.col, cell2.row, cell2.col)
  end
  def link_cells(grid, row1, col1, row2, col2) do
    { cell1, cell2 } = Cell.link(get_cell(grid, row1, col1), get_cell(grid, row2, col2))
    update_cell(grid, cell1) |> update_cell(cell2)
  end
  
  def get_random_cell(grid) do
    Enum.random(grid) |> Enum.random()
  end
end