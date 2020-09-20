import argparse

from cv2 import cv2

parser = argparse.ArgumentParser(
    description='Script to run MobileNet-SSD object detection network ')
parser.add_argument("--video", help="path to video file. If empty, camera's stream will be used")
parser.add_argument("--prototxt", default="MobileNetSSD_deploy.prototxt",
                    help='Path to text network file: '
                         'MobileNetSSD_deploy.prototxt for Caffe model or '
                    )
parser.add_argument("--weights", default="MobileNetSSD_deploy.caffemodel",
                    help='Path to weights: '
                         'MobileNetSSD_deploy.caffemodel for Caffe model or '
                    )
parser.add_argument("--thr", default=0.2, type=float, help="confidence threshold to filter out weak detections")

# Labels of Network.
classNames = {0: 'background',
              1: 'aeroplane', 2: 'bicycle', 3: 'bird', 4: 'boat',
              5: 'bottle', 6: 'bus', 7: 'car', 8: 'cat', 9: 'chair',
              10: 'cow', 11: 'diningtable', 12: 'dog', 13: 'horse',
              14: 'motorbike', 15: 'person', 16: 'pottedplant',
              17: 'sheep', 18: 'sofa', 19: 'train', 20: 'tvmonitor'}


def main():
    args = parser.parse_args()
    if args.video:
        cap = cv2.VideoCapture(args.video)
    else:
        cap = cv2.VideoCapture(0)

    # Load the Caffe model
    net = cv2.dnn.readNetFromCaffe(args.prototxt, args.weights)

    while True:
        # Capture frame-by-frame
        ret, frame = cap.read()
        frame_resized = cv2.resize(frame, (300, 300))  # resize frame for prediction

        blob = cv2.dnn.blobFromImage(frame_resized, 0.007843, (300, 300), (127.5, 127.5, 127.5), False)
        net.setInput(blob)
        detections = net.forward()

        cols = frame_resized.shape[1]
        rows = frame_resized.shape[0]

        for i in range(detections.shape[2]):
            confidence = detections[0, 0, i, 2]  # Confidence of prediction
            if confidence > args.thr:  # Filter prediction
                class_id = int(detections[0, 0, i, 1])  # Class label

                # Object location
                x_left_bottom = int(detections[0, 0, i, 3] * cols)
                y_left_bottom = int(detections[0, 0, i, 4] * rows)
                x_right_top = int(detections[0, 0, i, 5] * cols)
                y_right_top = int(detections[0, 0, i, 6] * rows)

                # Factor for scale to original size of frame
                height_factor = frame.shape[0] / 300.0
                width_factor = frame.shape[1] / 300.0
                # Scale object detection to frame
                x_left_bottom = int(width_factor * x_left_bottom)
                y_left_bottom = int(height_factor * y_left_bottom)
                x_right_top = int(width_factor * x_right_top)
                y_right_top = int(height_factor * y_right_top)
                # Draw location of object
                cv2.rectangle(frame, (x_left_bottom, y_left_bottom), (x_right_top, y_right_top), (0, 255, 0))

                # Draw label and confidence of prediction in frame resized
                if class_id in classNames:
                    label = classNames[class_id] + ": " + str(confidence)
                    label_size, base_line = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.5, 1)

                    y_left_bottom = max(y_left_bottom, label_size[1])
                    cv2.rectangle(frame, (x_left_bottom, y_left_bottom - label_size[1]),
                                  (x_left_bottom + label_size[0], y_left_bottom + base_line),
                                  (255, 255, 255), cv2.FILLED)
                    cv2.putText(frame, label, (x_left_bottom, y_left_bottom),
                                cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 0))

                    print(label)  # print class and confidence
        cv2.namedWindow("frame", cv2.WINDOW_NORMAL)
        cv2.imshow("frame", frame)
        if cv2.waitKey(1) >= 0:
            break


if __name__ == '__main__':
    main()
