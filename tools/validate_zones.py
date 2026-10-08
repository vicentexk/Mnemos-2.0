#!/usr/bin/env python3
"""Valida os mapas de scripts/zones.gd sem precisar do Godot.

Checa: largura igual, um P, um N, um M por degrau; o baú (K) é alcançável
SEM o item; a porta (N) é alcançável com o item do degrau e a sala do chefe
(M) também. Uso: python3 tools/validate_zones.py
"""
import os
import re
import sys
from collections import deque

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
text = open(os.path.join(ROOT, "scripts/zones.gd"), encoding="utf-8").read()
zones = []
for bloco in re.split(r'\n\t\{', text)[1:]:
    gate = re.search(r'"gate": "([^"]*)"', bloco).group(1)
    nome = re.search(r'"name": "([^"]*)"', bloco).group(1)
    mapa_txt = bloco.split('"map": [', 1)[1].split("],", 1)[0]
    linhas = re.findall(r'"([^"]*)"', mapa_txt)
    zones.append((nome, gate, linhas))

erros = 0


def falha(msg):
    global erros
    erros += 1
    print("  FALHA:", msg)


def passavel(ch, desbloqueado):
    if ch == "#":
        return False
    if ch == "G":
        return False  # portão sem substituir: nunca deve sobrar
    if ch == "N":
        return "porta" in desbloqueado
    if ch in "~XhYEI":
        return ch in desbloqueado
    return True


def alcanca(linhas, inicio, alvo, desbloqueado):
    h, w = len(linhas), len(linhas[0])
    fila = deque([inicio])
    visto = {inicio}
    while fila:
        y, x = fila.popleft()
        if linhas[y][x] == alvo:
            return True
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            ny, nx = y + dy, x + dx
            if 0 <= ny < h and 0 <= nx < w and (ny, nx) not in visto:
                if passavel(linhas[ny][nx], desbloqueado) or linhas[ny][nx] == alvo:
                    visto.add((ny, nx))
                    fila.append((ny, nx))
    return False


def acha(linhas, ch):
    for y, l in enumerate(linhas):
        for x, c in enumerate(l):
            if c == ch:
                return (y, x)
    return None


for i, (nome, gate, linhas) in enumerate(zones):
    print("Degrau %d: %s" % (i + 1, nome))
    # Igual ao jogo: o G vira o caractere de portão do degrau
    linhas = [l.replace("G", gate or "#") for l in linhas]
    larguras = set(len(l) for l in linhas)
    if larguras != {40}:
        falha("larguras das linhas: %s (esperado 40 em todas)" % sorted(larguras))
        continue
    for ch in "PNM":
        n = sum(l.count(ch) for l in linhas)
        if n != 1:
            falha("%s aparece %d vezes (esperado 1)" % (ch, n))
    ini = acha(linhas, "P")
    if ini is None:
        continue
    # Sem item: o baú precisa ser alcançável
    if gate:
        if acha(linhas, "K") is None:
            falha("sem baú K")
        elif not alcanca(linhas, ini, "K", set()):
            falha("baú K inalcançável sem item")
        com_item = {gate}  # o caractere do portão fica passável com o item
        # A porta exige o chefe morto; para validar o caminho, libera a porta
        com_item.add("porta")
        if not alcanca(linhas, ini, "N", com_item):
            falha("porta N inalcançável com o item %s" % item)
        if not alcanca(linhas, ini, "M", com_item):
            falha("chefe M inalcançável com o item %s" % item)
        if not alcanca(linhas, ini, "K", set()):
            pass
    else:
        com_item = {"porta"}
        if not alcanca(linhas, ini, "M", com_item):
            falha("chefe M inalcançável")
        if not alcanca(linhas, ini, "N", com_item):
            falha("porta N inalcançável")
    # Recipientes e inimigos precisam estar em chão
    for ch in "eVCKM":
        pos = [(y, x) for y, l in enumerate(linhas) for x, c in enumerate(l) if c == ch]
        for y, x in pos:
            if linhas[y][x] == "#":
                falha("%s sobre parede em (%d,%d)" % (ch, x, y))

print("")
print("RESULTADO:", "OK" if erros == 0 else "%d falha(s)" % erros)
sys.exit(1 if erros else 0)
