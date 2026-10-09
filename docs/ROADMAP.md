# Roadmap de produção

**Atualizado:** 2026-10-08. Legenda de status: ✅ concluído · 🟡 em andamento · ⬜ pendente · ⛔ bloqueado por decisão do usuário.

## Etapa 0 — Reconhecimento e preparação

| Item | Status |
|---|---|
| Auditoria do FUMIGA como referência | ✅ ([AUDITORIA_FUMIGA_REFERENCIA.md](AUDITORIA_FUMIGA_REFERENCIA.md)) |
| Destino de escrita confirmado: Mnemos | ✅ |
| Estratégia de porte: reescrita inspirada no FUMIGA | ✅ |
| Investigação de licenças | ✅ ([LICENCAS_E_CREDITOS.md](LICENCAS_E_CREDITOS.md)) |
| Estrutura inicial do repositório (regras, brief, roadmap, inventário) | ✅ |
| Fonte KiwiSoda incluída com crédito | ✅ (`assets/fonts/`) |

## Etapa 1 — Bíblia da campanha

| Item | Status |
|---|---|
| Degraus da lore, com mapa e objetivo de cada um | 🟡 rascunho em [CAMPANHA.md](CAMPANHA.md) |
| Elenco de ajudantes, habilidades e ordem de recrutamento | ⛔ aguarda o usuário |
| Lista de itens permanentes e usos | ⛔ aguarda o usuário |
| Matriz de dungeons (principais, ajudantes, opcionais) | 🟡 rascunho; ⛔ regra de contagem a confirmar |
| Princípios de controles, corações, checkpoints e saves | ⬜ |

## Etapa 2 — Identidade visual e estilo de jogo

| Item | Status |
|---|---|
| Opções de estilo visual (no mínimo duas) | ⬜ |
| Escolha de visão e câmera | ⬜ |
| Guia de estilo: paleta, escala, legibilidade mobile, animação | ⬜ |
| Protótipo pequeno: formiga, cenário e interface | ⬜ depois da escolha |

## Etapa 3 — Base jogável (Windows e Android)

| Item | Status |
|---|---|
| Escolha de motor: **Godot 4** (decidido em 2026-10-08; Unity descartado por não ser buildável no sandbox) | ✅ |
| Estilo visual: 8 bits retrô tipo Zelda I; formiga e cenário de referência aprovados | ✅ (normalização para grade pendente) |
| Movimento e colisão da formiga | 🟡 escrito; aguarda teste no motor (CI) |
| Câmera e transições | 🟡 câmera segue a formiga; transição simples entre degraus |
| Interação contextual | 🟡 baús, corações, ajudantes e portas |
| Um item com efeito de ação | 🟡 itens como portões de terreno (7 degraus) |
| Combate básico com telegraph | 🟡 inimigos e chefes com aviso antes do ataque |
| Corações: dano, cura e morte | 🟡 morte volta ao início do degrau |
| Diálogo curto e objetivo visível | 🟡 diálogos por degrau |
| Salvamento | 🟡 `user://save_mnemos.json` |
| Controles de teclado e toque | 🟡 teclado pronto; toque com botões de 44 px a confirmar no motor |
| Build de teste Windows e Android | ⬜ falta export_presets.cfg e templates no CI |

## Etapa 4 — Primeiro degrau completo

Status: 🟡 os 7 degraus foram escritos de uma vez (pedido do usuário); validação no motor pendente. Ver [PRODUCAO.md](PRODUCAO.md).

Conteúdo, critério de aceite e lista de recursos: ver [CAMPANHA.md](CAMPANHA.md) e [INVENTARIO_ASSETS.md](INVENTARIO_ASSETS.md).

## Etapa 5 — Próximos degraus

Repetir a etapa 4 para cada degrau. Manter o registro de itens, segredos e arcos de ajudantes para que a progressão não contradiga o que já foi feito.

## Etapa 6 — Conteúdo opcional e acabamento

Dungeons opcionais, acessibilidade, saves, balanceamento, desempenho no Android, créditos e integridade das builds.

## Etapa 7 — Rodada 2: mundo aberto, combate e segredos (em andamento)

Decisões confirmadas em 2026-10-08 (pelo usuário):

| Item | Decisão | Status |
|---|---|---|
| Mundo | Mundo aberto único, estilo Zelda I; 7 degraus viram regiões | ⬜ a implementar |
| Dungeons | 1 principal por degrau (obrigatória para subir); 5 opcionais; 1 por ajudante | ⬜ |
| Ajudantes | Uma habilidade por ajudante, um ativo por vez; ordem de recrutamento livre | ✅ aprovado ([AJUDANTES_PROPOSTA.md](AJUDANTES_PROPOSTA.md)) |
| Fuga da Névoa | Começa ao cair a dungeon principal; velocidade cresce por degrau; captura volta ao último monólito | 🟡 implementada (aguarda teste); números a balancear |
| Formigueiro (centro do mundo) | Mapa central com entradas para os degraus | ⬜ próximo passo |
| Habilidades dos ajudantes no mundo | Tecelã ponte, Matabele rocha, Cortadeira folhagem, Prata faro, Bala salto, Cefalote escudo | ⬜ não implementado |
| Dungeons (principal, 5 opcionais, de ajudante) | Conteúdo e mapas | ⬜ não implementado |
| Polimento do combate | Esquiva, empurrão, avisos | ⬜ não implementado |
| Animações de quadros e sprites novos | Ver [SPRITES.md](SPRITES.md) | ⬜ só balanço provisório |
| Combate | Polir combate contra inimigos e chefes (esquiva, empurrão, feedback, avisos) | ⬜ |
| Visual | Imagem sem desfoque: escala inteira do Godot | 🟡 implementado (aguarda teste) |
| Visual | Cor própria por degrau (provisória) | 🟡 implementado (aguarda teste) |
| Fonte | Deltarune Regular (link do usuário), uso provisório | ⬜ falta baixar o arquivo; ver [LICENCAS_E_CREDITOS.md](LICENCAS_E_CREDITOS.md) |
| Segredos | Mapa com segredos, pistas e itens escondidos | ⬜ |
