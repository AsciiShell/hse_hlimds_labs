from .models import Model


def save_data(model: Model, program: str, verilog: str):
    weights = []
    code = None
    for n in model.net.neurons:
        w, code = n.dump_verilog()
        weights.append(w)
    weights = '\n'.join(weights)
    with open(program, 'w') as f:
        f.write(weights)
    with open(verilog, 'w') as f:
        f.write(code)
