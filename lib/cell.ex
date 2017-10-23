defmodule Cell do

  def create_uid(cell) do
    create_uid(cell.row, cell.col)
  end
  def create_uid(row, col) do
    :crypto.hash(:md5, to_string(row) <> ":" <> to_string(col))
  end
  
  def create(row, col) do
    %{
      :uid => create_uid(row, col),
      :row => row,
      :col => col,
      :links => []
    }
  end
  
  def link(cell1, cell2, bidi \\ true) do
    {
      Map.put(cell1, :links, [cell2.uid | cell1.links]),
      if bidi do elem(link(cell2, cell1, false), 0) else cell2 end
    }
  end
  
  def unlink(cell1, cell2, bidi \\ true) do
    {
      Map.put(cell1, :links, List.delete(cell1.links, cell2.uid)),
      if bidi do elem(unlink(cell2, cell1, false), 0) else cell2 end
    }
  end
  
  def linked?(cell1, cell2) do
    Enum.member?(cell1.links, cell2.uid) && Enum.member?(cell2.links, cell1.uid)
  end
  
  def linked_to_uid?(cell, uid) do
    Enum.member?(cell.links, uid)
  end
  
  def get_neighbours(cell) do
    Enum.filter([cell.north, cell.east, cell.south, cell.west], fn(n) -> n != nil end)
  end
end