# Inventário de recursos

**Atualizado:** 2026-10-08.

Este inventário mostra **tudo o que o jogo vai precisar**, feito à mão, do zero. As quantidades são **estimativas provisórias**: elas dependem do estilo visual escolhido, da campanha aprovada e do orçamento. Não produzir tudo de uma vez: cada item entra no primeiro degrau que o usar.

Legenda de prioridade: **D1** = necessário no primeiro degrau · **D2+** = a partir do segundo degrau · **OPC** = conteúdo opcional.

Nenhum item está aprovado em estilo. Toda arte passa por opções (ver [REGRAS_DE_TRABALHO.md](../REGRAS_DE_TRABALHO.md), seção 2).

---

## 1. Sprites e animações

### 1.1 Protagonista (formiga)
| Recurso | Prioridade | Observação |
|---|---|---|
| Vistas e direções (mínimo 4, ideal 8) | D1 | Define a leitura do movimento |
| Parada (idle), andar, correr | D1 | |
| Ataque rápido (mandíbula) | D1 | Com frames de aviso e de acerto |
| Ataque forte ou carregado | D1 | Se o estilo de combate pedir |
| Esquiva e reposicionamento | D1 | |
| Dano, recuperação, morte | D1 | |
| Interação, empurrar, carregar e soltar objetos | D1 | |
| Uso de cada família de item | D1 para o item do D1 · D2+ para os demais | |
| Vitória, derrota e descanso | D1 | |
| Silhueta legível em fundo claro e escuro e em tela pequena | D1 | Teste obrigatório |

### 1.2 Ajudantes (cada um)
| Recurso | Prioridade |
|---|---|
| Retrato ou ícone para diálogo e HUD | D1 se o ajudante aparecer no D1 |
| Parada, andar e seguir a protagonista | D1 / D2+ |
| Ação própria da habilidade | Um por ajudante |
| Reação, dano e derrota | Um por ajudante |

### 1.3 NPCs e colônia
- Rainha, colônia, acampamentos e personagens de lore: parados, poucas animações.
- Gestos de conversa e indicação de missão (ícone sobre a cabeça ou marcador).
- **Pendente:** número de NPCs de cada degrau.

### 1.4 Inimigos (por degrau)
| Recurso | Prioridade |
|---|---|
| Parado, alerta, andar, ataque com telegraph, dano, derrota | D1: 2 a 3 tipos · D2+: 3 a 5 por degrau |
| Variantes de cor ou tamanho para diferenciar | Quando necessário |
| Criaturas passivas ou ambientais | Se a campanha pedir |

### 1.5 Chefes (um por degrau)
| Recurso | Prioridade |
|---|---|
| Silhueta marcante e leitura de ataques | D1 (chefe do D1) |
| Ataques com telegraph (cada um com frames de aviso) | D1 |
| Fase 2 (mudança visual ou de padrão) | D1 se o chefe tiver fases |
| Introdução, derrota e saída | D1 |

### 1.6 Mundo e cenário (por degrau)
- **Tileset** de chão, bordas, transições e camadas de profundidade. **D1:** um tileset completo.
- **Props** de vegetação, pedras, detritos, fungos e gotas, conforme o bioma.
- **Obstáculos:** raízes, troncos, muros, água ou névoa, conforme o degrau.
- **Plano de fundo** (distante e médio), se o estilo pedir parallax.
- **Objetos interativos:** portas, alavancas, interruptores, baús, chaves, pontes, plataformas, mecanismos de puzzle.
- **Pontos de salvamento** e **atalhos** (visual claro).
- **Dungeon principal:** identidade visual própria, paredes, portas, salas e chefe.

### 1.7 Itens e pickups
- **Item do D1** e seu sprite no mundo, na mão da formiga e no inventário.
- **Corações:** recipiente e fragmento (sprite, estados cheio, parcial e vazio).
- **Outros itens** de cada degrau (D2+), e **colecionáveis** (notas, pistas, sementes).
- **Ícones de inventário e de equipamento**, com descrição.

### 1.8 Efeitos visuais (FX)
- Acerto, bloqueio, esquiva, poeira, impacto no chão.
- Telegraph de inimigo e de chefe (deve ser legível).
- Habilidade de ajudante, puzzle resolvido, porta destrancada, recompensa e cura.
- Névoa: partículas e poças.
- Obtenção de item, recipiente de coração e vida baixa.

### 1.9 Interface (HUD e telas)
| Recurso | Prioridade |
|---|---|
| HUD minimalista: corações, item ou ação atual, ajudante | D1 |
| Ícones de ações de toque (atacar, interagir, esquivar, item) | D1 |
| Mapa do degrau e ponto da formiga | D1 se houver mapa; senão D2+ |
| Diário e pistas | D1 mínimo |
| Menu principal, pausa, opções, salvar, créditos | D1 |
| Caixa de diálogo, retrato e nome do falante | D1 |
| Telas de morte e de conclusão do degrau | D1 |
| Cursor e foco para gamepad e teclado | D1 |
| Ícones de controle (teclado e gamepad) | D1 |
| Ícone do app e capa | D1 para o build de teste |

### 1.10 Cutscenes e arte narrativa
- Imagens de cutscene em camadas (para parallax) ou cenas completas, conforme o estilo.
- Retratos de personagens para diálogo.
- Arte de título.
- **Pendente:** quantas cenas por degrau.

---

## 2. Música

As faixas devem ser **originais** ou licenciadas corretamente. Nunca imitar trilhas de *Zelda* ou *TUNIC*. Sem trilha pronta como base até a licença estar verificada.

| Faixa | Prioridade | Observação |
|---|---|---|
| Título e tema de abertura | D1 | |
| Tema calmo da colônia ou acampamento | D1 | Loop curto |
| Exploração do degrau 1 | D1 | Com camadas para perigo e descoberta |
| Combate comum | D1 | Intensidade variável |
| Chefe do degrau 1 (com fase 2) | D1 | |
| Dungeon principal do degrau 1 | D1 | |
| Tema de ajudante (recrutamento) | D1 se houver ajudante no D1 | |
| Vitória do degrau, derrota, pausa | D1 | Derrota curta |
| Cada degrau seguinte: exploração, combate, chefe, dungeon | D2+ | 4 faixas por degrau |
| Dungeons opcionais (5 no baseline) | OPC | Pode reutilizar motivos próprios |
| Tema da Pálida e final | D2+ | |
| Créditos | D1 para o build de teste | |

**Estimativa provisória:** 3 a 4 faixas no D1; cerca de 25 a 30 faixas e variações no jogo completo. A quantidade real depende da campanha e do orçamento.

---

## 3. Efeitos sonoros e ambiências

| Grupo | Prioridade |
|---|---|
| **Movimento:** passos por material (solo, folha, raiz, água, pedra), pouso, empurrar e arrastar | D1 (3 a 4 materiais) |
| **Combate:** ataque, acerto, bloqueio, esquiva, dano na formiga, morte | D1 |
| **Inimigos:** alerta, telegraph, ataque, impacto, derrota | D1 |
| **Chefe:** introdução, telegraph, mudança de fase, vulnerabilidade, derrota | D1 |
| **Item:** pegar, usar, falhar, desbloquear | D1 |
| **Coração:** coleta de fragmento e recipiente, cura, vida baixa (alerta) | D1 |
| **Interação:** porta, alavanca, baú, chave, puzzle resolvido | D1 |
| **Ajudante:** recrutamento, troca, habilidade | D1 se houver ajudante |
| **Diálogo:** blips de voz ou texto, conforme a decisão de voz | D1 |
| **UI:** navegação, seleção, confirmação, erro, pausa, mapa | D1 |
| **Ambiências por degrau:** vento, folhas, água, insetos, ruínas | Um conjunto por degrau |
| **Névoa:** camada sonora de presença, aplicada com parcimônia | D2+ (e uma primeira versão no D1, se a Névoa aparecer) |

---

## 4. Textos e narrativa

| Recurso | Prioridade |
|---|---|
| Textos de menus, opções, controles, acessibilidade, pausa, créditos | D1 |
| Tutorial de movimento, combate, item, corações; versão para toque e para teclado | D1 |
| Diálogos principais do degrau 1 (abertura, recrutamento, final) | D1 |
| Conversas opcionais de NPCs e callbacks | D1 mínimo |
| Diário, objetivos e descrições de itens | D1 |
| Pistas ambientais, placas e inscrições | D1 (poucas) |
| Textos de chefe (introdução e derrota) | D1 |
| Diálogos e textos dos degraus 2 a 7 | D2+ |
| Localização (além do português) | Pendente, só se o usuário pedir |
| Dublagem ou voz para diálogos | Pendente (decisão em aberto) |

**Regras de texto:** português pt-BR; IDs estáveis para cada string (facilita localização e revisão); caracteres fora da fonte KiwiSoda precisam de tratamento explícito.

---

## 5. Fonte

| Recurso | Status |
|---|---|
| **KiwiSoda** (`assets/fonts/KiwiSoda.ttf`) | ✅ incluída; crédito obrigatório (ver [LICENCAS_E_CREDITOS.md](LICENCAS_E_CREDITOS.md)) |
| Fonte de texto longo (diálogos extensos), se a KiwiSoda não for legível em tamanho pequeno | Pendente, só se necessário |

---

## 6. Dados e ferramentas

- Mapa da campanha e grafo de rotas entre degraus.
- Dados de cada degrau: salas, checkpoints, requisitos de item e ajudante.
- Itens e suas ações, corações e recuperação de vida.
- Ajudantes: habilidade, dungeon e ordem de recrutamento.
- Inimigos e chefes: vida, padrões de ataque, telegraphs.
- Sistema de save com versão e migração.
- Testes automatizados de progressão e ausência de softlock.
- Pipeline para montar e identificar builds de teste (Windows e Android).

---

## 7. Plataformas e pacotes

| Item | Status |
|---|---|
| Ícone do app, Windows e Android | D1 para build de teste |
| Capturas e material de divulgação | Pendente |
| Pacote Windows (instalador) | Formato a definir |
| Pacote Android (APK ou AAB) e versão mínima | Formato a definir |
| Assinatura de release | Pendente; sem publicação sem pedido explícito |

---

## 8. Resumo da primeira entrega (degrau 1)

Estimativa para o primeiro degrau jogável, sujeita a revisão na Etapa 1:

- **Protagonista:** conjunto completo de animações básicas e de combate, em direções mínimas.
- **Mundo:** um tileset, cerca de 10 a 20 props, um conjunto de obstáculos e uma dungeon principal com identidade própria.
- **Inimigos:** 2 a 3 tipos, com estados de alerta, ataque e derrota.
- **Chefe:** 1, com fase 2.
- **Ajudante:** 0 a 1, conforme decisão do elenco.
- **Itens:** 1 item principal e corações.
- **Interface:** HUD, menus, diálogo, tutorial e telas de conclusão.
- **Música:** 3 a 4 faixas.
- **Sons:** conjunto D1 da seção 3.
- **Textos:** diálogos do degrau 1 e tutorial.
