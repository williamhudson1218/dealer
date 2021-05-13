defmodule ReviewTest do
  alias Dealer.Reviews
  use ExUnit.Case

  test "Get Reviews" do
     reviews = Reviews.get_reviews
     assert Enum.count(reviews) == 50
  end

  test "Parse Review Html Not Nil" do
    {:ok, html } = File.read("parse_review_not_nil.html")
    review = Reviews.parse_review(html)
    assert review.html != nil
  end
end
