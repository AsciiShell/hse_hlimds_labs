from cv2 import cv2

if __name__ == '__main__':

    cam = cv2.VideoCapture(0)
    while True:
        ret, img = cam.read()
        cv2.imshow('my_cam', img)
        if cv2.waitKey(10) == 27:
            break
    cam.release()
    cv2.destroyAllWindows()
