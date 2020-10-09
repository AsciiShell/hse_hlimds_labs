from net.consts import HIGH_LEVEL, LOW_LEVEL
from net.draw import draw_flatten
from net.layers import Dense
from net.models import Model

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
