import mysql.connector
import pandas as pd

mydb = mysql.connector.connect(
  host="localhost",
  user="nbauser",
  password="",
    database="nba"
)

cursor = mydb.cursor()

def allTables():
    cursor.execute("SHOW TABLES")
    tables = cursor.fetchall()

    for table in tables:
        table_name = table[0]
        cursor.execute(f"SELECT * FROM {table_name}")
        rows = cursor.fetchall()
        print(f"Data from {table_name}:")
        for row in rows:
            print(row.keys())

def readCSV(file="draft_history"):
    df = pd.read_csv(f"data/{file}.csv", nrows=5)
    val = []
    print("Data from CSV: ")
    for i, row in df.iterrows():
        newEntry = []
        for x, y in row.items():
            newEntry.append(y)
        val.append(newEntry)
    sql = (f"INSERT INTO {file} ({" ".join(df.columns.tolist())}) "
           f"VALUES ({("%s "*len(df.columns)).rstrip()})")
    print(sql)
    print(f"Values: {val}")

readCSV()


cursor.close()
mydb.close()