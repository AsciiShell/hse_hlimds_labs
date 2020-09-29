import typing

from tqdm.auto import tqdm

from .neuron import Neuron


class Model:
    def __init__(self, net: Neuron):
        self.net = net
        self.epochs = 0

    def summary(self):
        print("Dense: ", self.net.size)
        print("Activation: ", self.net.activation)

    def fit(self, x: typing.List[typing.List[int]], y: typing.List[int],
            epochs: int) -> typing.List[float]:
        history = []
        for epoch in tqdm(range(epochs)):
            for x1, y1 in zip(x, y):
                self.net.update_w(x1, y1)
            scores = []
            for y_true, y_pred in zip(y, self.predict(x)):
                scores.append(y_true == y_pred)
            score = sum(scores) / len(scores)
            history.append(score)
            self.epochs = epoch
            if score == 1:
                break
        return history

    def predict(self, x: typing.List[typing.List[int]]) -> typing.List[int]:
        result = [self.net.forward(x1) for x1 in x]
        return result


__all__ = ['Model']
