defmodule Coord.Display.Test do
  use ExUnit.Case
  doctest Coord

  test "return the error when recieving an error" do
    assert {"Error", :something_happened} == Coord.Display.print({:error, :something_happened})
  end

  test "successfully display and return a valid message" do
    given = {:ok, [:one, :two]}

    assert {"Customers within 30km of Dublin", [:one, :two]} ==
             Coord.Display.print(given, 30, %Coord.Location{name: "Dublin"})
  end
end
