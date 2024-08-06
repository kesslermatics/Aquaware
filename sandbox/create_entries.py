import time
import requests
import json
import random

# API URLs
login_url = 'https://aquaware-production.up.railway.app/api/users/login/'  # Replace with your actual login endpoint
refresh_url = 'https://aquaware-production.up.railway.app/api/users/token/refresh/'  # Replace with your actual refresh endpoint
data_post_url = 'https://aquaware-production.up.railway.app/api/measurements/add/'  # Replace with your actual data post endpoint

# User credentials
credentials = {
    'email': 'bbunny@gmail.com',
    'password': 'bucksbunny'
}

# JSON template
data_template = {
    "aquarium_id": 1,
    "Temperature": 26.9,
    "PH": 8.2,
    "Oxygen": 8.9,
    "TDS": 630,
    "Ammonia": 0.03,
    "Nitrite": 0.11,
    "Nitrate": 36,
    "Phosphate": 2.2,
    "Carbon Dioxide": 13.9,
    "Salinity": 1.035,
    "General Hardness": 11.9,
    "Carbonate Hardness": 7.7,
    "Copper": 0.13,
    "Iron": 0.036,
    "Calcium": 450,
    "Magnesium": 1350,
    "Potassium": 15.8,
    "Chlorine": 0.08,
    "Redox Potential": 284,
    "Silica": 1.6,
    "Boron": 0.20,
    "Strontium": 7.0,
    "Iodine": 0.03,
    "Molybdenum": 0.005,
    "Sulfate": 260,
    "Organic Carbon": 1.8,
    "Turbidity": 0.6,
    "Conductivity": 570,
    "Suspended Solids": 17,
    "Fluoride": 0.64,
    "Bromine": 0.14,
    "Chloride": 32
}

def login():
    response = requests.post(login_url, json=credentials)
    print(credentials)
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

def simulate_data_fluctuation(data):
    fluctuation_percent = 0.05
    fluctuated_data = {}
    for key, value in data.items():
        if isinstance(value, (int, float)):
            fluctuation = value * fluctuation_percent * random.uniform(-1, 1)
            fluctuated_data[key] = round(value + fluctuation, 2)
        else:
            fluctuated_data[key] = value
    return fluctuated_data

def main():
    tokens = login()
    access_token = tokens['access']
    refresh_token_value = tokens['refresh']

    while True:
        try:
            # Refresh the access token
            tokens = refresh_token(refresh_token_value)
            access_token = tokens['access']

            # Simulate data fluctuation
            fluctuated_data = simulate_data_fluctuation(data_template)

            # Post the fluctuated data
            response = post_data(access_token, fluctuated_data)
            print(f"Data posted successfully at {time.ctime()}: {response}")

            # Wait for 15 minutes
            time.sleep(900)

        except requests.HTTPError as http_err:
            print(f"HTTP error occurred: {http_err}")
        except Exception as err:
            print(f"Other error occurred: {err}")

if __name__ == "__main__":
    main()
