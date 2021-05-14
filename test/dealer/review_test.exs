defmodule DealerTest.ReviewTest do
  alias Dealer.Reviews
  use ExUnit.Case

  test "Parse Review" do
    {:ok, html } = File.read("parse_review_not_nil.html")
    review = Reviews.parse_review(html)
    assert review.html != nil
    assert review.body != nil
    assert review.title != nil
    assert review.rating != nil
    assert review.username != nil
    assert review.date != nil
  end
end
