# Lista de sprites e animações (para revisão e arte final)

**Status:** proposta para revisão. Atualizada em 2026-10-08. Os sprites atuais são **placeholders** gerados por `tools/make_sprites.py` (mais o monólito, gerado à parte). Nomes de biomas, chefes e ajudantes são **provisórios**.

## Regras de arte (8 bits)

- **Pixel art sem anti-aliasing.** PNG com transparência, filtro *nearest*, sem meio pixel (o jogo oscila em pixel inteiro).
- **Paleta limitada:** até 16 cores por personagem ou sprite; até 32 cores por atlas de cenário (um bioma por atlas).
- **Tamanhos:** personagens, inimigos, ajudantes e itens em **16×16**; chefes em **32×32**; tiles em **16×16**; ilustrações da cutscene em **320×180**.
- **Animação:** cada entidade anda, para ou ataca com quadros próprios. Sem a arte final, o jogo usa um balanço provisório de 1 pixel. **Toda animação listada abaixo é necessária.**
- **Formato dos quadros:** tiras horizontais (sprite sheet), um quadro após o outro, tamanho fixo por sheet. Uma linha por direção quando a entidade tem direção.
- **Direções:** cima, baixo e lado. O lado esquerdo é o espelhamento do direito (salvo se a arte pedir o contrário).
- **Personagens não humanoides:** formigas, insetos e criaturas, nunca rostos humanos (regra 6 de REGRAS_DE_TRABALHO).

Prioridade: **P1** = necessário para o primeiro trecho jogável (formigueiro, degrau 1, monólito, fuga). **P2** = demais degraus, chefes e ajudantes.

## 1. Protagonista (formiga operária)

| Arquivo (proposto) | Tamanho | Quadros | Animações | Prioridade | Estado |
|---|---|---|---|---|---|
| `player/ant_player_sheet.png` | 16×16 | 40 | parado (2×3 dir), andar (4×3), atacar (3×3), esquivar (2), levar dano (2), capturada pela Névoa (4), pegar item (3), falar (2) | P1 | existe 1 quadro (placeholder) |

## 2. Ajudantes (uma habilidade por formiga, um ativo por vez)

Cada ajudante tem sheet própria. Habilidade é ação, nunca estatística.

| Ajudante | Habilidade | Quadros | Animações | Prioridade | Estado |
|---|---|---|---|---|---|
| Tecelã | ponte de seda | 22 | parado (2×3), andar (4×3), tecer (3), entrar no grupo (2) | P1 | existe 1 quadro |
| Matabele | golpe que quebra rocha | 22 | parado (2×3), andar (4×3), golpe (3), entrar no grupo (2) | P2 | existe 1 quadro |
| Cortadeira | corta folhagem | 22 | parado (2×3), andar (4×3), cortar (3), entrar no grupo (2) | P2 | existe 1 quadro |
| Prata | faro (revela trilha) | 22 | parado (2×3), andar (4×3), farejar (3), entrar no grupo (2) | P2 | existe 1 quadro |
| Bala | investida e salto | 22 | parado (2×3), andar (4×3), investir (3), entrar no grupo (2) | P2 | existe 1 quadro |
| Cefalote | escudo frontal | 22 | parado (2×3), andar (4×3), erguer escudo (2), empurrar (2), entrar no grupo (2) | P2 | existe 1 quadro |

Extra para o recrutamento: 2 quadros de **ajudante no formigueiro/NPC** (parado). Pode reusar a sheet do ajudante.

## 3. Inimigos comuns (uma família por degrau/bioma)

Sete variantes, uma por bioma (16×16). Cada uma tem a mesma lista de animações, para o jogador ler o aviso.

| Sheet | Quadros | Animações | Prioridade | Estado |
|---|---|---|---|---|
| `enemies/enemy_z0_sheet.png` … `enemy_z6_sheet.png` (7 sheets) | 13 cada | parado (2), andar (4), aviso (2, fica em amarelo/vermelho), bote (2), morrer (3) | P1 para z0; P2 demais | existem 7 quadros (placeholder) |

## 4. Chefes (um por degrau, mais a Pálida)

Sprite 32×32. A fase 2 (abaixo de 50 % de vida) precisa de troca visual.

| Sheet | Quadros | Animações | Prioridade | Estado |
|---|---|---|---|---|
| `bosses/boss_z0_sheet.png` (Tamborilador, provisório) | 19 | parado (2), aviso (3), investida (2), recuperar (2), fase 2 (2), levar dano (1), morrer (4), teleportar (3) | P1 | existe 1 quadro |
| `bosses/boss_z1…z5_sheet.png` | 19 cada | mesma lista | P2 | existem 1 quadro cada |
| `bosses/boss_z6_sheet.png` (Pálida, translúcida) | 19 | mesma lista, mais transparência variável | P2 | existe 1 quadro |

## 5. Objetos e interação

| Sheet | Tamanho | Quadros | Animações | Prioridade | Estado |
|---|---|---|---|---|---|
| `items/monolith_sheet.png` (monólito de save) | 16×16 | 3 | apagado (1), aceso (2, o cristal pulsa) | P1 | apagado e aceso prontos (placeholder) |
| `items/chest_sheet.png` (baú) | 16×16 | 3 | fechado (1), abrindo (1), aberto (1) | P1 | existem fechado e aberto |
| `items/heart_container_sheet.png` | 16×16 | 4 | parado (1), brilho ao coletar (3) | P1 | existe 1 quadro |
| `items/key_*.png` (6 itens-chave: seda, mandíbula, faro, salto, escalada, garras) | 16×16 | 2 cada | parado (1), brilho (1) | P1 seda; P2 demais | faltam |
| `items/npc_*` | — | — | ver seção 2 | — | — |

## 6. Cenário: tiles por bioma

Atlas de tiles por bioma, 16×16 cada. Lista base (todos os biomas precisam dela, com cor própria):

- chão: grama, caminho de terra, chão de pedra, areia, gelo aberto, terra vermelha, água;
- paredes e bloqueios: parede, parede rachada, penhasco, parede de gelo, rocha, arbusto, raízes;
- passagens e portões: porta fechada e aberta, portão de terreno em cada tipo (seda, mandíbula, faro, salto, escalada, garras), **ponte**, **teia**, **espinhos**, **pedra quebrável**, **folhagem cortável**;
- abismo e fosso: abismo, fosso de duna.

| Bioma (provisório) | Tiles | Animados | Prioridade | Estado |
|---|---|---|---|---|
| 1. Planície do Amanhecer | 22 | água (4 quadros) | P1 | atlas com 14 tiles (placeholder) |
| 2. Duna | 22 | areia (2 quadros) | P2 | falta |
| 3. Samambaias | 22 | folhagem (2 quadros) | P2 | falta |
| 4. Névoa | 22 | névoa (4 quadros) | P1 (fuga) | falta |
| 5. Gelo | 22 | gelo (2 quadros) | P2 | falta |
| 6. Terra vermelha | 22 | — | P2 | falta |
| 7. Pálida (alto da montanha) | 22 | névoa (4) | P2 | falta |

## 7. Formigueiro (centro do mundo)

| Sheet | Tamanho | Quadros | Animações | Prioridade | Estado |
|---|---|---|---|---|---|
| `hub/formigueiro_entrada.png` | 32×32 | 2 | parado (1), movimento de formigas na entrada (2) | P1 | falta |
| `hub/formigueiro_tiles.png` | 16×16 | 8 | chão batido, borda, buraco, marco de pedra | P1 | falta |

## 8. Fx (efeitos)

| Sheet | Tamanho | Quadros | Animações | Prioridade | Estado |
|---|---|---|---|---|---|
| `fx/projectile_sheet.png` (esporo/bruma) | 6×6 | 3 | voar (3) | P2 | existe 1 quadro |
| `fx/hit_sheet.png` (impacto) | 16×16 | 3 | impacto (3) | P1 | falta |
| `fx/slash_sheet.png` (ataque) | 16×16 | 3 | corte (3), por direção | P1 | falta |
| `fx/dust_sheet.png` (poeira ao andar/esquivar) | 8×8 | 3 | poeira (3) | P1 | falta |
| `fx/fog_particle_sheet.png` (névoa) | 16×16 | 4 | nuvem (4) | P1 | falta |
| `fx/save_sheet.png` (brilho ao salvar) | 16×16 | 4 | brilho (4) | P1 | falta |
| `fx/pickup_sheet.png` (coleta de item) | 16×16 | 4 | brilho (4) | P1 | falta |

## 9. Interface (HUD e toque)

| Arquivo | Tamanho | Quadros | Animações | Prioridade | Estado |
|---|---|---|---|---|---|
| `ui/heart_full.png`, `heart_half.png`, `heart_empty.png` | 8×8 | 3 | — (meio coração falta) | P1 | cheio e vazio existem; meio falta |
| `ui/touch_*.png` (botões de toque: setas, ataque, esquiva, falar) | 44×44 (mínimo de 44 pt) | 2 (normal e pressionado) | pressionar (2) | P1 | falta |
| `ui/dialog_frame.png` | 16×16 (9 partes) | 9 | — | P1 | falta |
| `ui/title_logo.png` | 160×48 | 1 | pisca (2 quadros) | P2 | falta (título provisório) |
| `ui/cursor.png` (seleção no menu) | 8×8 | 2 | pisca (2) | P1 | falta |
| `ui/app_icon_128.png` | 128×128 | 1 | — | P2 | existe (rascunho) |

## 10. Cutscene inicial

| Arquivo | Tamanho | Quadros | Observação | Prioridade | Estado |
|---|---|---|---|---|---|
| `cutscene/cena_01.png` … `cena_06.png` | 320×180 | 6 ilustrações | uma por texto da cutscene (montanha, névoa, colônia, formiga, companheiras, formigueiro) | P1 | faltam (hoje há só texto na tela) |

## Resumo

- **Total de quadros P1 (primeiro trecho):** protagonista 40, tecelã 22, inimigo z0 13, chefe z0 19, monólito 3, baú 3, coração 4, tiles do degrau 1 (22 + névoa), formigueiro 10, fx 19, interface, 6 cenas de cutscene.
- **Total de quadros P2:** 5 ajudantes (110), 6 inimigos (78), 7 chefes ajustados (133), 6 biomas de tiles (132), 6 itens-chave, UI extra e fx extra.
- **Dúvidas para o usuário:** tamanho de 16×16 é suficiente para os ajudantes? Quer chefes em 32×32 ou 48×48?
