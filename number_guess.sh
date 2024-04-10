#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Generate a random number between 1 and 1000
secret_number=$(( $RANDOM % 1000 + 1 ))

# Prompt the user for a username
echo "Enter your username:"
read username

# Check if the username has been used before
if [[ -n $($PSQL "SELECT username FROM users WHERE username = '$username'") ]]; then
  # Get the user's information from the database
  user_id=$($PSQL "SELECT id FROM users WHERE username = '$username'")
  games_played=$($PSQL "SELECT games_played FROM games WHERE user_id = '$user_id'")
  best_game=$($PSQL "SELECT best_game FROM games WHERE user_id = '$user_id'")
  echo -e "\nWelcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
else
  echo -e "\nWelcome, $username! It looks like this is your first time here."
  # Insert the username into the database
  $PSQL "INSERT INTO users (username) VALUES ('$username')"
  user_id=$($PSQL "SELECT id FROM users WHERE username = '$username'")
  $PSQL "INSERT INTO games (user_id) VALUES ('$user_id')"
  best_game=$($PSQL "SELECT best_game FROM games WHERE user_id = '$user_id'")
fi

# Prompt the user to guess the secret number
echo "Guess the secret number between 1 and 1000:"
read guess

# Initialize the number of guesses
number_of_guesses=1

# Loop until the user guesses the secret number
while [[ $guess -ne $secret_number ]]; do
  # Check if the guess is an integer
  if [[ ! $guess =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    read guess
  fi
  # Check if the guess is higher or lower than the secret number
  if [[ $guess -gt $secret_number ]]; then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi
  # Increment the number of guesses
  number_of_guesses=$((number_of_guesses + 1))
  # Prompt the user to guess again
  read guess
done

# Update the games played in the database
$PSQL "UPDATE games SET games_played = games_played + 1 WHERE user_id = '$user_id'"

# Update the best game if necessary
if [[ $number_of_guesses -lt $best_game ]]; then
  $PSQL "UPDATE games SET best_game = $number_of_guesses WHERE user_id = '$user_id'"
fi

echo -e "\nYou guessed it in $number_of_guesses tries. The secret number was $secret_number. Nice job!"