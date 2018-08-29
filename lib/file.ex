defmodule Coord.File do
  def load(file_name \\ "customers.txt") do
    Path.join(:code.priv_dir(:coord), file_name)
    |> to_stream()
  end

  defp to_stream(customers_file) do
    case File.exists?(customers_file) do
      true ->
        {:ok, File.stream!(customers_file)}

      false ->
        {:error, {:missing_file, customers_file}}
    end
  end
end
