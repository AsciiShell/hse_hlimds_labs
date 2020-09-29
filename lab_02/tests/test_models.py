from hebbian_net_lab_02.activation import Sign
from hebbian_net_lab_02.consts import HIGH_LEVEL, LOW_LEVEL
from hebbian_net_lab_02.layers import Dense
from hebbian_net_lab_02.models import Model


def test_model_00():
    X = [[1, -1, 1, 1, 1, 1, -1, -1, 1], [1, 1, 1, 1, -1, 1, 1, -1, 1]]
    y = [[HIGH_LEVEL], [LOW_LEVEL], ]
    model = Model(Dense(len(y[0]), len(X[0]), Sign()))
    model.fit(X, y, 1000)
    y_pred = model.predict(X)
    assert model.epochs == 1
    assert all([a == b for a, b in zip(y_pred, y)])


def test_model_01():
    X = [[1, -1, 1, 1, 1, 1, -1, -1, 1], [1, 1, 1, 1, -1, 1, 1, -1, 1]]
    y = [[HIGH_LEVEL, LOW_LEVEL], [LOW_LEVEL, HIGH_LEVEL], ]
    model = Model(Dense(len(y[0]), len(X[0]), Sign()))
    model.fit(X, y, 1000)
    y_pred = model.predict(X)
    assert model.epochs == 1
    assert all([a == b for a, b in zip(y_pred, y)])
