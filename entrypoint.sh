#!/bin/sh
# wait for MSSQL server to start
export STATUS=1
i=0
max_time=300

while [ $STATUS -ne 0 ] && [ $i -lt $max_time ]; do
  i=$((i + 1))
  echo "Trying to connect to $MSSQL_HOST (#$i)"
  /opt/mssql-tools/bin/sqlcmd -t 1 -S "$MSSQL_HOST" -U "$MSSQL_USER" -P "$MSSQL_PASSWORD" -Q "select 1" >>/dev/null
  STATUS=$?
  sleep 1
done

if [ $STATUS -ne 0 ]; then
  echo "Error: MSSQL SERVER took more than $max_time seconds to start up."
  exit 1
fi

echo "MS SQL connected in approx. $i seconds."

python manage.py migrate

exec "$@"
