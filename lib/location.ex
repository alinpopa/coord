defmodule Coord.Location do
  defstruct lat: nil,
            long: nil,
            user_id: nil,
            name: nil

  defmodule Parser do
    def parse({:ok, stream}) do
      {:ok,
       stream
       |> Stream.map(&parse_line/1)
       |> Stream.filter(&filter_valid/1)}
    end

    def parse({:error, reason}),
      do: {:error, reason}

    defp parse_line(line) do
      case Poison.Parser.parse(line) do
        {:ok, data} ->
          %Coord.Location{
            lat: data["latitude"] |> parse_float(),
            long: data["longitude"] |> parse_float(),
            user_id: data["user_id"],
            name: data["name"]
          }

        {:error, reason} ->
          {:error, reason}

        {:error, reason, _extra} ->
          {:error, {:parsing_error, reason}}
      end
    end

    defp parse_float(val) when is_float(val),
      do: val

    defp parse_float(val) when is_binary(val) do
      case Float.parse(val) do
        {val, ""} -> val
        _ -> nil
      end
    end

    defp parse_float(_val),
      do: nil

    defp filter_valid(%Coord.Location{lat: lat, long: long, user_id: user_id, name: name})
         when is_float(lat) and is_float(long) and is_integer(user_id) and is_binary(name) do
      true
    end

    defp filter_valid(_location),
      do: false
  end
end
