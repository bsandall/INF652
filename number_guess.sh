#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\nEnter your Name:"
read USER

DB_USERNAME=$($PSQL "SELECT username FROM players WHERE username='$USER'")
DB_ID=$($PSQL "SELECT user_id FROM players WHERE username='$USER'")


if [[ -z $DB_USERNAME ]]
  then
    echo -e "\nWelcome, $USER! It looks like this is your first time here.\n"
    INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO players(username) VALUES ('$USER')")
    
  else
    
    GAMES_PLAYED=$($PSQL "SELECT COUNT(game_id) FROM games LEFT JOIN players USING(user_id) WHERE username='$USER'")
    BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games LEFT JOIN players USING(user_id) WHERE username='$USER'")

    echo Welcome back, $USER\! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
fi

RANDOM_NUMBER=$(( RANDOM % 1000 + 1 ))

GUESSES=0

echo "Guess the secret number between 1 and 1000:"
read GUESS

until [[ $GUESS == $RANDOM_NUMBER ]]
do
  
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo -e "\nThat is not an integer, guess again:"
      read GUESS
      ((GUESSES++))
    

    else
      if [[ $GUESS < $RANDOM_NUMBER ]]
        then
          echo "It's higher than that, guess again:"
          read GUESS
          ((GUESSES++))
        else 
          echo "It's lower than that, guess again:"
          read GUESS
          ((GUESSES++))
      fi  
  fi

done

((GUESSES++))

DB_ID=$($PSQL "SELECT user_id FROM players WHERE username='$USER'")

RESULT=$($PSQL "INSERT INTO games(user_id, secret_number, number_of_guesses) VALUES ($DB_ID, $RANDOM_NUMBER, $GUESSES)")

echo You guessed it in $GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job\!