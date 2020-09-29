import abc

from .consts import LOW_LEVEL, HIGH_LEVEL, VECTOR


class ActFuncABC(metaclass=abc.ABCMeta):
    @abc.abstractmethod
    def __call__(self, vector: VECTOR) -> VECTOR:
        pass

    @abc.abstractmethod
    def __str__(self):
        pass


class ActSign(ActFuncABC):
    def __init__(self, theta=0):
        self.theta = theta

    def __call__(self, vector: VECTOR) -> VECTOR:
        return [HIGH_LEVEL if v > self.theta else LOW_LEVEL for v in vector]

    def __str__(self):
        return 'Sign'


__all__ = ['ActSign', 'ActFuncABC']
