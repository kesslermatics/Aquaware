import numpy as np
import pandas as pd
import tensorflow as tf
from sklearn.model_selection import train_test_split

class PredictParameter:
    def __init__(self, csv_file, feature_columns, label_column, test_size=0.2, random_state=42, num_hidden_layers=2):
        self.csv_file = csv_file
        self.feature_columns = feature_columns
        self.label_column = label_column
        self.test_size = test_size
        self.random_state = random_state
        self.num_hidden_layers = num_hidden_layers
        self.model = None
        self.history = None
        self.load_data()

    def load_data(self):
        data = pd.read_csv(self.csv_file, on_bad_lines='skip', sep=';')
        self.selected_data = data[self.feature_columns].to_numpy()
        self.labels = data[self.label_column].to_numpy()
        self.x_train, self.x_test, self.y_train, self.y_test = train_test_split(
            self.selected_data, self.labels, test_size=self.test_size, random_state=self.random_state)

    def create_model(self):
        self.model = tf.keras.models.Sequential()
        # Input layer
        self.model.add(tf.keras.layers.Dense(len(self.feature_columns), activation='relu', input_shape=(len(self.feature_columns),)))
        # Hidden layers
        for _ in range(self.num_hidden_layers):
            self.model.add(tf.keras.layers.Dense(len(self.feature_columns), activation='relu'))
        # Output layer
        self.model.add(tf.keras.layers.Dense(1))
        self.model.compile(optimizer='adam', loss='mean_squared_error', metrics=["mae"])

    def train_model(self, epochs=2000):
        self.history = self.model.fit(
            self.x_train, self.y_train, epochs=epochs, validation_data=(self.x_test, self.y_test))

    def evaluate_model(self):
        loss, mae = self.model.evaluate(self.x_test, self.y_test)
        print(f"Loss: {loss}, MAE: {mae}")

