import numpy as np
import matplotlib as plt
from tqdm import tqdm_notebook
from sklearn.metrics import mean_squared_error, log_loss

class SigmoidNeuron:
    def __init__(self):
        # Initialize the weights and bias to None
        self.w = None
        self.b = None

    def perceptron(self, x):
        # Compute the weighted sum of inputs
        # Computes the dot product of the input and the weights and adds the bias
        return np.dot(x, self.w.T) + self.b

    def sigmoid(self, x):
        # Compute the sigmoid activation function
        return 1.0/(1.0 + np.exp(-x))

    def grad_w_mse(self, x, y):
        # Compute the gradient of the weights mean squared error loss
        y_pred = self.sigmoid(self.perceptron(x))
        return (y_pred - y) * y_pred * (1 - y_pred) * x

    # Updating the gradients using the mean squared error loss
    def grad_b_mse(self, x, y):
        # Compute the gradient of the bias mean squared error loss
        y_pred = self.sigmoid(self.perceptron(x))
        return (y_pred - y) * y_pred * (1 - y_pred) * x

    # Updating the gradients using the cross entropy loss
    def grad_w_ce(self, x, y):
        y_pred = self.sigmoid(self.perceptron(x))
        if y == 0:
            return y_pred * x
        elif y == 1:
            return -1 * (1 - y_pred) * x
        else:
            raise ValueError("y should be 0 or 1")

    def grad_b_ce(self, x, y):
        y_pred = self.sigmoid(self.perceptron(x))
        if y == 0:
            return y_pred
        elif y == 1:
            return -1 * (1 - y_pred)
        else:
            raise ValueError("y should be 0 or 1")

    # Fit function to train the model
    # param X: Input data
    # param Y: Labels
    # param epochs: Number of epochs to train the model, default to 1
    # param initialise: Whether to initialise the weights and bias, default to True
    # param loss_fn: Loss function to use, default to "mse" ("mse" or "ce")
    # param display_loss: Whether to display the loss, default to False
    def fit(self, x, y, epochs=1, learning_rate=1, initialise=True, loss_fn="mse", display_loss=False):
        # Initialize the weights and bias
        if initialise:
            self.w = np.random.randn(1, x.shape[1])
            self.b = 0

        if display_loss:
            loss = {}

        for i in tqdm_notebook(range(epochs), total=epochs, unit="epoch"):
            dw = 0
            db = 0
            for x, y in zip(x, y):
                if loss_fn == "mse":
                    dw += self.grad_w_mse(x, y)
                    db += self.grad_b_mse(x, y)
                elif loss_fn == "ce":
                    dw += self.grad_w_ce(x, y)
                    db += self.grad_b_ce(x, y)

            m = x
            self.w -= learning_rate * dw/m
            self.b -= learning_rate * db/m

            if display_loss:
                Y_pred = self.sigmoid(self.perceptron(x))
                if loss_fn == "mse":
                    loss[i] = mean_squared_error(y, Y_pred)
                elif loss_fn == "ce":
                    loss[i] = log_loss(y, Y_pred)

        if display_loss:
            plt.plot(loss.values())
            plt.xlabel('Epochs')
            if loss_fn == "mse":
                plt.ylabel('Mean Squared Error')
            elif loss_fn == "ce":
                plt.ylabel('Log Loss')
            plt.show()

        def predict(self, x):
            Y_pred = []
            for x in x:
                y_pred = self.sigmoid(self.perceptron(x))
                Y_pred.append(y_pred)
            return np.array(Y_pred)