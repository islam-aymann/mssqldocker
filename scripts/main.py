import pyodbc
conn = pyodbc.connect('Driver={ODBC Driver 17 for SQL Server};'
                      'Server=127.0.0.1;'
                      'Port=1433;'
                      'Database=testing;'
                      'PWD=yourStrong(!)Password;'
                      'UID=sa')

cursor = conn.cursor()
cursor.execute('SELECT * FROM dbo.test')

for row in cursor:
    print(row)