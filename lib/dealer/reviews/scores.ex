defmodule Dealer.Reviews.Scores do
  @moduledoc """
  This module is to handle calculating a score from a %Review{} struct
  """
  alias Dealer.Reviews.Review

  @spec calculate_scores(any) :: list
  def calculate_scores(reviews) do
    for review <- reviews do
      calculate_score(review)
    end
  end

  @doc """
  Calculates the score for a %Review{}

  The score is a representation of the positivity of the Review

  The higher the score the more positive the review

  Returns `%Review{}`.

  ## Examples

      iex> Dealer.Reviews.Scores.calculate_score(%Review{})

  """
  def calculate_score(%Review{} = review) do
    review
    |> score_rating
    |> score_positive_words
    |> score_negative_words
    |> score_exclamations
    |> score_length
  end

  defp score_rating(%Review{score: score} = review) do
    total = score + Kernel.trunc(review.rating / 5)
    %Review{review | score: total}
  end

  defp score_positive_words(%Review{score: score} = review) do
    total =
      Enum.reduce(get_positive_words(), 0, fn word, acc ->
        if test_word(review.body, word), do: acc + 2, else: acc
      end)

    %Review{review | score: score + total}
  end

  defp test_word(body, word) do
    String.contains?(String.downcase(body), word)
  end

  defp get_positive_words() do
    {:ok, body} = File.read("words.json")
    {:ok, json} = Poison.decode(body)
    json["positiveWords"]
  end

  defp score_negative_words(%Review{score: score} = review) do
    total =
      Enum.reduce(get_negative_words(), 0, fn word, acc ->
        if test_word(review.body, word), do: acc + 2, else: acc
      end)

    %Review{review | score: score - total}
  end

  defp get_negative_words() do
    {:ok, body} = File.read("words.json")
    {:ok, json} = Poison.decode(body)
    json["negativeWords"]
  end

  defp score_exclamations(%Review{score: score} = review) do
    exclamationCount = review.body |> String.graphemes() |> Enum.count(&(&1 == "!"))
    total = score + if exclamationCount >= 3, do: 3, else: exclamationCount
    %Review{review | score: total}
  end

  defp score_length(%Review{score: score} = review) do
    total =
      score +
        if String.length(review.body) / 100 >= 10,
          do: 10,
          else: Kernel.round(String.length(review.body) / 100)

    %Review{review | score: total}
  end
end
