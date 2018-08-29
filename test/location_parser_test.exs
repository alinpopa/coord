defmodule Coord.Location.Parser.Test do
  use ExUnit.Case
  doctest Coord

  test "return the error when recieving an error" do
    assert {:error, :something_happened} ==
             Coord.Location.Parser.parse({:error, :something_happened})
  end

  test "exclude invalid json lines from the stream" do
    locations = [
      '{"latitude": "52.986375", "user_id": 12, "name": "Christina McArdle", "longitude": "-6.043701"',
      '{{"latitude": "54.0894797", "user_id": 8, "name": "Eoin Ahearn", "longitude": "-6.18671"}',
      '{"latitude": "52.366037", "user_id": 16, "name": "Ian Larkin", "longitude": "-8.179118"}'
    ]

    {:ok, parsed_locations} = Coord.Location.Parser.parse({:ok, locations})

    assert [%Coord.Location{lat: 52.366037, long: -8.179118, name: "Ian Larkin", user_id: 16}] ==
             parsed_locations |> Enum.to_list()
  end

  test "exclude records that have invalid latitude" do
    locations = [
      '{"latitude": "52.oh366037", "user_id": 16, "name": "Someone", "longitude": "-8.179118"}',
      '{"latitude": "52.366037", "user_id": 16, "name": "Someone Else", "longitude": "-8.179118"}'
    ]

    {:ok, parsed_locations} = Coord.Location.Parser.parse({:ok, locations})

    assert [
             %Coord.Location{
               lat: 52.366037,
               long: -8.179118,
               name: "Someone Else",
               user_id: 16
             }
           ] == parsed_locations |> Enum.to_list()
  end

  test "exclude records that have invalid longitude" do
    locations = [
      '{"latitude": "52.366037", "user_id": 16, "name": "Someone", "longitude": "-8.179oh118"}',
      '{"latitude": "52.366037", "user_id": 16, "name": "Someone Else", "longitude": "-8.179118"}'
    ]

    {:ok, parsed_locations} = Coord.Location.Parser.parse({:ok, locations})

    assert [
             %Coord.Location{
               lat: 52.366037,
               long: -8.179118,
               name: "Someone Else",
               user_id: 16
             }
           ] == parsed_locations |> Enum.to_list()
  end

  test "exclude records that have missing latitude" do
    locations = [
      '{"user_id": 16, "name": "Someone", "longitude": "-8.179118"}',
      '{"latitude": "52.366037", "user_id": 16, "name": "Someone Else", "longitude": "-8.179118"}'
    ]

    {:ok, parsed_locations} = Coord.Location.Parser.parse({:ok, locations})

    assert [
             %Coord.Location{
               lat: 52.366037,
               long: -8.179118,
               name: "Someone Else",
               user_id: 16
             }
           ] == parsed_locations |> Enum.to_list()
  end

  test "exclude records that have missing longitude" do
    locations = [
      '{"latitude": "52.366037", "user_id": 16, "name": "Someone"}',
      '{"latitude": "52.366037", "user_id": 16, "name": "Someone Else", "longitude": "-8.179118"}'
    ]

    {:ok, parsed_locations} = Coord.Location.Parser.parse({:ok, locations})

    assert [
             %Coord.Location{
               lat: 52.366037,
               long: -8.179118,
               name: "Someone Else",
               user_id: 16
             }
           ] == parsed_locations |> Enum.to_list()
  end

  test "exclude records that have invalid user_id" do
    locations = [
      '{"latitude": "52.366037", "user_id": "16", "name": "Someone", "longitude": "-8.179118"}',
      '{"latitude": "52.366037", "user_id": 16, "name": "Someone Else", "longitude": "-8.179118"}'
    ]

    {:ok, parsed_locations} = Coord.Location.Parser.parse({:ok, locations})

    assert [
             %Coord.Location{
               lat: 52.366037,
               long: -8.179118,
               name: "Someone Else",
               user_id: 16
             }
           ] == parsed_locations |> Enum.to_list()
  end

  test "exclude records that have invalid name" do
    locations = [
      '{"latitude": "52.366037", "user_id": 16, "name": 123, "longitude": "-8.179118"}',
      '{"latitude": "52.366037", "user_id": 16, "name": "Someone Else", "longitude": "-8.179118"}'
    ]

    {:ok, parsed_locations} = Coord.Location.Parser.parse({:ok, locations})

    assert [
             %Coord.Location{
               lat: 52.366037,
               long: -8.179118,
               name: "Someone Else",
               user_id: 16
             }
           ] == parsed_locations |> Enum.to_list()
  end

  test "exclude records that have missing user_id" do
    locations = [
      '{"latitude": "52.366037", "name": "test123", "longitude": "-8.179118"}',
      '{"latitude": "52.366037", "user_id": 16, "name": "Someone Else", "longitude": "-8.179118"}'
    ]

    {:ok, parsed_locations} = Coord.Location.Parser.parse({:ok, locations})

    assert [
             %Coord.Location{
               lat: 52.366037,
               long: -8.179118,
               name: "Someone Else",
               user_id: 16
             }
           ] == parsed_locations |> Enum.to_list()
  end

  test "exclude records that have missing name" do
    locations = [
      '{"latitude": "52.366037", "user_id": 16, "longitude": "-8.179118"}',
      '{"latitude": "52.366037", "user_id": 16, "name": "Someone Else", "longitude": "-8.179118"}'
    ]

    {:ok, parsed_locations} = Coord.Location.Parser.parse({:ok, locations})

    assert [
             %Coord.Location{
               lat: 52.366037,
               long: -8.179118,
               name: "Someone Else",
               user_id: 16
             }
           ] == parsed_locations |> Enum.to_list()
  end
end
