defmodule Dealer.Scores do
  alias Dealer.Review

  def calculate_scores(reviews) do
    for review <- reviews do
      calculate_score(review)
    end
  end

  def calculate_score(%Review{} = review) do
    new_review =
      review
      |> score_rating
      # |> score_positive_words
      # |> score_negative_words
      |> score_exclamations
      |> score_length
  end

  def score_rating(%Review{score: score} = review) do
    total = score + Kernel.trunc(review.rating / 5)
    %Review{review | score: total}
  end

  def score_positive_words(%Review{score: score} = review) do
    %Review{review | score: score}
  end

  def score_negative_words(%Review{score: score} = review) do
    %Review{review | score: score}
  end

  def score_exclamations(%Review{score: score} = review) do
    total = score + (review.body |> String.graphemes() |> Enum.count(&(&1 == "!")))
    %Review{review | score: total}
  end

  def score_length(%Review{score: score} = review) do
    total =
      score +
        if String.length(review.body) / 100 >= 10, do: 10, else: String.length(review.body) / 100

    %Review{review | score: total}
  end
end
