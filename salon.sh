#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~ Salón de belleza Beauty Palace ~~~"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "Bienvenido a Beauty Palace. ¿En qué puedo ayudarte?"
  SERVICIOS_DISPONIBLES=$($PSQL "SELECT service_id, name from services order by service_id")
  echo "$SERVICIOS_DISPONIBLES" | while read SERVICE_ID BAR NOMBRE
  do
    echo "$SERVICE_ID) $NOMBRE"
  done

  read SERVICE_ID_SELECTED

  NOMBRE_SERVICIO=$($PSQL "SELECT name from services where service_id=$SERVICE_ID_SELECTED")
  if [[ -z $NOMBRE_SERVICIO ]]
  then
    MAIN_MENU "Por favor, ingrese una opción válida"
  else   
    echo -e "\n¿Cuál es tu número de teléfono?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name from customers where phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\n¿Cual es tu nombre?"
      read CUSTOMER_NAME
    INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")  
    fi 

    CUSTOMER_ID=$($PSQL "SELECT customer_id from customers where phone='$CUSTOMER_PHONE'")
    echo -e "\n¿En qué horario quieres tu cita? $CUSTOMER_NAME"
    read SERVICE_TIME
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

    echo -e "\nI have put you down for a $NOMBRE_SERVICIO at $SERVICE_TIME, $CUSTOMER_NAME."
  fi  
}

MAIN_MENU
