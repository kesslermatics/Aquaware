import time
import requests
import json
import pandas as pd

# API URLs
login_url = 'https://aquaware-production.up.railway.app/api/users/login/'
refresh_url = 'https://aquaware-production.up.railway.app/api/users/token/refresh/'
data_post_url = 'https://aquaware-production.up.railway.app/api/measurements/add/'

# User credentials
credentials = {
    'email': 'bbunny@gmail.com',
    'password': 'bucksbunny'
}

# Load the CSV file
file_path = 'feeds.csv'
feeds_df = pd.read_csv(file_path)

# Starting column index
start_column_index = 22215

def login():
    response = requests.post(login_url, json=credentials)
    response.raise_for_status()
    return response.json()

def refresh_token(refresh_token):
    response = requests.post(refresh_url, json={'refresh': refresh_token})
    response.raise_for_status()
    return response.json()

def post_data(access_token, data):
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    }
    response = requests.post(data_post_url, headers=headers, data=json.dumps(data))
    response.raise_for_status()
    return response.json()

def main():
    tokens = login()
    access_token = tokens['access']
    refresh_token_value = tokens['refresh']

    current_column_index = start_column_index

    while True:
        try:
            # Refresh the access token
            tokens = refresh_token(refresh_token_value)
            access_token = tokens['access']

            # Extract data from the current column
            temperature = round(feeds_df['temperature'].iloc[current_column_index], 3)
            ph = round(feeds_df['ph'].iloc[current_column_index], 3)
            tds = round(feeds_df['tds'].iloc[current_column_index], 3)

            # Prepare the data payload
            data_payload = {
                "aquarium_id": 1,
                "Temperature": float(temperature),
                "PH": float(ph),
                "TDS": float(tds)
            }

            # Post the data
            response = post_data(access_token, data_payload)
            print ("Data index: ", current_column_index)
            print ("Temperature: ", temperature)
            print ("PH: ", ph)
            print ("TDS: ", tds)
            print(f"Data posted successfully at {time.ctime()}")
            print("--------------------------")

            # Move to the next column
            current_column_index += 1

            # Wait for 30 minutes
            time.sleep(1800)

        except requests.HTTPError as http_err:
            print(f"HTTP error occurred: {http_err}")
            print(f"Request payload: {data_payload}")
            try:
                print(f"Response content: {http_err.response.content.decode()}")
            except AttributeError:
                pass
        except Exception as err:
            print(f"Other error occurred: {err}")
            print(f"Request payload: {data_payload}")

if __name__ == "__main__":
    main()
