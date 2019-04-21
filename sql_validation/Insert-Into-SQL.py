import pyodbc
server = 'sql-demo-server.database.windows.net'
database = 'sql-db'
username = 'crowe'
password = 'Practicum_2019'
driver= '{ODBC Driver 17 for SQL Server}'
connection = pyodbc.connect('DRIVER='+driver+';SERVER='+server+';PORT=1433;DATABASE='+database+';UID='+username+';PWD='+ password)
cursor = connection.cursor()
cursor.execute("SELECT @@version;")
row = cursor.fetchone()
while row:
    print (row[0]) 
    row = cursor.fetchone()

open_file = open("test.csv",'r').readlines()
print("File is Opened")
for line in open_file[1:]:
	print(line)

print("Inserting a record in SQL")

#SQLCommand = ("INSERT INTO dbo.factChargeData (firstName, lastName, city) VALUES (?,?,?)")
#Values = ['Susan','Ibach','Toronto']
#cursor.execute(SQLCommand,Values)
#connection.commit()
#connection.close()

print("Record Inserted")

SQL = ("select * from dbo.factChargeData")
cursor.execute(SQL)
print("Retrieving Data from the Charge Table")
for row in cursor.fetchall():
    print(row)
