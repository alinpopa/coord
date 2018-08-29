defmodule Coord.Stream do
  def run({:ok, stream}),
    do: {:ok, stream |> Enum.to_list()}

  def run({:error, reason}),
    do: {:error, reason}
end
