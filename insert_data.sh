#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER == 'winner' || $OPPONENT == 'opponent' ]]
  then
    continue
  else
    
    WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    
    if [[ -z $WINNER_NAME ]]
    then
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo $WINNER
    else
      OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    
      if [[ -z $OPPONENT_NAME ]]
      then
        INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        echo $OPPONENT_NAME
      else
        continue
      fi
    fi
  fi
done


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR == 'year' || $ROUND == 'round' || $WINNER == 'winner' || $OPPONENT == 'opponent' || $WINNER_GOALS == 'winner_goals' || $OPPONENT_GOALS == 'opponent_goals' ]]
  then
    continue
  else  
    INSERT_YEAR=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', (SELECT team_id FROM teams WHERE name='$WINNER'), (SELECT team_id FROM teams WHERE name='$OPPONENT'), $WINNER_GOALS, $OPPONENT_GOALS)")
    echo GAME ADDED
  fi
done
