defmodule Dealer.Reviews do
  import Meeseeks.CSS
  alias Dealer.Review

  def get_reviews do
    reviews =
     Enum.map 1..5, fn x ->
      get_review_html_page(x)
     end
     List.flatten(reviews)
  end

  def get_review_html_page(index) do
    url = Application.get_env(:dealer, :url)
    case HTTPoison.get(String.replace(url, "pagex", "page#{index}")) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        _reviews =
          body
          |> Meeseeks.parse
          |> Meeseeks.all(css(".review-entry"))
        end
  end

  def parse_reviews(review_list) do
      for review <- review_list do
        parse_review(review)
    end
  end

  def parse_review(review_html) do
    review = %Review{html: review_html}
    review
    |> parse_username
    |> parse_title
    |> parse_body
    |> parse_rating
    |> parse_date
  end

  def parse_username(%Review{html: html} = review) do
    username =
      html
      |> Meeseeks.one(css(".font-18"))
      |> Meeseeks.text
      |> String.trim_leading("- ")
      %Review{review | username: username}
  end

  def parse_title(%Review{html: html} = review) do
    title =
      html
      |> Meeseeks.one(css(".no-format"))
      |> Meeseeks.text
      %Review{review | title: title}
  end

  def parse_body (%Review{html: html} = review) do
    body =
      html
      |> Meeseeks.one(css(".review-content"))
      |> Meeseeks.text
      %Review{review | body: body}
  end

  def parse_rating (%Review{html: html} = review) do
    ratingHtml =
      html
      |> Meeseeks.one(css(".rating-static"))
      |> Meeseeks.html
      {index, _count} = :binary.match(ratingHtml, "pull-right")
      {rating, _} = Integer.parse(String.slice(ratingHtml, index - 3, 2))
      %Review{review | rating: rating}
  end

  def parse_date (%Review{html: html} = review) do
    date =
      html
      |> Meeseeks.one(css(".review-date"))
      |> Meeseeks.one(css(".pad-none"))
      |> Meeseeks.text
      %Review{review | date: date}
  end
end
