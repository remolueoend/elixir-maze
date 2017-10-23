defmodule Maze do
  @moduledoc """
  Documentation for Maze.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Maze.hello
      :world

  """
  def start(_type, _args) do
    grid = Grid.create(5, 5) |> Grid.init_cells()
    maze = BinaryTree.on grid
    DrawAscii.draw(maze)
    Task.start(fn -> :timer.sleep(0); IO.puts("done") end)
  end
end