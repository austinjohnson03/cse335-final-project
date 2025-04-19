import pandas as pd
import os

def main():
    for filename in os.listdir("original_data"):
        if filename.endswith(".csv"):
            file_path = os.path.join("original_data", filename)
            try:
                sample_df = get_sample_data(file_path)
                output_path = os.path.join("sample_data", filename)
                sample_df.to_csv(output_path, index=False)

            except Exception as e:
                print(f"Error processing {filename}: {e}")
            


def get_sample_data(file_path, num_rows=5):
    """Read the first few rows of a CSV file."""
    df = pd.read_csv(file_path, nrows=num_rows)
    return df

def read_csv_headers(file_path):
    """Read the CSV file and return the headers."""
    with open(file_path, 'r') as file:
        headers = file.readline().strip().split(',')
    return headers

def clean_play_by_play():
    df = pd.read_csv('original_data/play_by_play.csv')

    print(df.head())

def clean_team_details():
    # Read the CSV file into a DataFrame
    df = pd.read_csv('original_data/team_details.csv')

    # Drop unnecessary columns
    df = df.drop(columns=['facebook', 'instagram', 'twitter'])
    df['yearfounded'] = df['yearfounded'].astype('Int32')
    df['arenacapacity'] = df['arenacapacity'].astype('Int32')

    print(df["yearfounded"])
    print(df["arenacapacity"])


def clean_common_players():
    # Read the CSV file into a DataFrame
    df = pd.read_csv('original_data/common_player_info.csv')

    df = df.drop(columns=[
        'display_last_comma_first', 'display_fi_last', 'games_played_current_season_flag',
        'team_name', 'team_abbreviation', 'team_code', 'team_city', 'draft_year',
        'draft_round', 'draft_number'
        ])
    
    df['height'] = df['height'].apply(convert_height_to_inches).astype('Int32')

    df["birthdate"] = pd.to_datetime(df["birthdate"], errors='coerce')
    df['birthdate'] = df['birthdate'].apply(clean_dates)

    df.to_csv('cleaned_data/common_player_info.csv', index=False)

    print("Cleaned common player data saved to cleaned_data/common_player_info.csv")

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

if __name__ == "__main__":
    main()
