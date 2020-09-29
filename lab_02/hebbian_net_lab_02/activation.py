import abc
import typing

import math

from .consts import LOW_LEVEL, HIGH_LEVEL, VECTOR


class ActFuncABC(metaclass=abc.ABCMeta):
    @abc.abstractmethod
    def __call__(self, vector: VECTOR) -> VECTOR:
        pass

    @abc.abstractmethod
    def __str__(self):
        pass


class Sign(ActFuncABC):
    def __init__(self, theta=0):
        self.theta = theta

    def __call__(self, vector: VECTOR) -> VECTOR:
        return [HIGH_LEVEL if v > self.theta else LOW_LEVEL for v in vector]

    def __str__(self):
        return 'Sign'


class Sigmoid(ActFuncABC):
    def __init__(self):
        pass

    def __call__(self, vector: VECTOR) -> typing.List[float]:
        return [2 / (1 - math.exp(-v)) - 1 for v in vector]

    def __str__(self):
        return 'Sigmoid'


class Softmax(ActFuncABC):
    def __init__(self):
        pass

    def __call__(self, vector: VECTOR) -> typing.List[float]:
        exps = [math.exp(v) for v in vector]
        der = sum(exps)
        return [2 * e / der - 1 for e in exps]

    def __str__(self):
        return 'Softmax'


__all__ = ['ActFuncABC', 'Sign', 'Sigmoid', 'Softmax']
