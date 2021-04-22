# MSSQL Docker image - Django Example

##### create .envs/.django env_file
``` 
SECRET_KEY="sdf;asjdfalskjdflasjkdf;alskjf;lxvcnv,mzxnvowrjoW@#$#@#@SDfsda"
DEBUG=1
ALLOWED_HOSTS=localhost,127.0.0.1,[::1]
```

##### create .envs/.mssql env_file

```
ACCEPT_EULA=Y
MSSQL_PID=Express
SA_PASSWORD="yourStrong(!)Password"

MSSQL_ENGINE=mssql
MSSQL_DRIVER="ODBC Driver 17 for SQL Server"
MSSQL_HOST=db
MSSQL_PORT=1433

MSSQL_USER=mssqldocker
MSSQL_DB=mssqldocker
MSSQL_PASSWORD="yourStrong(!)PasswordForMssqldocker"
```
