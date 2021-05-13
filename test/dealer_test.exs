defmodule DealerTest do
  use ExUnit.Case
  doctest Dealer

  test "url is not null" do
    assert Application.fetch_env!(:dealer, :url) != nil
  end
end
