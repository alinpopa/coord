defmodule Coord.Stream.Test do
  use ExUnit.Case
  doctest Coord

  test "return the error when recieving an error" do
    assert {:error, :something_happened} == Coord.Stream.run({:error, :something_happened})
  end

  test "return a list from the given stream" do
    given = {:ok, 1..5}
    assert {:ok, [1, 2, 3, 4, 5]} == Coord.Stream.run(given)
  end
end
