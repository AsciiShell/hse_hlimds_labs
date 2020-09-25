import sys

from cv2 import cv2

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("set file name")
        sys.exit(1)
    name = sys.argv[1]
    img = cv2.imread(name)
    cv2.imshow('my_image', img)
    cv2.waitKey(5000)
    cv2.destroyAllWindows()
