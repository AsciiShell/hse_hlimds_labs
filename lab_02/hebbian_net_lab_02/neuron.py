from .consts import VECTOR, HIGH_LEVEL, LOW_LEVEL


def as_hex(num):
    if num < -128:
        raise Exception('Too small')
    if num > 127:
        raise Exception('Too large')
    if num < 0:
        num = 256 + num
    raw = hex(num)[2:]
    if len(raw) == 1:
        raw = '0' + raw
    return raw


VERILOG_TEMPLATE = '''
module neuron
(
    input [{SIZE}:0] x,
    output predict
);
    reg [{NUM_SIZE}:0] bias;
    reg [{NUM_SIZE}:0] w [{SIZE}:0];

    assign predict = ( bias + {MATRIX}) > 0;

    initial begin
		bias = {NUM_SIZE}'h{BIAS_W};
{MATRIX_DATA}
    end

endmodule
'''


class Neuron:
    def __init__(self, size: int):
        self.size = size
        self.w = [0] * size
        self.bias = 0

    def forward(self, vector: VECTOR) -> int:
        assert len(vector) == self.size, 'Unsupported vector shape'
        s = self.bias
        for w, x in zip(self.w, vector):
            s += w * x
        return HIGH_LEVEL if s > 0 else LOW_LEVEL

    def update_w(self, vector: VECTOR, target: int):
        assert len(vector) == self.size, 'Unsupported vector shape'
        self.bias += target
        for i, x in enumerate(vector):
            self.w[i] += x * target

    def dump_verilog(self):
        num_size = 8
        mat_mul = []
        for i in range(self.size):
            mat_mul.append(f"x[{i}] * w[{i}]")
        mat_mul = ' + '.join(mat_mul)
        bias = as_hex(self.bias)
        w = '\n'.join(["		w[{}] = {}'h{};".format(i, num_size, as_hex(x)) for i, x in enumerate(self.w)])
        code = VERILOG_TEMPLATE.format(SIZE=self.size - 1, NUM_SIZE=num_size - 1, MATRIX=mat_mul, BIAS_W=bias,
                                       MATRIX_DATA=w)
        return code


__all__ = ['Neuron']
