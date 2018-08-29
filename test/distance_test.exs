defmodule Coord.Distance.Test do
  use ExUnit.Case
  doctest Coord

  test "return the error when recieving an error" do
    assert {:error, :something} ==
             Coord.Distance.calculate_distance({:error, :something}, %Coord.Location{})

    assert {:error, :something} == Coord.Distance.as_displayable({:error, :something})
  end

  test "should return 0 km between locations pointing to the same coordinates" do
    loc1 = %Coord.Location{
      lat: 52.986375,
      long: -6.043701,
      name: "test1",
      user_id: 10
    }

    loc2 = %Coord.Location{
      lat: 52.986375,
      long: -6.043701,
      name: "test2",
      user_id: 11
    }

    loc3 = %Coord.Location{
      lat: 52.986375,
      long: -6.043701,
      name: "test1",
      user_id: 10
    }

    {:ok, stream} = Coord.Distance.calculate_distance({:ok, [loc1, loc2]}, loc3)
    assert [{0.0, loc1}, {0.0, loc2}] == stream |> Enum.to_list()
  end

  test "should return the distance that is more than 1000 km distance between Lesotho, Oulu, Manila, and Dublin" do
    lesotho = %Coord.Location{
      lat: -29.540841,
      long: 28.132277,
      user_id: 101,
      name: "Lesotho Office"
    }

    oulu = %Coord.Location{
      lat: 65.045458,
      long: 25.466855,
      user_id: 102,
      name: "Oulu Office"
    }

    manila = %Coord.Location{
      lat: 14.599570,
      long: 120.982822,
      user_id: 103,
      name: "Manila Office"
    }

    dublin = %Coord.Location{
      lat: 53.339428,
      long: -6.257664,
      user_id: 104,
      name: "Dublin"
    }

    {:ok, stream} = Coord.Distance.calculate_distance({:ok, [lesotho, oulu, manila]}, dublin)

    [{distance_lesotho, _lesotho}, {distance_oulu, _oulu}, {distance_manila, _manila}] =
      stream |> Enum.to_list()

    assert distance_lesotho != nil && distance_lesotho > 1000
    assert distance_oulu != nil && distance_oulu > 1000
    assert distance_manila != nil && distance_manila > 1000
  end

  test "should return the distance that is less than 100 km distance between Bray and Dublin" do
    bray = %Coord.Location{
      lat: 53.200771,
      long: -6.110996,
      user_id: 103,
      name: "Bray Office"
    }

    dublin = %Coord.Location{
      lat: 53.339428,
      long: -6.257664,
      user_id: 104,
      name: "Dublin"
    }

    {:ok, stream} = Coord.Distance.calculate_distance({:ok, [bray]}, dublin)

    [{distance_bray, _bray}] = stream |> Enum.to_list()

    assert distance_bray != nil && distance_bray < 100
  end

  test "should filter out locations that are further than 100 km from Dublin" do
    manila = %Coord.Location{
      lat: 14.599570,
      long: 120.982822,
      user_id: 103,
      name: "Manila Office"
    }

    bray = %Coord.Location{
      lat: 53.200771,
      long: -6.110996,
      user_id: 103,
      name: "Bray Office"
    }

    {:ok, stream} = Coord.Distance.filter_less_than({:ok, [{10950, manila}, {20, bray}]}, 100)
    [{distance_bray, _bray}] = stream |> Enum.to_list()

    assert distance_bray == 20
  end
end
