import mysql.connector
import numpy as np
import pandas as pd


def connect_db():
    return mysql.connector.connect(
        host="localhost",
        user="nbauser",
        password="",
        database="nba"
    )


def readCSV(file):
    try:
        df = pd.read_csv(f"data/sample_data/{file}.csv")
        df = df.replace(np.nan, None)
        val = []
        for _,row in df.iterrows():
            val.append(tuple(row))

        sql = (f"INSERT INTO {file} ({", ".join(df.columns.tolist())}) "
               f"VALUES ({("%s, " * len(df.columns)).rstrip()[:-1]})")
        return sql, val
    except Exception as e:
        print(f"Error reading {file}.csv: {str(e)}")
        return None, None


def import_data():
    order_of_tables = [
        "franchises",
        "teams",
        "team_details",
        "seasons",
        "players",
        "draft_history",
        "games",
        "team_games",
        "quarter_scores",
        "officials",
        "game_officials",
        "conferences",
        "divisions",
        "franchise_divisions",
        "franchise_conferences"
    ]

    mydb = connect_db()
    cursor = mydb.cursor()

    try:
        # Temporarily disable foreign key checks
        cursor.execute("SET FOREIGN_KEY_CHECKS=0")

        for file in order_of_tables:
            print(f"Processing {file}...")
            query, inputs = readCSV(file)

            if query and inputs:
                try:
                    cursor.executemany(query, inputs)
                    mydb.commit()  # Commit after each successful table import
                    print(f"Successfully imported {len(inputs)} records to {file}")
                except mysql.connector.Error as err:
                    print(f"Error importing {file}: {err}")
                    mydb.rollback()  # Rollback on error

        # Re-enable foreign key checks
        cursor.execute("SET FOREIGN_KEY_CHECKS=1")

    finally:
        cursor.close()
        mydb.close()


if __name__ == "__main__":
    import_data()