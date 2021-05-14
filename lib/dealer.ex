defmodule Dealer do
  alias Dealer.Reviews

  @doc """
  Get's reviews from dealerrater.com
  Parses reviews into %Review{} struct
  Calculates the score for each review
  Prints the scores to console

  Returns [:ok]

  ## Examples

      iex> Dealer.get_reviews()
      :ok

  """
  @spec get_reviews :: :ok
  def get_reviews() do
    IO.puts("Fetching Reviews...")
    Reviews.get_reviews()
    |> Reviews.parse_reviews
    |> Reviews.calculate_scores
    |> Reviews.print_to_console
  end
end
