import abc

from .activation import ActFuncABC
from .consts import VECTOR
from .neuron import Neuron


class LayerABC(metaclass=abc.ABCMeta):
    @abc.abstractmethod
    def forward(self, vector: VECTOR) -> int:
        pass

    @abc.abstractmethod
    def update_w(self, vector: VECTOR, target: int):
        pass


class Dense(LayerABC):
    def __init__(self, units: int, input_shape: int, activation: ActFuncABC):
        self.units = units
        self.input_shape = input_shape
        self.neurons = [Neuron(self.input_shape) for _ in range(self.units)]
        self.activation = activation

    def forward(self, vector: VECTOR) -> VECTOR:
        assert len(vector) == self.input_shape, 'Unsupported vector shape'
        out = [neuron.forward(vector) for neuron in self.neurons]
        out = self.activation(out)
        return out

    def update_w(self, vector: VECTOR, target: VECTOR):
        assert len(vector) == self.input_shape, 'Unsupported vector shape'
        assert len(target) == self.units, 'Unsupported layer shape'
        for neuron, y in zip(self.neurons, target):
            neuron.update_w(vector, y)

    def __str__(self):
        return 'Dense {} x {}; Activation: {}'.format(self.input_shape, self.units,
                                                      self.activation)


__all__ = ['LayerABC', 'Dense']
