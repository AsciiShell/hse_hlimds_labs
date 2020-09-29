from .consts import VECTOR, MATRIX

EMPTY_CHAR = ' '
FULL_CHAR = '█'


def _list_to_pic(img: VECTOR):
    return ''.join([FULL_CHAR if x else EMPTY_CHAR for x in img])


def draw(img: MATRIX):
    for row in img:
        print(_list_to_pic(row))


def draw_flatten(img: VECTOR, width: int, height: int):
    assert len(img) == width * height, 'Wrong dimension'
    for row in range(height):
        print(_list_to_pic(img[row * width: (row + 1) * width]))


__all__ = ['draw', 'draw_flatten']
