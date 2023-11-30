# dealer

`dealer` is a tool used to identify positive reviews from the `dealerrater.com` website. The scoring rules used to determine the most positive reviews are outlined below.

## Installation

Clone the `dealer` repository

- Ensure Elixir is installed on your machine

- Dealer is dependent on [meeseeks](https://github.com/mischov/meeseeks), which is a library used for parsing html documents.

[Elixir](https://elixir-lang.org/install.html)

## Usage

# To run console application

- Open terminal/console and navigate to the `dealer` directory
- Run `mix.deps get` to install dependencies
- Run the following commands

```bash
iex -S mix
Dealer.get_reviews
```

In console/terminal you will see the 3 most positive reviews listed along with the score they were given.

To exit press `ctrl + c` and then `a` then `enter`

# Run tests

Run command `mix test`

Test Results will print to the console

# Scoring

_Note: Ratings on `dealerrater.com` are on a scale 1-50 and are represented visually to users on a x/5 scale._

- Rating - The score for rating is calculated by dividing the 1-50 rating by 5. `i.e. 50/5 would be 10 points`
- `!`'s are awarded 1 point each up to 3 maximum points.
- Every 100 characters in the body of the review is worth 1 point each for a maximum of 10 points.
- The `words.json` file contains an array of both `positiveWords` and `negativeWords`. Each `positiveWord` = +2 points. Each `negativeWord` = -2 points.

## License

[MIT](https://choosealicense.com/licenses/mit/)
