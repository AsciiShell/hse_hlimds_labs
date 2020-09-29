import typing

EMPTY_CHAR = ' '
FULL_CHAR = '█'


def _list_to_pic(img: typing.List[int]):
    return ''.join([FULL_CHAR if x else EMPTY_CHAR for x in img])


def draw(img: typing.List[typing.List[int]]):
    for row in img:
        print(_list_to_pic(row))


def draw_flatten(img: typing.List[int], width: int, height: int):
    assert len(img) == width * height, 'Wrong dimension'
    for row in range(height):
        print(_list_to_pic(img[row * width: (row + 1) * width]))


__all__ = ['draw', 'draw_flatten']
