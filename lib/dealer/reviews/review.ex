defmodule Dealer.Reviews.Review do
  @type t :: struct
  defstruct username: nil, title: nil, body: nil, rating: nil, date: nil, html: nil, score: 0
end
