defmodule Dealer.Reviews do
  import Meeseeks.CSS

  def parse_reviews(review_list) do
    for review <- review_list do
      parse_review(review)
    end
  end

  def parse_review(review_html) do
    review = %Dealer.Review{html: review_html}
    review
    |> parse_username
    |> parse_title
    |> parse_body
    |> parse_rating
    |> parse_date
  end

  def parse_username(%Dealer.Review{html: html} = review) do
    username =
      html
      |> Meeseeks.one(css(".font-18"))
      |> Meeseeks.text
      %Dealer.Review{review | username: username}
  end

  def parse_title(%Dealer.Review{html: html} = review) do
    title =
      html
      |> Meeseeks.one(css(".no-format"))
      |> Meeseeks.text
      %Dealer.Review{review | title: title}
  end

  def parse_body (%Dealer.Review{html: html} = review) do
    body =
      html
      |> Meeseeks.one(css(".review-content"))
      |> Meeseeks.text
      %Dealer.Review{review | body: body}
  end

  def parse_rating (%Dealer.Review{html: html} = review) do
    ratingHtml =
      html
      |> Meeseeks.one(css(".rating-static"))
      |> Meeseeks.html
      IO.inspect(ratingHtml)
      {index, count} = :binary.match(ratingHtml, "pull-right")
      {rating, _} = Integer.parse(String.slice(ratingHtml, index - 3, 2))
      %Dealer.Review{review | rating: rating}
  end

  def parse_date (%Dealer.Review{html: html} = review) do
    date =
      html
      |> Meeseeks.one(css(".review-date"))
      |> Meeseeks.text
      %Dealer.Review{review | date: date}
  end
end
