# Produção: como rodar, testar e gerar builds

## Estado atual (2026-10-08)

- Campanha de 7 degraus implementada em GDScript (Godot 4.4.1): título/continuar, mapas, baús com item-chave, portões, chefes, ajudante único, corações, diálogos e final.
- Mapas validados por `tools/validate_zones.py` (alcance com os itens de cada degrau).
- Teste de fumaça (`tests/smoke_test.tscn`) passa na CI. As builds ainda não foram jogadas: o teste de jogo é manual.
- Builds Windows e Android: geradas pela CI do GitHub (`.github/workflows/godot.yml`) a cada push. Ver "Baixar as builds" abaixo.

## Baixar as builds (para testar)

1. Abrir a aba **Actions** do repositório no GitHub e escolher a execução mais recente da branch `arena/30d8e357-mnemos-2-0`.
2. Na parte de baixo da página, em **Artifacts**, baixar:
   - `Mnemos2-windows` (zip com `Mnemos2.exe`): descompactar e abrir o exe.
   - `Mnemos2-android-apk` (`Mnemos2-android.apk`): copiar para o celular e instalar. Pode ser preciso permitir instalação de fonte desconhecida.
3. A APK é **assinada com uma chave de teste gerada a cada execução**. Por isso, uma build nova não instala por cima de outra: desinstale a anterior antes.
4. Os artefatos ficam disponíveis pelo tempo de retenção padrão do GitHub. Não são uma release.

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
