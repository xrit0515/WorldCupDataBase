#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOAL OPPONENT_GOAL
do
  if [[ $WINNER != "winner" ]]
  then
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")

    if [[ -z $WINNER_TEAM_ID ]]
    then
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi

    if [[ $INSERT_WINNER == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $WINNER
    fi
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")

    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi

    if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $OPPONENT
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOAL OPPONENT_GOAL
do
  if [[ $WINNER != "winner" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    INSERT_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOAL','$OPPONENT_GOAL')")
    if [[ $INSERT_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into games
    fi
  fi
done