import numpy as np
from cv2 import cv2

if __name__ == '__main__':
    cap = cv2.VideoCapture(0)
    while True:
        ret, captured_frame = cap.read()
        output_frame = captured_frame.copy()

        captured_frame_bgr = cv2.cvtColor(captured_frame, cv2.COLOR_BGRA2BGR)
        captured_frame_bgr = cv2.medianBlur(captured_frame_bgr, 3)
        captured_frame_lab = cv2.cvtColor(captured_frame_bgr, cv2.COLOR_BGR2Lab)
        # HSV color format
        captured_frame_lab_red = cv2.inRange(captured_frame_lab, np.array([40, 170, 170]), np.array([190, 255, 255]))
        captured_frame_lab_red = cv2.GaussianBlur(captured_frame_lab_red, (5, 5), 2, 2)
        circles = cv2.HoughCircles(captured_frame_lab_red, cv2.HOUGH_GRADIENT, 1, captured_frame_lab_red.shape[0] / 8,
                                   param1=100, param2=18, minRadius=5, maxRadius=60)

        if circles is not None:
            circles = np.round(circles[0, :]).astype(np.int32)
            cv2.circle(output_frame, center=(circles[0, 0], circles[0, 1]), radius=circles[0, 2], color=(0, 255, 0),
                       thickness=2)

        cv2.imshow('frame', output_frame)
        if cv2.waitKey(1) >= 0:
            break

    cap.release()
    cv2.destroyAllWindows()
