import typing

from .activation import ActFuncABC


class Neuron:
    def __init__(self, size: int, activation: ActFuncABC):
        self.size = size
        self.activation = activation
        self.w = [0] * size
        self.bias = 0

    def forward(self, vector: typing.List[int]) -> int:
        assert len(vector) == self.size, 'Unsupported vector shape'
        s = self.bias
        for w, x in zip(self.w, vector):
            s += w * x
        out = self.activation(s)
        return out

    def update_w(self, vector: typing.List[int], target: int):
        assert len(vector) == self.size, 'Unsupported vector shape'
        self.bias += target
        for i, x in enumerate(vector):
            self.w[i] += x * target


__all__ = ['Neuron']
