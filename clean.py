import pandas as pd
import os
import numpy as np
import csv
from typing import Dict

#TODO: create officials table

def main():
    df = pd.read_csv('test.csv',
                     dtype={
                         'period_number': 'Int16',
                         'points': 'Int16'
                     })
    
    game_teams_df = pd.read_csv('cleaned_data/game_teams.csv')

    game_map: Dict[int, Dict[str, int]] = {}

    # Iterate through the rows of the DataFrame
    for _, row in game_teams_df.iterrows():
        game_id = row["game_id"]
        team_id = row["team_id"]
        is_home = row["is_home"]
        
        # Initialize the entry for this game_id if it doesn't exist
        if game_id not in game_map:
            game_map[game_id] = {"home": None, "away": None}

        # Assign team_id based on whether it is the home or away team
        if is_home:
            game_map[game_id]["home"] = team_id
        else:
            game_map[game_id]["away"] = team_id


    df['team_id'] = df.apply(
    lambda row: game_map[row['game_id']][row['team']], axis=1
    )

    df = df.drop(columns=['team'])

    df.to_csv('line_score.csv', index=False)





def create_teams_csv():
    # Read in games data 
    df = pd.read_csv('cleaned_data/game.csv')

    # Get unique teams from the DataFrame
    team_names = pd.Series(df['team_name_home'].tolist() + df['team_name_away'].tolist()).unique()

    with open('cleaned_data/teams.csv', 'w') as f:
        # Write the header
        f.write("id,team_name\n")
        # Write each team name in a new line
        for index, team in enumerate(team_names, start=1):
            f.write(f"{index},{team}\n")

    print("Created teams.csv with unique team names.")



def get_headers_and_data_types(file_path):
    """Read the CSV file and return the headers and data types."""
    df = pd.read_csv(file_path, nrows=0)  # Read only the header row
    dtypes = df.dtypes.apply(lambda x: x.name).to_dict()
    return dtypes


def clean_files():
    # Create cleaned_data directory if it doesn't exist
    create_cleaned_data_dir()

    # Clean each CSV file
    clean_common_players()
    clean_draft_history_csv()
    clean_game_info_csv()
    clean_game_summary_csv()
    clean_game_csv()
    clean_inactive_players_csv()
    clean_line_score_csv()
    clean_other_stats_csv()
    clean_team_details()
    clean_team_csv()


def clean_common_players():
    # Read the CSV file into a DataFrame
    df = pd.read_csv('original_data/common_player_info.csv')

    df = df.drop(columns=[
        'display_last_comma_first', 'display_fi_last', 'display_first_last', 'games_played_current_season_flag',
        'team_name', 'team_abbreviation', 'team_code', 'team_city', 'draft_year',
        'draft_round', 'draft_number', 'player_slug', 'playercode'
        ])
    
    df.rename(columns={
        "rosterstatus": "is_active",
        "dleague_flag": "is_dleague",
        "nba_flag": "is_nba",
        "games_played_flag": "has_played",
        "greatest_75_flag": "is_greatest_75"
        }, inplace=True)
    
    df['height'] = df['height'].apply(convert_height_to_inches).astype('Int32')

    convert_to_int_32 = ["from_year", "to_year", "weight", "season_exp"]
    df[convert_to_int_32] = df[convert_to_int_32].astype('Int32')

    df["birthdate"] = pd.to_datetime(df["birthdate"], errors='coerce')
    df['birthdate'] = df['birthdate'].apply(clean_dates)

    # Convert active or inactive to boolean
    df['is_active'] = df['is_active'].apply(lambda x: True if x == 'Active' else False)
    df['is_dleague'] = df['is_dleague'].apply(lambda x: True if x == 'Y' else False)
    df['is_nba'] = df['is_nba'].apply(lambda x: True if x == 'Y' else False)
    df['has_played'] = df['has_played'].apply(lambda x: True if x == 'Y' else False)
    df['is_greatest_75'] = df['is_greatest_75'].apply(lambda x: True if x == 'Y' else False)

    df.to_csv('cleaned_data/common_player_info.csv', index=False)
    print("Cleaned common player data saved to cleaned_data/common_player_info.csv")


def clean_draft_history_csv():
    df = pd.read_csv('original_data/draft_history.csv')

    # Drop unnecessary columns
    df = df.drop(columns=["team_abbreviation"])

    df.to_csv('cleaned_data/draft_history.csv', index=False)
    print("Cleaned draft history data saved to cleaned_data/draft_history.csv")


def clean_game_info_csv():
    df = pd.read_csv('original_data/game_info.csv')

    # Convert date columns to datetime format
    df["game_date"] = pd.to_datetime(df["game_date"], errors='coerce')
    df["game_date"] = df["game_date"].dt.strftime("%Y-%m-%d")

    df.to_csv('cleaned_data/game_info.csv', index=False)
    print("Cleaned game info data saved to cleaned_data/game_info.csv")


def clean_game_summary_csv():
    df = pd.read_csv('original_data/game_summary.csv')

    df.rename(columns={"game_date_est": "game_date"}, inplace=True)

    df["game_date"] = pd.to_datetime(df["game_date"], format="%Y-%m-%d", errors='coerce')
    df["game_date"] = df["game_date"].dt.strftime("%Y-%m-%d")

    df.to_csv('cleaned_data/game_summary.csv', index=False)
    print("Cleaned game summary data saved to cleaned_data/game_summary.csv")


def clean_game_csv():
    df = pd.read_csv('original_data/game.csv')

    # Drop unnecessary columns
    df = df.drop(columns=[
        "video_available_home", "video_available_away", "fg_pct_home", "fg_pct_away",
        "fg3_pct_home", "fg3_pct_away", "ft_pct_home", "ft_pct_away", "team_id_home",
        "team_id_away", "matchup_home", "wl_home", "wl_away", "matchup_away"
    ])

    columns_to_convert = [
        "fgm_home", "fga_home", "fg3m_home", "fg3a_home", "ftm_home", "fta_home",
        "oreb_home", "dreb_home", "reb_home", "ast_home", "stl_home", "blk_home",
        "tov_home", "pf_home", "pts_home", "plus_minus_home", "fgm_away", "fga_away",
        "fg3m_away", "fg3a_away", "ftm_away", "fta_away", "oreb_away", "dreb_away",
        "reb_away", "ast_away", "stl_away", "blk_away", "tov_away", "pf_away",
        "pts_away", "plus_minus_away"
    ]

    df[columns_to_convert] = df[columns_to_convert].astype('Int32')

    df["game_date"] = pd.to_datetime(df["game_date"], errors='coerce')
    df["game_date"] = df["game_date"].dt.strftime("%Y-%m-%d")

    df.to_csv('cleaned_data/game.csv', index=False)
    print("Cleaned game data saved to cleaned_data/game.csv")


def clean_inactive_players_csv():
    df = pd.read_csv('original_data/inactive_players.csv')

    # Drop unnecessary columns
    df = df.drop(columns=["team_abbreviation"])

    df.to_csv('cleaned_data/inactive_players.csv', index=False)
    print("Cleaned inactive players data saved to cleaned_data/inactive_players.csv")


def clean_line_score_csv():
    # Didn't change date format because later records might contain time info
    df = pd.read_csv('original_data/line_score.csv')

    df.rename(columns={"game_date_est": "game_date"}, inplace=True)

    columns_to_convert = [
        "pts_qtr1_home", "pts_qtr2_home", "pts_qtr3_home", "pts_qtr4_home",
        "pts_ot1_home", "pts_ot2_home", "pts_ot3_home", "pts_ot4_home",
        "pts_ot5_home", "pts_ot6_home", "pts_ot7_home", "pts_ot8_home",
        "pts_ot9_home", "pts_ot10_home", "pts_home", "pts_qtr1_away",
        "pts_qtr2_away", "pts_qtr3_away", "pts_qtr4_away", "pts_ot1_away",
        "pts_ot2_away", "pts_ot3_away", "pts_ot4_away", "pts_ot5_away",
        "pts_ot6_away", "pts_ot7_away", "pts_ot8_away", "pts_ot9_away",
        "pts_ot10_away", "pts_away"
    ]

    df[columns_to_convert] = df[columns_to_convert].astype('Int32')

    df.to_csv('cleaned_data/line_score.csv', index=False)
    print("Cleaned line score data saved to cleaned_data/line_score.csv")


def clean_other_stats_csv():
    # Read the CSV file into a DataFrame
    df = pd.read_csv('original_data/other_stats.csv')

    # Drop unnecessary columns
    df = df.drop(columns=["team_abbreviation_home", "team_abbreviation_away"])

    cols_to_convert = [
        "team_turnovers_home", "total_turnovers_home", "team_rebounds_home",
        "pts_off_to_home", "team_turnovers_away", "total_turnovers_away", 
        "team_rebounds_away", "pts_off_to_away", 
    ]

    # Convert columns to Int32
    df[cols_to_convert] = df[cols_to_convert].astype('Int32')

    df.to_csv('cleaned_data/other_stats.csv', index=False)
    print("Cleaned other stats data saved to cleaned_data/other_stats.csv")


def clean_team_details():
    # Read the CSV file into a DataFrame
    df = pd.read_csv('original_data/team_details.csv')

    # Drop unnecessary columns
    df = df.drop(columns=['yearfounded', 'facebook', 'instagram', 'twitter'])
    df['arenacapacity'] = df['arenacapacity'].astype('Int32')

    df.rename(columns={
        'arenacapacity': 'arena_capacity',
        'generalmanager': 'general_manager',
        'headcoach': 'head_coach',
        'dleagueaffiliation': 'd_league_affiliation',
    }, inplace=True)

    df.to_csv('cleaned_data/team_details.csv', index=False)
    print("Cleaned team details data saved to cleaned_data/team_details.csv")


def clean_team_csv():
    df = pd.read_csv('original_data/team.csv')

    df["year_founded"] = df["year_founded"].astype('Int32')

    df.to_csv('cleaned_data/team.csv', index=False)
    print("Cleaned team data saved to cleaned_data/team.csv")


def get_sample_data(file_path, num_rows=5):
    """Read the first few rows of a CSV file."""
    df = pd.read_csv(file_path, nrows=num_rows)
    return df


def read_csv_headers(file_path):
    """Read the CSV file and return the headers."""
    with open(file_path, 'r') as file:
        headers = file.readline().strip().split(',')
    return headers


def convert_height_to_inches(height_str):
    """Convert height from feet and inches to inches."""
    if pd.isna(height_str):
        return None
    try:
        feet, inches = map(int, height_str.split("-"))
        return feet * 12 + inches
    except ValueError:
        return None

    
def clean_dates(date_str):
    if pd.isna(date_str):
        return None
    
    try:
        date = pd.to_datetime(date_str, format='%Y-%m-%d', errors='coerce')
        if date is pd.NaT:
            raise ValueError("Invalid date format")
        return date
    except ValueError:
        # Handle other formats or errors as needed
        return None

    
def create_cleaned_data_dir():
    if not os.path.exists('cleaned_data'):
        os.makedirs('cleaned_data', exist_ok=True)
        print("Created directory cleaned_data")


if __name__ == "__main__":
    main()
