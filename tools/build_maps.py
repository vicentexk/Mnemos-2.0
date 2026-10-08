#!/usr/bin/env python3
"""Gera os mapas (40x18) de scripts/zones.gd a partir de uma estrutura fixa.

Estrutura: borda de parede; portão de 3 colunas (x=19..21) para os degraus 1-6;
sala do chefe à direita (x=27..37) com o chefe M e a porta N em (38,8).
Só os elementos (P, K, C, V, e, obstáculos) mudam por degrau.
Depois de gerar, rode tools/validate_zones.py.
"""
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ZONES_PATH = os.path.join(ROOT, "scripts/zones.gd")
W, H = 40, 18
GATE_X = (19, 20, 21)

# Elementos por degrau: P (início), K (baú), C (ajudante), V (coração), M (chefe),
# e (inimigos), obst (paredes internas). Coordenadas (x, y).
SPEC = [
    dict(gate=True, P=(3, 8), K=(3, 2), C=(6, 9), V=(12, 5), M=(31, 8),
         e=[(8, 5), (14, 11), (16, 3), (10, 14), (25, 3), (34, 14)],
         obst=[(10, 3), (6, 12), (7, 12), (15, 6), (24, 13), (34, 4)]),
    dict(gate=True, P=(3, 5), K=(2, 2), C=(4, 9), V=(14, 13), M=(31, 8),
         e=[(5, 4), (15, 7), (12, 10), (9, 15), (26, 3), (33, 13)],
         obst=[(6, 3), (13, 4), (23, 12), (30, 3), (34, 14)]),
    dict(gate=True, P=(3, 4), K=(2, 2), C=(3, 7), V=(7, 5), M=(31, 8),
         e=[(8, 2), (14, 3), (9, 11), (12, 13), (25, 4), (30, 13)],
         obst=[(11, 9), (23, 2), (24, 9), (35, 3)]),
    dict(gate=True, P=(3, 4), K=(2, 2), C=(3, 6), V=(14, 5), M=(31, 8),
         e=[(9, 3), (15, 8), (6, 14), (13, 13), (33, 3), (27, 14)],
         obst=[(8, 7), (16, 10), (24, 4), (28, 14)]),
    dict(gate=True, P=(3, 4), K=(2, 2), C=(3, 6), V=(14, 5), M=(31, 8),
         e=[(7, 3), (12, 9), (14, 14), (16, 12), (26, 4), (33, 14)],
         obst=[(8, 10), (16, 7), (23, 9), (34, 4)]),
    dict(gate=True, P=(3, 4), K=(2, 2), C=(3, 6), V=(14, 5), M=(31, 8),
         e=[(9, 3), (14, 9), (7, 13), (15, 14), (26, 4), (30, 14)],
         obst=[(10, 10), (16, 4), (23, 13), (34, 4)]),
    dict(gate=False, P=(3, 8), K=None, C=None, V=(12, 5), M=(31, 8),
         e=[(8, 3), (15, 14), (25, 3), (33, 13)],
         obst=[(10, 11), (20, 3)]),
]


def build(s):
    c = [["." for _ in range(W)] for _ in range(H)]
    for x in range(W):
        c[0][x] = "#"
        c[H - 1][x] = "#"
    for y in range(H):
        c[y][0] = "#"
        c[y][W - 1] = "#"
    if s["gate"]:
        for y in range(1, H - 1):
            for x in GATE_X:
                c[y][x] = "G"
    for y in range(6, 11):
        for x in range(27, 38):
            c[y][x] = "_"
    for x, y in s["obst"]:
        c[y][x] = "#"
    for x, y in s["e"]:
        c[y][x] = "e"
    for k in ("K", "C", "V"):
        if s.get(k):
            x, y = s[k]
            c[y][x] = k
    x, y = s["P"]
    c[y][x] = "P"
    x, y = s["M"]
    c[y][x] = "M"
    c[8][38] = "N"
    return ["".join(r) for r in c]


def main():
    texto = open(ZONES_PATH, encoding="utf-8").read()
    blocos = re.findall(r'"map": \[\n(.*?)\n\t\t\],', texto, flags=re.S)
    assert len(blocos) == len(SPEC), "numero de mapas diferente de SPEC"
    novo = texto
    for bloco, s in zip(blocos, SPEC):
        linhas = build(s)
        corpo = "\n".join('\t\t\t"%s",' % l for l in linhas)
        novo = novo.replace(bloco, corpo, 1)
    open(ZONES_PATH, "w", encoding="utf-8").write(novo)
    print("mapas gerados:", len(SPEC))


if __name__ == "__main__":
    main()
