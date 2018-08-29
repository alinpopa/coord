# Coord

Very basic app that parses customer records file, and lists on the stdout a list of
customers that are within 100km from Dublin.

## Requirements

- `mix` && `elixir >= 1.7`

## Installation

- Go to the project folder
- make sure you "import" the customer records file within the `priv/` folder.
- for the time being, the application has the file location, the dublin location, and also the max distance, hardcoded, for simplicity, but they're easy to change from within the `Coord` module.

## Tests

- `mix deps.get && mix test`

## Run

- `mix deps.get && mix run -e "Coord.main()"`

