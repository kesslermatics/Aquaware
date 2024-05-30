import pandas as pd
import numpy as np
from tensorflow.keras.models import load_model

# 1. Lade das trainierte Keras-Modell
model = load_model("models/Wassertemp_pH-Sauerstoff.keras")

# 2. Lade und bereite den neuen Datensatz vor
# Beispiel: CSV-Datei mit den Spalten 'temperatur' und 'ph'
new_data = pd.read_csv('filtered_feeds.csv')

# Stelle sicher, dass der Datensatz nur die notwendigen Spalten enthält
input_features = new_data['Temperatur', 'pH']

# Konvertiere die Daten in ein numpy-Array
input_array = input_features.to_numpy()

# 3. Wende das Modell auf den neuen Datensatz an
predictions = model.predict(input_array)

# Füge die Vorhersagen zu deinem DataFrame hinzu (optional)
new_data['predicted_sauerstoff'] = predictions

# Ausgabe der ersten paar Zeilen des DataFrame mit den Vorhersagen
print(new_data.head())
