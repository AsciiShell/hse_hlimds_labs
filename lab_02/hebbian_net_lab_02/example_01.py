from hebbian_net_lab_02.activation import ActSign
from hebbian_net_lab_02.consts import HIGH_LEVEL, LOW_LEVEL
from hebbian_net_lab_02.draw import draw_flatten
from hebbian_net_lab_02.models import Model
from hebbian_net_lab_02.neuron import Neuron

if __name__ == '__main__':
    X = [[1, 0, 1, 1, 1, 1, 0, 0, 1], [1, 1, 1, 1, 0, 1, 1, 0, 1]]
    y = [HIGH_LEVEL, LOW_LEVEL]
    model = Model(Neuron(len(X[0]), ActSign()))
    model.fit(X, y, 1000)
    y_pred = model.predict(X)
    for y_true, y_expected, row in zip(y, y_pred, X):
        print('Expected: {}, predicted: {}'.format(y_expected, y_true))
        draw_flatten(row, 3, 3)
        print()
