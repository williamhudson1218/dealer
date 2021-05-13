defmodule Dealer.Reviews do
  import Meeseeks.CSS
  alias Dealer.Review

  def parse_reviews(html_page_list) do
    IO.puts("+++++++++++++++")
    Enum.each html_page_list, fn {key, review_list} ->
      IO.inspect(review_list)
      for review <- review_list do
        #parse_review(review)
      end
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
    IO.inspect(html)
    username =
      html
      |> Meeseeks.one(css(".font-18"))
      |> Meeseeks.text
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
      {index, count} = :binary.match(ratingHtml, "pull-right")
      {rating, _} = Integer.parse(String.slice(ratingHtml, index - 3, 2))
      %Review{review | rating: rating}
  end

  def parse_date (%Review{html: html} = review) do
    date =
      html
      |> Meeseeks.one(css(".review-date"))
      |> Meeseeks.text
      %Review{review | date: date}
  end
end
