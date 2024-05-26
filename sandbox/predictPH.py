from predict_parameter import PredictParameter

csv_file = '../filtered_feeds.csv'
feature_columns = ['Temperatur', 'TDS(ppm)']
label_column = 'pH'

predictor = PredictParameter(csv_file, feature_columns, label_column)
best_params = predictor.optimize_hyperparameters(n_trials=100, verbose=0)
predictor.train_best_model(best_params, verbose=1)
predictor.save_model('models/Temp_TDS-pH.keras')

# Loss: 4.606654644012451, MAE: 1.5704728364944458
# Spannweite der Spalte 'Sauerstoff-Gehalt': 17.6
# Prozentsatz des MAE relativ zur Spannweite der Spalte 'Sauerstoff-Gehalt': 8.92%

new_predictor = PredictParameter(csv_file, feature_columns, label_column)
new_predictor.load_model('models/Temp_TDS-pH.keras')
new_predictor.evaluate_model()
