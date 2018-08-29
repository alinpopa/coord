defmodule Coord.Display do
  def print(what_to_print, distance \\ 100, location \\ %Coord.Location{})

  def print({:ok, result}, distance, %Coord.Location{name: name}),
    do: IO.inspect({"Customers within #{distance}km of #{name}", result})

  def print({:error, reason}, _distance, _location),
    do: IO.inspect({"Error", reason})
end
