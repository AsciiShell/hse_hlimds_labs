import logging
import time

try:
    import RPi.GPIO as GPIO
except RuntimeError as e:
    print(e)
    import raspberrypi_lab_01.fake_gpio as GPIO

logger = logging.getLogger(__name__)


class GPIOWrap:
    OUT = GPIO.OUT

    def __init__(self):
        GPIO.setmode(GPIO.BCM)
        self.pins = {}
        self.state = {}
        self.pwms = {}

    def init_pin(self, pin: int, mode):
        GPIO.setup(pin, mode)
        self.pins[pin] = mode

    def set_pin(self, pin: int, value: bool):
        if self.pins[pin] != GPIO.OUT:
            raise Exception('Bad port {}'.format(pin))
        if pin in self.state and self.state[pin] == value:
            return
        GPIO.output(pin, value)
        self.state[pin] = value

    def set_pwm(self, pin, freq):
        if pin not in self.pins:
            self.init_pin(pin, GPIO.OUT)
        self.pwms[pin] = GPIO.PWM(pin, freq)
        self.pwms[pin].start(0)

    def set_angle(self, pin, angle):
        if pin not in self.pwms:
            raise Exception('Bad pwm port {}'.format(pin))
        duty = angle / 18 + 2
        self.set_pin(pin, True)
        self.pwms[pin].ChangeDutyCycle(duty)
        time.sleep(0.01)  # TODO take a lot of time
        self.set_pin(pin, False)
        self.pwms[pin].ChangeDutyCycle(0)
        logger.info("set angle pin %s = %s", pin, angle)

    def __del__(self):
        self.close()

    def close(self):
        del self.pins, self.pwms, self.state
        GPIO.cleanup()


__all__ = ['GPIOWrap']
