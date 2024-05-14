from predict_parameter import PredictParameter

feature_columns = ["Leitfaehigkeit"]
label_column = "Sulfat"
num_hidden_layers = 1  # Beispiel: Setze 3 versteckte Schichten
model = PredictParameter("wasserwerte_filled.csv", feature_columns, label_column, num_hidden_layers=num_hidden_layers)
model.create_model()
model.train_model(patience=10)
model.evaluate_model()

