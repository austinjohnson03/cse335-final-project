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
    tableList = []

    for table in tables:
        table_name = table[0]
        cursor.execute(f"SELECT * FROM {table_name}")
        rows = cursor.fetchall()
        tableList.append(table[0])
        print(f"Data from {table_name}:")
        for row in rows:
            print(row.keys())
            print(row.items)

    return tableList

order_of_tables = [
    "franchises",
    "teams",
    "team_details",
    "seasons",
    "players",
    "draft_history",
    "games",
    "team_games",
    # "quarter_scores",
    "officials",
    "game_officials",
]
def readCSV(file="draft_history"):
    df = pd.read_csv(f"data/{file}.csv")
    # df = df.where(pd.notnull(df), None)
    df.dropna(inplace=True)
    val = []
    for i, row in df.iterrows():
        new_entry = []
        for x, y in row.items():
            new_entry.append(y)
        val.append(new_entry)
    sql = (f"INSERT INTO {file} ({", ".join(df.columns.tolist())}) "
           f"VALUES ({("%s, "*len(df.columns)).rstrip()[:-1]})")
    return sql, val

def cleanData(file="players"):
    # clean players.csv
    # by removing
    df = pd.read_csv(f"data/{file}.csv")
    # print(df.columns[13])
    print("franchise_id" in df.columns)
    if "franchise_id" in df.columns:
        df.drop("franchise_id", axis=1, inplace=True)
    df.to_csv(f"data/{file}.csv", index=False)
    pass

# allt = allTables()
# print(allt)

# for file in order_of_tables:
#     print(f"reading {file}")
#     query, inputs = readCSV(file)
#     print(query)
#     print(inputs)
#     if query and inputs:
#         cursor.executemany(query, inputs)
# mydb.commit()

# cleanData()


for file in order_of_tables:
    print(f"reading {file}")
    query, inputs = readCSV(file)
    print(query)
    # print(inputs)
    if query and inputs:
        cursor.executemany(query, inputs)
        # mydb.commit()


# mydb.commit()

# allTables()


cursor.close()
mydb.close()