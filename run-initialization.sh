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

echo "MSSQL configurations started..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d master -i setup.sql
echo "MSSQL Server is ready..."

exec "$@"
