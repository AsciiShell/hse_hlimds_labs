"""Fake class for emulation GPIO interface"""
import logging

BOARD = 10
OUT = 0
BCM = 20

logger = logging.getLogger(__name__)


class PWM:
    def __init__(self, pin, freq):
        pass

    def start(self, value):
        pass

    def ChangeDutyCycle(self, value):
        pass


def setmode(board_type):
    logger.info("set mode %s", board_type)


def setup(pin, direction):
    logger.info("setup pin %s = %s", pin, direction)


def output(pin, value):
    logger.info("set pin %s = %s", pin, value)


def cleanup():
    logger.info("cleanup")
