import random
import typing

from tqdm.auto import tqdm

from .consts import MATRIX
from .layers import Dense


class Model:
    def __init__(self, net: Dense, seed=None):
        self.net = net
        self.epochs = 0
        self.random = random.Random(seed)

    def summary(self):
        print(self.net)

    def pairwise_shuffle(self, *args):
        c = list(zip(*args))
        self.random.shuffle(c)
        return zip(*c)

    def fit(self, x: MATRIX, y: MATRIX, epochs: int) -> typing.List[float]:
        assert len(x) == len(y), 'Data and labels have different shape'
        history = []
        for epoch in tqdm(range(epochs)):
            x_sh, y_sh = self.pairwise_shuffle(x, y)
            for x1, y1 in zip(x_sh, y_sh):
                self.net.update_w(x1, y1)
            scores = []
            for y_true, y_pred in zip(y, self.predict(x)):
                scores.append(y_true == y_pred)
            score = sum(scores) / len(scores)
            history.append(score)
            self.epochs = epoch + 1
            if score == 1:
                break
        return history

    def predict(self, x: MATRIX) -> MATRIX:
        result = [self.net.forward(x1) for x1 in x]
        return result


__all__ = ['Model']
