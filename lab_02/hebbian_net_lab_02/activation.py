import abc

from .consts import LOW_LEVEL, HIGH_LEVEL


class ActFuncABC(metaclass=abc.ABCMeta):
    @abc.abstractmethod
    def __call__(self, vector: int) -> int:
        pass


class ActSign(ActFuncABC):
    def __init__(self, theta=0):
        self.theta = theta

    def __call__(self, vector: int) -> int:
        return HIGH_LEVEL if vector > self.theta else LOW_LEVEL


__all__ = ['ActSign', 'ActFuncABC']
