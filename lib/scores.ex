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
      |> score_positive_words
      |> score_negative_words
      |> score_exclamations
      |> score_length
  end

  def score_rating(%Review{score: score} = review) do
    total = score + Kernel.trunc(review.rating / 5)
    %Review{review | score: total}
  end

  def test_word(body, word) do
   String.contains?(String.downcase(body), word)
 end

  def score_positive_words(%Review{score: score} = review) do
    total =
    Enum.reduce get_positive_words, 0, fn word, acc ->
      if test_word(review.body, word), do: acc + 1, else: acc
    end

    %Review{review | score: score + total}
  end

  def get_positive_words() do
    {:ok, body } = File.read("words.json")
    {:ok, json } = Poison.decode(body)
    words = json["positiveWords"]
  end

  def score_negative_words(%Review{score: score} = review) do
    total =
      Enum.reduce get_negative_words, 0, fn word, acc ->
        if test_word(review.body, word), do: acc + 1, else: acc
      end

      %Review{review | score: score - total}
  end

  def get_negative_words() do
    {:ok, body } = File.read("words.json")
    {:ok, json } = Poison.decode(body)
    words = json["negativeWords"]
  end

  def score_exclamations(%Review{score: score} = review) do
    exclamationCount = (review.body |> String.graphemes() |> Enum.count(&(&1 == "!")))
    total = score + (if exclamationCount >= 3, do: 3, else: exclamationCount)
    %Review{review | score: total}
  end

  def score_length(%Review{score: score} = review) do
    total =
      score +
        if String.length(review.body) / 100 >= 10, do: 10, else: Kernel.round(String.length(review.body) / 100)

    %Review{review | score: total}
  end
end
