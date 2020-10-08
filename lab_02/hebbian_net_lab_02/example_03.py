from hebbian_net_lab_02.consts import HIGH_LEVEL, LOW_LEVEL
from hebbian_net_lab_02.draw import draw_flatten
from hebbian_net_lab_02.layers import Dense
from hebbian_net_lab_02.models import Model

if __name__ == '__main__':
    X = [
        [1, 1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1],
        [-1, 1, 1, 1, -1, -1, 1, -1, 1, -1, -1, 1, -1, 1, -1, 1, -1, -1, 1, -1],
        [1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1],
        [1, -1, -1, 1, -1, 1, -1, 1, -1, -1, 1, -1, 1, -1, -1, 1, 1, -1, -1, -1],
    ]
    y = [
        [LOW_LEVEL, LOW_LEVEL, ],
        [LOW_LEVEL, HIGH_LEVEL, ],
        [HIGH_LEVEL, LOW_LEVEL, ],
        [HIGH_LEVEL, HIGH_LEVEL, ],
    ]
    model = Model(Dense(len(y[0]), len(X[0])))
    model.fit(X, y, 100)
    y_pred = model.predict(X)
    for y_true, y_expected, row in zip(y, y_pred, X):
        print('Expected: {}, predicted: {}'.format(y_true, y_expected))
        draw_flatten(row, 4, 5)
        print()
