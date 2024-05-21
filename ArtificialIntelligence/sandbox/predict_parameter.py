import numpy as np
import pandas as pd
import tensorflow as tf
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from optuna.integration import TFKerasPruningCallback
import optuna


class PredictParameter:
    def __init__(self, csv_file, feature_columns, label_column, test_size=0.2, random_state=42):
        self.csv_file = csv_file
        self.feature_columns = feature_columns
        self.label_column = label_column
        self.test_size = test_size
        self.random_state = random_state
        self.model = None
        self.history = None
        self.scaler = StandardScaler()
        self.load_data()

    def load_data(self):
        data = pd.read_csv(self.csv_file, on_bad_lines='skip', sep=';')
        self.selected_data = data[self.feature_columns].to_numpy()
        self.labels = data[self.label_column].to_numpy()

        # Feature scaling
        self.selected_data = self.scaler.fit_transform(self.selected_data)

        self.x_train, self.x_test, self.y_train, self.y_test = train_test_split(
            self.selected_data, self.labels, test_size=self.test_size, random_state=self.random_state)

    def create_model(self, trial):
        self.model = tf.keras.models.Sequential()
        input_shape = (len(self.feature_columns),)
        # Input layer
        self.model.add(tf.keras.layers.Dense(units=len(self.feature_columns), activation='relu', input_shape=input_shape))

        num_hidden_layers = trial.suggest_int('num_hidden_layers', 1, 3)
        num_units = trial.suggest_int('num_units', 8, 64)
        dropout_rate = trial.suggest_float('dropout_rate', 0.2, 0.5)
        learning_rate = trial.suggest_float('learning_rate', 1e-4, 1e-2)

        # Hidden layers with dropout
        for _ in range(num_hidden_layers):
            self.model.add(tf.keras.layers.Dense(num_units, activation='relu'))
            self.model.add(tf.keras.layers.Dropout(dropout_rate))

        # Output layer
        self.model.add(tf.keras.layers.Dense(1))

        # Optimizer with learning rate
        optimizer = tf.keras.optimizers.Adam(learning_rate=learning_rate)
        self.model.compile(optimizer=optimizer, loss='mean_squared_error', metrics=["mae"])

    def train_model(self, trial, batch_size, patience=10, verbose=0):
        early_stopping = tf.keras.callbacks.EarlyStopping(
            monitor='val_loss',
            patience=patience,
            restore_best_weights=True)

        self.history = self.model.fit(
            self.x_train,
            self.y_train,
            verbose=verbose,
            epochs=200000,
            batch_size=batch_size,
            validation_data=(self.x_test, self.y_test),
            callbacks=[early_stopping, TFKerasPruningCallback(trial, 'val_loss')])

    def evaluate_model(self):
        loss, mae = self.model.evaluate(self.x_test, self.y_test)
        print(f"Loss: {loss}, MAE: {mae}")

        range_value = self.labels.max() - self.labels.min()
        print(f"Spannweite der Spalte '{self.label_column}': {range_value}")

        # Berechnen Sie den Prozentsatz des MAE relativ zur Spannweite der Spalte
        mae_prozent = (mae / range_value) * 100
        print(f"Prozentsatz des MAE relativ zur Spannweite der Spalte '{self.label_column}': {mae_prozent:.2f}%")

    def save_model(self, file_path):
        self.model.save(file_path)
        print(f"Model saved to {file_path}")

    def load_model(self, file_path):
        self.model = tf.keras.models.load_model(file_path)
        print(f"Model loaded from {file_path}")

    def optimize_hyperparameters(self, n_trials=50, verbose=0):
        def objective(trial):
            self.create_model(trial)
            batch_size = trial.suggest_int('batch_size', 16, 128)
            self.train_model(trial, batch_size, patience=10, verbose=verbose)
            loss, _ = self.model.evaluate(self.x_test, self.y_test, verbose=0)
            return loss

        study = optuna.create_study(direction='minimize')
        study.optimize(objective, n_trials=n_trials)
        print(f"Best hyperparameters: {study.best_params}")
        return study.best_params

    def train_best_model(self, best_params, verbose=0):
        fixed_trial = optuna.trial.FixedTrial(best_params)
        self.create_model(fixed_trial)
        self.train_model(fixed_trial, best_params['batch_size'], patience=10, verbose=verbose)
        self.evaluate_model()
