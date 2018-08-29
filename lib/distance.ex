defmodule Coord.Distance do
  alias Coord.Location

  @earth_radius 6371.0

  def calculate_distance({:ok, stream}, %Location{} = from_location) do
    {:ok,
     stream
     |> Stream.map(fn location ->
       km_between(location, from_location)
     end)}
  end

  def calculate_distance({:error, reason}, _from_location),
    do: {:error, reason}

  def filter_less_than({:ok, stream}, max_distance) do
    stream =
      stream
      |> Stream.filter(fn
        {distance, _location} when distance <= max_distance ->
          true

        {_, _} ->
          false
      end)

    {:ok, stream}
  end

  def filter_less_than({:error, reason}, _max_distance),
    do: {:error, reason}

  def as_displayable({:ok, stream}) do
    stream =
      stream
      |> Stream.map(fn {distance, location} ->
        %Coord.Displayable{
          user_id: location.user_id,
          name: location.name,
          distance: "#{distance} km"
        }
      end)

    {:ok, stream}
  end

  def as_displayable({:error, stream}),
    do: {:error, stream}

  def km_between(%Location{lat: lat1, long: long1} = location, %Location{lat: lat2, long: long2}) do
    {distance(lat1, long1, lat2, long2), location}
  end

  defp degrees_to_radians(degrees),
    do: degrees * :math.pi() / 180

  defp distance(lat1, long1, lat2, long2) do
    lat_diff = degrees_to_radians(lat2 - lat1)
    long_diff = degrees_to_radians(long2 - long1)
    lat1_rad = degrees_to_radians(lat1)
    lat2_rad = degrees_to_radians(lat2)

    a =
      :math.sin(lat_diff / 2) * :math.sin(lat_diff / 2) +
        :math.sin(long_diff / 2) * :math.sin(long_diff / 2) * :math.cos(lat1_rad) *
          :math.cos(lat2_rad)

    c = 2 * :math.atan2(:math.sqrt(a), :math.sqrt(1 - a))
    @earth_radius * c
  end
end
