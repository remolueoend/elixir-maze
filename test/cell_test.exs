defmodule CellTest do
  use ExUnit.Case
  require IEx
  
  doctest Cell
  
  test "if Cell.create returns a new cell" do
    cell = Cell.create 2, 1
    assert cell[:col] == 1
    assert cell[:row] == 2
    assert length(cell[:links]) == 0
  end
  
  test "if create_uid generates a correct UID" do
    assert Cell.create_uid(0, 1) == 1
    assert Cell.create_uid(7, 8) == 78
  end
  
  test "if link adds the 2. cell uid to the first" do
    { cell1, cell2 } = Cell.link(Cell.create(1, 1), Cell.create(1, 2))
    assert Enum.member? cell1.links, cell2.uid
  end
  
  test "if link adds the first cell to the 2. cell id bidi by default" do
    { cell1, cell2 } = Cell.link(Cell.create(1, 1), Cell.create(1, 2))
    assert Enum.member? cell2.links, cell1.uid
  end
  
  test "if unlink removes the 2. cell from the first" do
    { cell1, cell2 } = Cell.link(Cell.create(1, 1), Cell.create(1, 2))
    { cell1, cell2 } = Cell.unlink(cell1, cell2)
    refute Enum.member? cell1.links, cell2.uid
  end
  
  test "if unlink removes the 1. cell from the 2. cell by default" do
    { cell1, cell2 } = Cell.link(Cell.create(1, 1), Cell.create(1, 2))
    { cell1, cell2 } = Cell.unlink(cell1, cell2)
    refute Enum.member? cell2.links, cell1.uid
  end
  
  test "if linked? returns true for linked cells" do
    { cell1, cell2 } = Cell.link(Cell.create(1, 1), Cell.create(1, 2))
    cell3 = Cell.create(1, 3)
    assert Cell.linked? cell1, cell2
    assert Cell.linked? cell2, cell1
    refute Cell.linked? cell1, cell3
    refute Cell.linked? cell2, cell3
  end
end