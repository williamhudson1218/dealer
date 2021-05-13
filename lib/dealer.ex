defmodule Dealer do
  alias Dealer.Reviews
  alias Dealer.Scores

  def get() do
    IO.puts("Fetching Reviews...")
    reviews = get_reviews()
    |> Reviews.parse_reviews
    |> Scores.calculate_scores
    #|> print_reviews_to_console
  end

  def get_reviews do
    # for i <- 1..5 do
    case HTTPoison.get(Application.get_env(:dealer, :url)) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
      reviews =
        body
        |> Meeseeks.parse
        |> Meeseeks.all(css(".review-entry"))
    end
  end

  def print_reviews_to_console(reviews) do

  end

  def get_floki() do
    case HTTPoison.get(Application.get_env(:dealer, :url)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        reviews =
          body
          |> Floki.parse_document
          |> Floki.find(".review-content")
        {:ok, reviews}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end
end
