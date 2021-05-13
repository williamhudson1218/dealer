defmodule Dealer do
  import Meeseeks.CSS
  alias Dealer.Reviews
  alias Dealer.Scores

  def get() do
    IO.puts("Fetching Reviews...")
    get_reviews()
    |> Reviews.parse_reviews
    #|> Scores.calculate_scores
    #|> print_reviews_to_console
  end

  def get_reviews do
    reviews =
     Enum.reduce 1..5, %{}, fn x, acc ->
      Map.put(acc, x, get_review_html_page())
     end
  end

  def get_review_html_page() do
    case HTTPoison.get(Application.get_env(:dealer, :url)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        reviews =
          body
          |> Meeseeks.parse
          |> Meeseeks.all(css(".review-entry"))
        end
  end

  def print_reviews_to_console(reviews) do
    reviews
    |> Enum.sort_by(&(&1.score), :asc)
    |> Enum.drop(Enum.count(reviews) - 3)
    |> Enum.sort_by(&(&1.score), :desc)
    |> Enum.each fn review ->
      IO.puts("Username: #{review.username}")
      IO.puts("Date: #{review.date}")
      IO.puts("Rating: #{review.rating}")
      IO.puts("Title: #{review.title}")
      IO.puts("Body: #{review.body}")
      IO.puts("Score: #{review.score}")
      IO.puts("+++++++++++++++++++++++++++++++++++++++++++++++++++++")
    end
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
