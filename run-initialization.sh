#!/bin/sh
# wait for MSSQL server to start
sleep 6s

export STATUS=1
i=0
max_time=300

while [ $STATUS -ne 0 ] && [ $i -lt $max_time ]; do
  i=$((i + 1))
  echo "Trying to connect to localhost (#$i) using user: sa."
  /opt/mssql-tools/bin/sqlcmd -t 1 -S localhost -U sa -P "$SA_PASSWORD" -Q "select 1" >>/dev/null
  STATUS=$?
  sleep 1
done

if [ $STATUS -ne 0 ]; then
  echo "Error: MSSQL SERVER took more than $max_time seconds to start up."
  exit 1
fi

echo "MSSQL Server is up. $i seconds."

echo "Trying to create $MSSQL_DB database using sa user."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d master -Q "CREATE DATABASE [$MSSQL_DB]"

echo "Trying to create login for: $MSSQL_USER."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d "$MSSQL_DB" \
  -Q "CREATE LOGIN [$MSSQL_USER] WITH PASSWORD = '$MSSQL_PASSWORD', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF"

echo "Trying to create user for: $MSSQL_USER."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d "$MSSQL_DB" \
  -Q "CREATE USER [$MSSQL_USER] FOR LOGIN [$MSSQL_USER]"

echo "Trying to grant permissions to: $MSSQL_USER."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d "$MSSQL_DB" \
  -Q "EXEC sp_addrolemember 'db_owner', $MSSQL_USER "


echo "MSSQL Server is ready..."

exec "$@"
