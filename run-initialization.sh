# Wait to be sure that SQL Server came up
sleep 10s

# Run the setup script to create the DB and the schema in the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d master -Q "CREATE DATABASE [$DB_NAME]"