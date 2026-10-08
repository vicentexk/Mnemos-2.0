# Produção: como rodar, testar e gerar builds

## Estado atual (2026-10-08)

- Campanha de 7 degraus implementada em GDScript (Godot 4.4.1): título/continuar, mapas, baús com item-chave, portões, chefes, ajudante único, corações, diálogos e final.
- Mapas validados por `tools/validate_zones.py` (alcance com os itens de cada degrau).
- **Não testado no motor ainda.** A sandbox não consegue baixar o Godot nem os export templates. A primeira execução real acontece no GitHub Actions (`.github/workflows/godot.yml`).
- Builds Windows e Android: pendentes do `export_presets.cfg` e dos segredos de assinatura (keystore) no GitHub.

## Rodar no computador (Godot 4.4.1)

1. Abrir a pasta do projeto no Godot 4.4.1 (aba Projeto > Importar, arquivo `project.godot`).
2. Apertar F5. WASD ou setas movem; J ou Z ataca; K, X ou Espaço esquiva; E ou Enter fala e avança diálogo.
3. Teste de fumaça: `godot --headless --path . --script res://tests/smoke_test.gd`.

## Mapas

- Os mapas dos degraus são gerados por `tools/build_maps.py`, que escreve `scripts/zones.gd`. Não editar os mapas à mão: a largura de cada linha precisa ser 40.
- Depois de mudar um mapa: `python3 tools/build_maps.py` e `python3 tools/validate_zones.py`.

## Sprites

- Placeholders: `python3 tools/make_sprites.py` (Pillow). Lista em [SPRITES.md](SPRITES.md).
- Originais pesados ficam em `assets/source/` (ignorada pelo Git).

## Builds (quando o export_presets.cfg existir)

- Windows: export template do Godot 4.4.1, saída em `release/` (ignorada pelo Git).
- Android: Android SDK, export template e keystore guardado como segredo do GitHub. Nunca versionar keystore ou senhas.
- Toque: os botões têm 44 px lógicos (alvo mínimo de 44 pt), em `scripts/touch.gd`.

## Pendências

- Título oficial e nome da protagonista (hoje "MNEMOS 2.0" como placeholder).
- Dungeons opcionais (baseline de 5) e dungeons de ajudante.
- Formato final de pacote.
