#!/bin/bash

if [[ -z $1 ]]
  then
    echo Please provide an element as an argument.
    exit
fi

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 =~ ^[0-9]+$ ]]
  then
    TRY_ATOMIC=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1;")
    if [[ -z $TRY_ATOMIC ]]
      then
        :
    else
      GET_DATA=$($PSQL "SELECT * FROM properties FULL JOIN elements using(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1;")
    fi
fi

if [[ ! $1 =~ ^[0-9]+$ && $1 -le 2 ]]
  then
    TRY_SYMBOL=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1';")
    if [[ -z $TRY_SYMBOL ]]
    then
      :
    else
      GET_DATA=$($PSQL "SELECT * FROM properties FULL JOIN elements using(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $TRY_SYMBOL;")
    fi
fi

if [[ ! $1 =~ ^[0-9]+$ && $1 > 2 ]]
  then
    TRY_NAME=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1';")
    if [[ -z $TRY_NAME ]]
    then
      :
    else
      GET_DATA=$($PSQL "SELECT * FROM properties FULL JOIN elements using(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $TRY_NAME;")
    fi
fi


if [ -z $GET_DATA ] 2> errors.txt
  then
    echo I could not find that element in the database.
else
  echo $GET_DATA | while read TYPE_ID BAR ATOMIC_NUMBER BAR MASS BAR MELTING BAR BOILING BAR SYMBOL BAR NAME BAR TYPE 
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi


    










