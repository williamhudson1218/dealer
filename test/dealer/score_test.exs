defmodule DealerTest.ScoreTest do
  use ExUnit.Case
  alias Dealer.Reviews.Review
  alias Dealer.Reviews.Scores


  defp positive_review() do
    %Review{body: "This is the 2nd vehicle I have purchased from McKaig Chevrolet Buick, and I wouldn’t purchase a vehicle anywhere else!  Their service department has taken care of me exceptionally several times, especially Patrick Evans!  He is so friendly and so knowledgeable.  I had a small wreck in my 2018 Chevy Traverse that I purchased from McKaig, and Patrick recommended Adrian Cortes to sell me a new vehicle on the spot instead of fixing my Traverse and I took the bait willingly!  LOL !!!  I knew that Adrian would put me in a reliable vehicle that would fit my needs, including 4-wheel drive, having to fit a 6’4” man in the front passenger seat and 2 big car seats in the back, not to mention TONS of room in the back for all my junk and groceries.  Needless to say, Adrian  fixed me up in a 2018 4x4 Jeep Grand Cherokee that is loaded to the max and is WAY sportier and more luxurious than what I had before.  I told Adrian what I wanted in a vehicle and he took me right to it, where I immediately fell in love with the All-Black look, even the 20” wheels.  I feel like a Cool Mom now thanks to Adrian!  I will DEFINITELY purchase my next vehicle from him!  I couldn’t be happier!", rating: 50}
  end

  defp negative_review() do
    %Review{body: "The sales adds are very misleading. I made the mistake again to trust this dealership to lead me to believe that I would get the help I needed to get into something nicer or newer as they put it. They get your hopes up and then shatter them by trying to out you in what they want to.", rating: 10}
  end


  test "Positive Review Score Is Equal" do
    review = Scores.calculate_score(positive_review())
    assert review.score == 27
  end

  test "Negative Review Score Is Equal" do
    review = Scores.calculate_score(negative_review())
    assert review.score == 3
  end
end
