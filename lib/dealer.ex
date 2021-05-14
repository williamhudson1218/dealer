defmodule Dealer do
  alias Dealer.Reviews

  def get_reviews() do
    IO.puts("Fetching Reviews...")
    Reviews.get_reviews()
    |> Reviews.parse_reviews
    |> Reviews.calculate_scores
    |> Reviews.print_to_console
  end
end
