import os
import pathlib

from net.consts import HIGH_LEVEL, LOW_LEVEL
from net.draw import draw_flatten
from net.layers import Dense
from net.models import Model
from net.save_data import save_data

if __name__ == '__main__':
    X = [[1, 0, 1, 1, 1, 1, 0, 0, 1], [1, 1, 1, 1, 0, 1, 1, 0, 1]]
    y = [[HIGH_LEVEL], [LOW_LEVEL], ]
    model = Model(Dense(len(y[0]), len(X[0])))
    model.fit(X, y, 1000)
    y_pred = model.predict(X)
    for y_true, y_expected, row in zip(y, y_pred, X):
        print('Expected: {}, predicted: {}'.format(y_expected, y_true))
        draw_flatten(row, 3, 3)
        print()

    for row in X:
        print("        x = {}'b{};#(Tt);".format(len(row), ''.join(map(str, row[::-1]))))

    root = pathlib.Path(os.path.join(os.getcwd(), __file__)).parent.parent
    root = os.path.join(root, 'de10-nano')
    save_data(model, os.path.join(root, 'program.hex'), os.path.join(root, 'neuron.v'))
