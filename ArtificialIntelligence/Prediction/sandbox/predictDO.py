import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.colors
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, mean_squared_error
from tqdm import tqdm_notebook

from sklearn.preprocessing import OneHotEncoder

my_cmap = matplotlib.colors.LinearSegmentedColormap.from_list("", ["red", "yellow", "green"])
data = pd.read_csv("wasserwerte_filled.csv", on_bad_lines='skip', sep=';')
plt.scatter(data["Datum / Uhrzeit"], [data["Wassertemperatur"]], cmap=my_cmap)
plt.scatter(data["Datum / Uhrzeit"], data["pH-Wert"], cmap=my_cmap,)
plt.scatter(data["Datum / Uhrzeit"], data["Leitfaehigkeit"], cmap=my_cmap, label='pH-Wert')
plt.show()

print(data["Leitfaehigkeit"])