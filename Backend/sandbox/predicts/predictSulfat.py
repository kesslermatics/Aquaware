from predict_parameter import PredictParameter

csv_file = '../wasserwerte_filled.csv'
feature_columns = ['Leitfaehigkeit']
label_column = 'Sulfat'

predictor = PredictParameter(csv_file, feature_columns, label_column)
best_params = predictor.optimize_hyperparameters(n_trials=100, verbose=0)
predictor.train_best_model(best_params, verbose=1)
predictor.save_model('models/Leitf-Sulfat.keras')

# Loss: 524.7274169921875, MAE: 16.593759536743164
# Spannweite der Spalte 'Sulfat': 208.0
# Prozentsatz des MAE relativ zur Spannweite der Spalte 'Sulfat': 7.98%

new_predictor = PredictParameter(csv_file, feature_columns, label_column)
new_predictor.load_model('models/Leitf-Sulfat.keras')
new_predictor.evaluate_model()
