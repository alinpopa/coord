defmodule Coord do
  alias Coord.{File, Stream, Display, Location, Distance}

  @customer_records_file "customers.txt"
  @max_distance_from 100
  @dublin %Location{lat: 53.339428, long: -6.257664, name: "Dublin"}

  def main do
    File.load(@customer_records_file)
    |> Location.Parser.parse()
    |> Distance.calculate_distance(@dublin)
    |> Distance.filter_less_than(@max_distance_from)
    |> Distance.as_displayable()
    |> Stream.run()
    |> Display.print(@max_distance_from, @dublin)
  end
end
