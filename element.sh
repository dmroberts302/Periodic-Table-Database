#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
MAGIC_QUERY="SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING (atomic_number)"
# have a bool variable that tracks if argument matches the three fields
FOUND="false"
INFORMATION=""
ARGUMENT=$1
ATOMIC_NUMBER=""
SYMBOL=""
NAME=""
TYPE=""
ATOMIC_MASS=""
MELTING_POINT_CELSIUS=""
BOILING_POINT_CELSIUS=""


function MAIN_MENU(){
	# retieve argument test if it matches a atomic_number, symbol, name and a test will happen if bool is false
	# if in a test it matches set the bool to true print information

	if [[ $ARGUMENT =~ ^[0-9]+$ && $FOUND == "false" ]]
	then
		ATOMIC_NUMBER_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING (atomic_number) WHERE atomic_number=$ARGUMENT;")

		if [[ ! -z $ATOMIC_NUMBER_RESULT ]]
		then
			FOUND="true"
			INFORMATION=$ATOMIC_NUMBER_RESULT
		fi

	fi

	if [[ $FOUND == "false" ]]
	then
		SYMBOL_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING (atomic_number) WHERE symbol='$ARGUMENT';")

		if [[ ! -z $SYMBOL_RESULT ]]
		then
			FOUND="true"
			INFORMATION=$SYMBOL_RESULT
		fi

	fi

	if [[ $FOUND == "false" ]]
	then
		NAME_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING (atomic_number) WHERE name='$ARGUMENT';")

		if [[ ! -z $NAME_RESULT ]]
		then
			FOUND="true"
			INFORMATION=$NAME_RESULT
		fi

	fi

	
	
	
	# at the end if bool is still false print error message
	if [[ $FOUND == "true" ]]
	then
		IFS='|' read -ra ARRAY <<< "$INFORMATION"
		echo "The element with atomic number ${ARRAY[0]} is ${ARRAY[2]} (${ARRAY[1]}). It's a ${ARRAY[3]}, with a mass of ${ARRAY[4]} amu. ${ARRAY[2]} has a melting point of ${ARRAY[5]} celsius and a boiling point of ${ARRAY[6]} celsius."
	else
		echo "I could not find that element in the database."
	fi
	
}

if [[ -z $1 ]]
then
	echo -e "Please provide an element as an argument."
else
	MAIN_MENU
fi
