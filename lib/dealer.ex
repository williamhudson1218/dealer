defmodule Dealer do
  import Meeseeks.CSS
  alias Dealer.Reviews
  alias Dealer.Scores

  def get() do
    IO.puts("Fetching Reviews...")
    Reviews.get_reviews()
    |> Reviews.parse_reviews
    |> Scores.calculate_scores
    |> print_reviews_to_console
  end

  def print_reviews_to_console(reviews) do
    reviews
    |> Enum.sort_by(&(&1.score), :asc)
    |> Enum.drop(Enum.count(reviews) - 3)
    |> Enum.sort_by(&(&1.score), :desc)
    |> Enum.each fn review ->
      IO.puts("Username: #{review.username}")
      IO.puts("Date: #{review.date}")
      IO.puts("Rating: #{Kernel.round(review.rating / 10)}/5")
      IO.puts("Title: #{review.title}")
      IO.puts("Body: #{review.body}")
      IO.puts("Score: #{review.score}")
      IO.puts("+++++++++++++++++++++++++++++++++++++++++++++++++++++")
    end
  end
end
