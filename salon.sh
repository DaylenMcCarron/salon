#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
MAIN_MENU () {
#welcome
echo -e "\n~~~~~ MY SALON ~~~~~\n"

  #Ask what Service
  SERVICES=$($PSQL "SELECT * FROM services")
  echo -e "\nWelcome to My Salon, how can i help you?"
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE 
  do
  echo "$SERVICE_ID) $SERVICE"
  done
  
  read SERVICE_ID_SELECTED
  SEL_SER_ID=$($PSQL "SELECT service_id FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  if [[ -z $SEL_SER_ID ]]
  then
    MAIN_MENU "Selected service is not in the list, Try Again!"
  else
#Ask for Phone Number
    echo -e "\nEnter your Mobile Number"
    read CUSTOMER_PHONE
    SEL_NUM_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    #if num not found
    if [[ -z $SEL_NUM_ID ]]
    then
      #ask for name
      echo -e "\nPlease enter your Name."
      read CUSTOMER_NAME

      #ask what time service
      echo -e "\nWhat time would you like us to service"
      read SERVICE_TIME

      #Save Name and Number
      INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      #create Appointment
      INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id,customer_id,time) VALUES($SERVICE_ID_SELECTED,$CUSTOMER_ID,'$SERVICE_TIME')")
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
      echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
      else 
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
      echo -e "\nWhat time would you like us to service"
      read SERVICE_TIME
      #create Appointment
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id,customer_id,time) VALUES($SERVICE_ID_SELECTED,$CUSTOMER_ID,'$SERVICE_TIME')")
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
      echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

    fi
  fi

}

MAIN_MENU
