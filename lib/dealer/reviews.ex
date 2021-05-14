defmodule Dealer.Reviews do
  @moduledoc """
  The Dealer.Reviews module, responsible for scraping reviews and parsing them to the
  Review struct so we can sort and display them to the user
  """
  import Meeseeks.CSS
  alias Dealer.Reviews.Review
  alias Dealer.Reviews.Scores

  @doc """
  get's the first 5 pages of reviews from :url from the config file


  Returns [reviews...]

  ## Examples

      iex> Dealer.Reviews.get_reviews()

  """
  @spec get_reviews :: list
  def get_reviews do
    reviews =
      Enum.map(1..5, fn x ->
        get_review_html_page(x)
      end)

    List.flatten(reviews)
  end

  defp get_review_html_page(index) do
    url = Application.get_env(:dealer, :url)

    case HTTPoison.get(String.replace(url, "pagex", "page#{index}")) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        _reviews =
          body
          |> Meeseeks.parse()
          |> Meeseeks.all(css(".review-entry"))
    end
  end

  @doc """
  Takes in a list of html strings each representing a review from the website

  Returns [%Review{}...]
  """
  @spec parse_reviews(any) :: list
  def parse_reviews(review_list) do
    for review <- review_list do
      parse_review(review)
    end
  end

  @doc """
  Takes in a single html string and parses to a %Review{} struct

  Returns [%Review{}...]
  """
  @spec parse_review(String.t()) :: Review.t()
  def parse_review(review_html) do
    review = %Review{html: review_html}

    review
    |> parse_username
    |> parse_title
    |> parse_body
    |> parse_rating
    |> parse_date
  end

  @doc """
  Iterates over the list of %Review{}'s and calculates the score for each

  Returns `:ok`.

  ## Examples

      iex> Dealer.Reviews.calculate_scores([%Review...])
      :ok

  """
  @spec calculate_scores(any) :: list
  def calculate_scores(reviews) do
    Scores.calculate_scores(reviews)
  end

  @doc """
  Takes in a list of %Review{}'s

  Sorts them by their score

  Removes all but the best 3 scores

  Prints the best 3 scores to the console

  Returns `:ok`.

  ## Examples

      iex> Dealer.Reviews.print_to_console([%Review...])
      :ok

  """
  @spec print_to_console(any) :: :ok
  def print_to_console(reviews) do
    Enum.sort_by(reviews, & &1.score, &<=/2)
    |> Enum.drop(Enum.count(reviews) - 3)
    |> Enum.sort_by(& &1.score, &>=/2)
    |> Enum.each(fn review ->
      IO.puts("""
      Username: #{review.username}
      Date: #{review.date}
      Rating: #{Kernel.round(review.rating / 10)}/5
      Title: #{review.title}
      Body: #{review.body}
      Score: #{review.score}
      """)
    end)
  end

  defp parse_username(%Review{html: html} = review) do
    username =
      html
      |> Meeseeks.one(css(".font-18"))
      |> Meeseeks.text()
      |> String.trim_leading("- ")

    %Review{review | username: username}
  end

  defp parse_title(%Review{html: html} = review) do
    title =
      html
      |> Meeseeks.one(css(".no-format"))
      |> Meeseeks.text()

    %Review{review | title: title}
  end

  defp parse_body(%Review{html: html} = review) do
    body =
      html
      |> Meeseeks.one(css(".review-content"))
      |> Meeseeks.text()

    %Review{review | body: body}
  end

  defp parse_rating(%Review{html: html} = review) do
    ratingHtml =
      html
      |> Meeseeks.one(css(".rating-static"))
      |> Meeseeks.html()

    {index, _count} = :binary.match(ratingHtml, "pull-right")
    {rating, _} = Integer.parse(String.slice(ratingHtml, index - 3, 2))
    %Review{review | rating: rating}
  end

  defp parse_date(%Review{html: html} = review) do
    date =
      html
      |> Meeseeks.one(css(".review-date"))
      |> Meeseeks.one(css(".pad-none"))
      |> Meeseeks.text()

    %Review{review | date: date}
  end
end
