#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Insert teams into the teams table
echo "Inserting unique teams into the teams table..."
while IFS=, read -r winner opponent
do
    echo "Inserting $winner..."
    $PSQL "INSERT INTO teams (name) VALUES ('$winner') ON CONFLICT DO NOTHING;"
    echo "Inserting $opponent..."
    $PSQL "INSERT INTO teams (name) VALUES ('$opponent') ON CONFLICT DO NOTHING;"
done < <(cut -d ',' -f 3,4 games.csv | tail -n +2 | sort -u)
echo "Teams inserted!"

# Insert games into the games table
echo "Inserting games into the games table..."
while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
    echo "Inserting game $year, $round, $winner..."
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
    # echo $winner_id
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")
    # echo $opponent_id
    $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals);"
done < <(tail -n +2 games.csv)
echo "Games inserted!"
