defmodule GridTest do
  use ExUnit.Case
  require IEx
  
  doctest Grid
  
  test "if Grid.create creates a 2d array of the given size" do
    grid = Grid.create 5, 10
    assert length(grid) == 5
    assert length(Enum.at(grid, 0)) == 10
  end
  
  test "if get_cell returns the cell at the given coordinates" do
    pick = fn(c) -> Map.take(c, [:row, :col, :links, :uid]) end
    grid = Grid.create 2, 2
    assert Grid.get_cell(grid, 0, 0) |> pick.() == Cell.create 0, 0
    assert Grid.get_cell(grid, 0, 1) |> pick.() == Cell.create 0, 1
    assert Grid.get_cell(grid, 1, 0) |> pick.() == Cell.create 1, 0
    assert Grid.get_cell(grid, 1, 1) |> pick.() == Cell.create 1, 1
  end
  
  test "if get_cell returns nil if values are provided outside the gird" do
    grid = Grid.create 2, 2
    assert Grid.get_cell(grid, 3, 0) == nil
    assert Grid.get_cell(grid, 0, 5) == nil
    assert Grid.get_cell(grid, -3, 5) == nil
  end
  
  test "if Grid.create creates a 2d list of cells" do
    grid = Grid.create 2, 2
    cell1 = Grid.get_cell(grid, 0, 0)
    cell2 = Grid.get_cell(grid, 0, 1)
    cell3 = Grid.get_cell(grid, 1, 0)
    cell4 = Grid.get_cell(grid, 1, 1)
    
    assert cell1.row == 0
    assert cell1.col == 0
    assert cell2.row == 0
    assert cell2.col == 1
    assert cell3.row == 1
    assert cell3.col == 0
    assert cell4.row == 1
    assert cell4.col == 1
  end
  
  test "if Grid.get_cells returns the list of all cells" do
    grid = Grid.create 2, 2
    Enum.map(Grid.get_cells(grid), fn(c) -> {c.row, c.col} end) == [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  end
  
  test "if Grid.each_cell loops through all cells" do
    grid = Grid.create 2, 2
    assert Grid.each_cell(grid, fn(c) -> {c.row, c.col} end) == [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  end
  
  test "if update_cell updates the cell at its own coordinate" do
    new_cell = Cell.create(1, 1)
    new_cell = Map.put(new_cell, :test, "foo")
    grid = Grid.update_cell(Grid.create(2, 2), new_cell)
    assert Grid.get_cell(grid, 1, 1).test == "foo"
  end
  
  test "if link_cells links the given ccors correctly" do
    grid = Grid.link_cells(Grid.create(2, 2), 0, 1, 1, 1)
    cell1 = Grid.get_cell(grid, 0, 1)
    cell2 = Grid.get_cell(grid, 1, 1)
    assert Cell.linked? cell1, cell2
  end
  
  test "if init_cells initializes the cells' neighbours" do
    grid = Grid.create 2, 2 |> Grid.init_cells()
    cell1 = Grid.get_cell(grid, 0, 0)
    assert cell1.north == nil
    assert cell1.west == nil
  end
end