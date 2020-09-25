import logging

import numpy as np
from cv2 import cv2
from raspberrypi_lab_01.hardware import GPIOWrap


def pos_to_deg(pos):
    return int(pos * 180)


LED_PIN = 23
SERVO_PIN = 25
OBJ_THRESHOLD = 0.1
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    level=logging.INFO)
logger = logging.getLogger(__name__)
if __name__ == '__main__':
    logger.info('Begin')
    cap = cv2.VideoCapture(0)

    gpio = GPIOWrap()
    gpio.init_pin(LED_PIN, GPIOWrap.OUT)
    gpio.init_pin(SERVO_PIN, GPIOWrap.OUT)
    gpio.set_pwm(SERVO_PIN, 50)
    logger.info('Start app')
    while True:
        ret, captured_frame = cap.read()
        captured_frame = captured_frame[:, ::-1, :]
        output_frame = captured_frame.copy()

        captured_frame_bgr = cv2.cvtColor(captured_frame, cv2.COLOR_BGRA2BGR)
        captured_frame_bgr = cv2.medianBlur(captured_frame_bgr, 3)
        captured_frame_lab = cv2.cvtColor(captured_frame_bgr, cv2.COLOR_BGR2Lab)
        # HSV color format
        captured_frame_lab_red = cv2.inRange(
            captured_frame_lab, np.array([40, 170, 170]), np.array([220, 255, 255]))
        captured_frame_lab_red = cv2.GaussianBlur(
            captured_frame_lab_red, (5, 5), 2, 2)
        circles = cv2.HoughCircles(captured_frame_lab_red, cv2.HOUGH_GRADIENT, 1,
                                   captured_frame_lab_red.shape[0] / 8,
                                   param1=100, param2=18, minRadius=30,
                                   maxRadius=120)

        gpio.set_pin(LED_PIN, circles is not None)

        if circles is not None:
            circles = np.round(circles[0, :]).astype(np.int32)
            max_ri = 0
            for i, (cx, cy, r) in enumerate(circles):
                if r > circles[max_ri][2]:
                    max_ri = i
                cv2.circle(output_frame, center=(cx, cy), radius=r,
                           color=(0, 255, 0), thickness=2)
            obj_pos = circles[max_ri][0] / output_frame.shape[1]
            if not (0.5 - OBJ_THRESHOLD < obj_pos < 0.5 + OBJ_THRESHOLD):
                gpio.set_angle(SERVO_PIN, pos_to_deg(obj_pos))
            logger.info('Target object at %s', obj_pos)
        cv2.imshow('frame', output_frame)
        if cv2.waitKey(50) >= 0:
            break

    cap.release()
    cv2.destroyAllWindows()
