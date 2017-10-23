defmodule BinaryTree do
  def on(grid) do
    Grid.get_cells(grid) |> Enum.reduce(grid, fn(cell, new_grid) ->
      neighbours_uid = [cell.north, cell.east] |> Enum.filter(fn(n) -> n != nil end)
      link_uid = if length(neighbours_uid) > 0 do Enum.random(neighbours_uid) else nil end
      if link_uid != nil do
        link = Grid.get_cell(new_grid, link_uid)
        Grid.link_cells(new_grid, cell, link)
      else
        new_grid
      end
    end)
  end
end