#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ -z "$1" ]; then
  echo -e "Please provide an element as an argument."
  exit 0
fi

case $1 in
  *[!0-9]*)  # if $1 contains non-digit characters, it's a symbol or name
    ELEMENT_INFO=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius 
    FROM elements 
    JOIN properties ON elements.atomic_number = properties.atomic_number 
    JOIN types ON properties.type_id = types.type_id 
    WHERE elements.symbol = '$1' OR elements.name = '$1'")
    ;;
  *)  # otherwise, it's an atomic number
    ELEMENT_INFO=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius 
    FROM elements 
    JOIN properties ON elements.atomic_number = properties.atomic_number 
    JOIN types ON properties.type_id = types.type_id 
    WHERE elements.atomic_number = $1")
    ;;
esac

if [ -z "$ELEMENT_INFO" ]; then
  echo -e "I could not find that element in the database."
else
  IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $ELEMENT_INFO
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi

