from .consts import VECTOR


class Neuron:
    def __init__(self, size: int):
        self.size = size
        self.w = [0] * size
        self.bias = 0

    def forward(self, vector: VECTOR) -> int:
        assert len(vector) == self.size, 'Unsupported vector shape'
        s = self.bias
        for w, x in zip(self.w, vector):
            s += w * x
        return s

    def update_w(self, vector: VECTOR, target: int):
        assert len(vector) == self.size, 'Unsupported vector shape'
        self.bias += target
        for i, x in enumerate(vector):
            self.w[i] += x * target


__all__ = ['Neuron']
