# dealer

dealer is a tool used to identify positive reviews from the `dealerrater.com` website. The scoring rules used to determine the most positive reviews are outlined below.

## Installation

Clone the `dealer` repository

*Ensure Elixir is installed on your machine

*If on macOS/Linux Rust is also required for installation

[Rust](https://www.rust-lang.org/tools/install)

[Elixir](https://elixir-lang.org/install.html)

## Usage

# To run console application

- Open terminal/console and navigate to the directory where `dealer` is cloned
- Run `mix.deps get` to install dependencies
- Run the following commands

``` bash
iex -S mix 
Dealer.get_reviews
```
In console/terminal you will see the 3 most severely positive reviews listed along with the score they were given.

To exit press `ctrl + c` and then `a` then `enter`

# Run tests

Enter `mix test` into console

Test Results panel will appear be printed into the console
```

## Scoring
*Note: Ratings on `dealerrater.com` are on a scale 1-50 and are represented visually to users on a x/5 scale.*

- Rating - The score for rating is calculated by dividing the 1-50 rating by 5. `i.e. 50/5 would be 10 points`
- `!`'s are awarded 1 point each up to 3 maximum points.
- Every 100 characters in the body of the review is worth 1 point each for a maximum of 10 points.
- The appsettings.json file contains an array of both `positiveWords` and `negativeWords`. Each `positiveWord` = +2 points. Each `negativeWord` = -2 points.

## License
[MIT](https://choosealicense.com/licenses/mit/)
