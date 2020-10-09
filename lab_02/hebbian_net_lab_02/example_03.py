from net.draw import draw_flatten
from net.layers import Dense
from net.models import Model

if __name__ == '__main__':
    X = [
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1],
        [1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1],
        [1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0],
        [1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1],
        [1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1],
        [1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1],
        [1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0],
    ]
    y = [
        [1, 1, 0, 0],
        [0, 0, 1, 0],
        [1, 0, 0, 0],
        [0, 1, 0, 1],
        [1, 0, 1, 1],
        [1, 0, 0, 1],
        [1, 0, 1, 0],
        [0, 1, 1, 0],
    ]
    model = Model(Dense(len(y[0]), len(X[0])), 42)
    model.fit(X, y, 10)
    y_pred = model.predict(X)
    for y_true, y_expected, row in zip(y, y_pred, X):
        print('Expected: {}, predicted: {}'.format(y_true, y_expected))
        draw_flatten(row, 4, 5)
        print()
    print(model.net.neurons[0].dump_verilog())
