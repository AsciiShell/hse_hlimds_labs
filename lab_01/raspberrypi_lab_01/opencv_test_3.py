from cv2 import cv2

if __name__ == '__main__':

    cam = cv2.VideoCapture(0)
    fourcc = cv2.VideoWriter_fourcc(*'XVID')
    out = cv2.VideoWriter('my_cam.avi', fourcc, 20.0, (640, 480))
    while True:
        ret, img = cam.read()
        cv2.imshow('my_cam', img)
        out.write(img)
        if cv2.waitKey(10) == 27:
            break
    cam.release()
    out.release()
    cv2.destroyAllWindows()
