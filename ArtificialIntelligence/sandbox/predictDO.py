from predict_parameter import PredictParameter

feature_columns = ["Wassertemperatur", "pH-Wert", "Leitfaehigkeit"]
label_column = "Sauerstoff-Gehalt"
num_hidden_layers = 3  # Beispiel: Setze 3 versteckte Schichten
model = PredictParameter("wasserwerte_filled.csv", feature_columns, label_column, num_hidden_layers=num_hidden_layers)
model.create_model()
model.train_model(epochs=2000)
model.evaluate_model()