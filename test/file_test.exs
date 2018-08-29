defmodule Coord.File.Test do
  use ExUnit.Case
  doctest Coord

  @test_file "some_file_used_for_testing.txt"

  setup do
    create_test_file()
    :ok
  end

  test "should load successfully an existing file" do
    on_exit(fn -> remove_test_file() end)
    {:ok, stream} = Coord.File.load(@test_file)
    assert ["This is a test"] == stream |> Enum.to_list()
  end

  test "should fail gracefully when file doesn't exist" do
    on_exit(fn -> remove_test_file() end)
    assert {:error, {:missing_file, _}} = Coord.File.load("unexisting_file.test.txt")
  end

  defp create_test_file do
    File.write(Path.join(:code.priv_dir(:coord), @test_file), "This is a test")
  end

  defp remove_test_file do
    File.rm(Path.join(:code.priv_dir(:coord), @test_file))
  end
end
