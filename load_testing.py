import subprocess

for i in [10, 100, 1000, 10000, 100000, 1000000, 10000000]:
    with open('load_template.afl', 'r') as f:
        lines = f.read().replace('input.tsv', '{}.tsv'.format(i))
    with open('load_testing_{}.afl'.format(i), 'w') as f:
        f.write(lines)
    out = subprocess.check_output('time iquery -n --afl --query-file load_testing_{}.afl'.format(i), shell=True)
