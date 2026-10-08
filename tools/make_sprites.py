#!/usr/bin/env python3
"""Gera os sprites de PLACEHOLDER do Mnemos 2.0.

- A formiga do jogador sai da imagem aprovada (assets/source/estilo_8bit/opcao_A_nes),
  reduzida para a grade de 16x16 px por amostragem e votação de cor.
- Os demais sprites são desenhados por código (cores e formas simples).
- Tudo isto é TEMPORÁRIO: será substituído por sprites feitos à mão.

Uso (precisa de Pillow):
    python3 -m venv /tmp/venv && /tmp/venv/bin/pip install pillow
    /tmp/venv/bin/python tools/make_sprites.py
Gera assets/sprites/** e docs/SPRITES.md.
"""
import json
import math
import os
import random
from collections import Counter

from PIL import Image, ImageDraw

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "assets/source/estilo_8bit/opcao_A_nes/formiga_16px.png")
OUT = os.path.join(ROOT, "assets/sprites")
MANIFEST = []


def save(img, rel, uso, obs=""):
    path = os.path.join(OUT, rel)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.save(path)
    MANIFEST.append({
        "arquivo": "assets/sprites/" + rel,
        "tamanho": "%dx%d" % (img.width, img.height),
        "uso": uso,
        "obs": obs,
    })


def close(a, b, tol=40):
    return sum(abs(a[i] - b[i]) for i in range(3)) < tol


def load_ant16():
    """Reduz a formiga aprovada (grade 32x32) para 16x16."""
    src = Image.open(SRC).convert("RGBA")
    bg = src.getpixel((5, 5))
    cell = src.width // 32
    g32 = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    for gy in range(32):
        for gx in range(32):
            px = src.getpixel((gx * cell + cell // 2, gy * cell + cell // 2))
            if close(px, bg):
                continue
            g32.putpixel((gx, gy), px)
    g16 = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    for y in range(16):
        for x in range(16):
            votos = Counter()
            for dy in (0, 1):
                for dx in (0, 1):
                    votos[g32.getpixel((x * 2 + dx, y * 2 + dy))] += 1
            cor, n = votos.most_common(1)[0]
            if cor[3] == 0 and votos[(0, 0, 0, 0)] < 2:
                cor = next((c for c in votos if c[3] > 0), cor)
                n = 2
            if cor[3] > 0 and n >= 1:
                g16.putpixel((x, y), cor)
    return g16


def recolor(img, base):
    """Troca a família marrom pela cor base, mantendo sombras e luzes."""
    out = img.copy()
    px = out.load()
    for y in range(out.height):
        for x in range(out.width):
            r, g, b, a = px[x, y]
            if a == 0:
                continue
            if r > g >= b and r - b > 35 and r > 90:
                fator = ((r + g + b) / 3.0) / 110.0
                px[x, y] = (min(255, int(base[0] * fator)),
                            min(255, int(base[1] * fator)),
                            min(255, int(base[2] * fator)), a)
    return out


def beetle(cor):
    img = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    for lado in (-1, 1):
        for k in range(3):
            y = 6 + k * 2
            d.line([(8, y), (8 + lado * 5, y - 1)], fill=(20, 20, 20, 255))
    d.ellipse([3, 3, 12, 13], fill=cor + (255,), outline=(20, 16, 24, 255))
    d.ellipse([5, 1, 10, 6], fill=cor + (255,), outline=(20, 16, 24, 255))
    d.point([(6, 3), (9, 3)], fill=(255, 255, 255, 255))
    return img


def heart(size, cheio, borda=(20, 8, 16, 255)):
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    px = img.load()
    for y in range(size):
        for x in range(size):
            u = (x + 0.5) / size * 2.6 - 1.3
            v = -((y + 0.5) / size * 2.6 - 1.3)
            if (u * u + v * v - 1) ** 3 - u * u * v ** 3 <= 0:
                px[x, y] = (220, 40, 60, 255) if cheio else (70, 40, 55, 255)
    for y in range(size):
        for x in range(size):
            if px[x, y][3] == 0:
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < size and 0 <= ny < size and px[nx, ny][3] > 0:
                        px[x, y] = borda
                        break
    return img


def tile_noise(cor, pintas, seed, forma=None):
    rnd = random.Random(seed)
    img = Image.new("RGBA", (16, 16), cor + (255,))
    px = img.load()
    for _ in range(26):
        x, y = rnd.randrange(16), rnd.randrange(16)
        px[x, y] = pintas[rnd.randrange(len(pintas))] + (255,)
    if forma:
        forma(ImageDraw.Draw(img))
    return img


def tiles_atlas():
    """Atlas com 14 tiles de 16x16, na ordem usada por world.gd."""
    def bush(d):
        d.ellipse([1, 1, 14, 14], fill=(34, 82, 36, 255), outline=(16, 40, 20, 255))
        d.ellipse([4, 4, 9, 9], fill=(60, 120, 56, 255))

    def water(d):
        for y in (4, 10):
            d.line([(2, y), (6, y - 1), (10, y), (14, y - 1)], fill=(90, 130, 200, 255))

    def cracked(d):
        d.line([(3, 2), (7, 8), (5, 14)], fill=(50, 44, 40, 255))
        d.line([(7, 8), (12, 6)], fill=(50, 44, 40, 255))

    def pit(d):
        d.ellipse([3, 4, 12, 12], fill=(110, 80, 48, 255))

    def cliff(d):
        d.line([(0, 5), (15, 5)], fill=(140, 130, 124, 255))
        d.line([(0, 11), (15, 11)], fill=(60, 54, 52, 255))

    def ice_wall(d):
        d.line([(4, 3), (8, 9), (6, 14)], fill=(70, 130, 160, 255))

    def door(d):
        d.rectangle([3, 2, 12, 14], fill=(110, 76, 46, 255), outline=(50, 30, 20, 255))
        d.rectangle([7, 7, 9, 9], fill=(230, 190, 60, 255))

    def door_open(d):
        d.rectangle([3, 2, 12, 14], fill=(60, 40, 26, 255), outline=(40, 24, 16, 255))

    def stone_lines(d):
        d.line([(0, 8), (15, 8)], fill=(110, 100, 120, 255))
        d.line([(8, 0), (8, 7)], fill=(110, 100, 120, 255))

    def steps(d):
        d.line([(0, 4), (15, 4)], fill=(150, 140, 130, 255))
        d.line([(0, 10), (15, 10)], fill=(150, 140, 130, 255))

    specs = [
        ((88, 140, 60), [(70, 120, 50), (110, 160, 80)], None),        # 0 grama
        ((196, 160, 104), [(170, 135, 85), (214, 186, 130)], None),     # 1 caminho
        ((34, 82, 36), [(20, 50, 24), (60, 120, 56)], bush),            # 2 parede (arbusto)
        ((30, 50, 110), [(60, 90, 160), (40, 70, 140)], water),         # 3 abismo
        ((120, 110, 100), [(96, 88, 80), (150, 140, 130)], cracked),    # 4 parede rachada
        ((210, 180, 100), [(190, 160, 84), (226, 200, 130)], pit),      # 5 duna (fosso)
        ((95, 85, 80), [(80, 72, 68), (120, 110, 104)], cliff),         # 6 penhasco
        ((170, 220, 240), [(200, 236, 250), (150, 200, 226)], None),    # 7 gelo (aberto)
        ((90, 60, 40), [(70, 46, 30), (120, 84, 56)], door),            # 8 porta fechada
        ((150, 140, 160), [(130, 120, 140), (170, 160, 180)], stone_lines),  # 9 chão de pedra
        ((225, 200, 130), [(206, 180, 110), (240, 218, 150)], None),    # 10 areia (aberta)
        ((120, 190, 220), [(90, 160, 196), (150, 214, 236)], ice_wall), # 11 gelo (parede)
        ((150, 120, 80), [(120, 96, 60), (176, 146, 100)], door_open),  # 12 porta aberta
        ((150, 140, 128), [(124, 116, 106), (170, 160, 150)], steps),   # 13 degraus de pedra
    ]
    atlas = Image.new("RGBA", (16 * len(specs), 16), (0, 0, 0, 0))
    for i, (cor, pintas, forma) in enumerate(specs):
        atlas.paste(tile_noise(cor, pintas, 100 + i, forma), (16 * i, 0))
    return atlas


def chest(aberto):
    img = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rectangle([2, 6, 13, 13], fill=(140, 86, 40, 255), outline=(40, 22, 10, 255))
    if aberto:
        d.rectangle([2, 2, 13, 6], fill=(110, 66, 30, 255), outline=(40, 22, 10, 255))
        d.rectangle([4, 7, 11, 8], fill=(40, 20, 10, 255))
    else:
        d.rectangle([2, 4, 13, 6], fill=(170, 110, 56, 255), outline=(40, 22, 10, 255))
        d.rectangle([7, 6, 8, 9], fill=(240, 200, 70, 255))
    return img


def main():
    ant = load_ant16()
    save(ant, "player/ant_player.png", "Protagonista (formiga) em jogo", "Reduzida da formiga aprovada")

    ally_cores = {
        "tecela": (220, 220, 232),
        "matabele": (60, 60, 70),
        "cortadeira": (96, 150, 60),
        "prata": (176, 186, 196),
        "bala": (150, 40, 40),
        "cefalote": (50, 120, 120),
    }
    for nome, cor in ally_cores.items():
        save(recolor(ant, cor), "allies/ally_%s.png" % nome, "Ajudante %s" % nome,
             "Recolorida da protagonista; comportamento genérico")

    inimigo_cores = [(120, 60, 150), (150, 70, 40), (60, 90, 140), (180, 150, 50),
                     (150, 50, 50), (80, 120, 60), (110, 110, 120)]
    for i, cor in enumerate(inimigo_cores):
        save(beetle(cor), "enemies/enemy_z%d.png" % i, "Inimigo comum da fase %d" % (i + 1),
             "Besouro desenhado por código")

    boss_cores = [(200, 120, 40), (150, 90, 60), (70, 60, 120), (170, 60, 60),
                  (190, 150, 60), (80, 150, 170), (240, 240, 255)]
    for i, cor in enumerate(boss_cores):
        grande = ant.resize((32, 32), Image.NEAREST)
        if i < 6:
            img = recolor(grande, cor)
        else:
            img = recolor(grande, cor)
            px = img.load()
            for y in range(32):
                for x in range(32):
                    r, g, b, a = px[x, y]
                    if a:
                        px[x, y] = (r, g, b, 170)
        save(img, "bosses/boss_z%d.png" % i, "Chefe da fase %d" % (i + 1),
             "Placeholder ampliado da formiga; a Pálida é translúcida" if i == 6 else "Placeholder ampliado")

    save(tiles_atlas(), "tiles/tiles.png", "Atlas de 14 tiles 16x16 (ordem em world.gd)",
         "0 grama,1 caminho,2 parede,3 abismo,4 parede rachada,5 fosso de duna,6 penhasco,"
         "7 gelo aberto,8 porta fechada,9 chão de pedra,10 areia aberta,11 parede de gelo,"
         "12 porta aberta,13 degraus de pedra")

    save(chest(False), "items/chest_closed.png", "Baú com item", "Placeholder")
    save(chest(True), "items/chest_open.png", "Baú aberto", "Placeholder")
    save(heart(16, True), "items/heart_container.png", "Recipiente de coração (aumenta a vida máxima)",
         "Placeholder")
    save(heart(8, True), "ui/heart_full.png", "HUD: coração cheio", "Placeholder")
    save(heart(8, False), "ui/heart_empty.png", "HUD: coração vazio", "Placeholder")

    proj = Image.new("RGBA", (6, 6), (0, 0, 0, 0))
    d = ImageDraw.Draw(proj)
    d.ellipse([0, 0, 5, 5], fill=(255, 120, 60, 255), outline=(120, 30, 10, 255))
    d.point((2, 2), fill=(255, 255, 220, 255))
    save(proj, "fx/projectile.png", "Projétil de chefe (esporo/bruma)", "Placeholder")

    icon = ant.resize((128, 128), Image.NEAREST)
    save(icon, "ui/app_icon_128.png", "Ícone do app (rascunho)", "Placeholder")

    with open(os.path.join(ROOT, "docs/SPRITES.json"), "w", encoding="utf-8") as f:
        json.dump(MANIFEST, f, ensure_ascii=False, indent=2)
    print("sprites gerados: %d" % len(MANIFEST))


if __name__ == "__main__":
    main()
