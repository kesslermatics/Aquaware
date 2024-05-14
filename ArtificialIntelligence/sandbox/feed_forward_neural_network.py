import torch
import torch.nn as nn
import torch.nn.functional as F


class FeedForwardNN(nn.Module):
    """
    A customizable feedforward neural network.

    Parameters:
        input_size (int): The number of input features.
        hidden_sizes (list of int): The number of neurons in each hidden layer.
        output_size (int): The number of output features.
        activation_funcs (list of callable): Activation functions for each hidden layer.

    Attributes:
        layers (nn.ModuleList): Contains all layers of the network, including input, hidden, and output layers.
        activation_funcs (list of callable): Stored activation functions for use in the forward pass.
    """

    def __init__(self, input_size, hidden_sizes, output_size, activation_funcs):
        super(FeedForwardNN, self).__init__()
        self.layers = nn.ModuleList()

        # Adding the input layer
        self.layers.append(nn.Linear(input_size, hidden_sizes[0]))

        # Adding each hidden layer
        for i in range(1, len(hidden_sizes)):
            self.layers.append(nn.Linear(hidden_sizes[i - 1], hidden_sizes[i]))

        # Adding the output layer
        self.layers.append(nn.Linear(hidden_sizes[-1], output_size))

        # Check if the number of activation functions matches the number of hidden layers
        if len(activation_funcs) != len(hidden_sizes):
            raise ValueError("Number of activation functions must match the number of hidden layers.")

        self.activation_funcs = activation_funcs

    def forward(self, x):
        """
        Defines the forward pass of the network.

        Parameters:
            x (Tensor): The input tensor.

        Returns:
            Tensor: The output tensor from the network.
        """
        # Applying each layer with its corresponding activation function
        for i in range(len(self.layers) - 1):
            x = self.layers[i](x)
            x = self.activation_funcs[i](x)
        # The last layer does not use an activation function in this setup
        x = self.layers[-1](x)
        return x

