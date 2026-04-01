#! /bin/bash
COUNT=0

while [ $COUNT -eq 0 ]; do
echo -e "Please choose a service from the list below:"
echo "$(psql --username=freecodecamp --dbname=salon --pset="footer=off" -t -c "SELECT service_id || ') ' || name AS services FROM services")"
read SERVICE_ID_SELECTED
if [[ $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    COUNT="$(psql --username=freecodecamp --dbname=salon --pset="footer=off" -t -c "SELECT COUNT(*) FROM services WHERE service_id = $SERVICE_ID_SELECTED")"
  fi
done

echo -e "Please enter your phone number:"
read CUSTOMER_PHONE

CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon --pset="footer=off" -t -c  "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [ -z "$CUSTOMER_ID" ]; then
  echo -e "Please enter your name:"
  read CUSTOMER_NAME
  psql --username=freecodecamp --dbname=salon --pset="footer=off" -t -c  "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')"
fi

echo -e "Please enter a time for your appointment:"
read SERVICE_TIME

CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon --pset="footer=off" -t -c  "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

psql --username=freecodecamp --dbname=salon --pset="footer=off" -t -c  "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')"
SERVICE_NAME=$(psql --username=freecodecamp --dbname=salon --pset="footer=off" -t -c  "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
CUSTOMER_NAME=$(psql --username=freecodecamp --dbname=salon --pset="footer=off" -t -c  "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")


echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."