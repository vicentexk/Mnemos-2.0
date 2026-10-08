# Brief do jogo

**Atualizado:** 2026-10-08. Consolida o kit de continuidade da aventura da Névoa.

## 1. Visão

Aventura de ação, exploração e narrativa. Uma **formiga protagonista** atravessa os degraus do mundo enquanto ajuda a colônia ameaçada pela **Névoa**. A câmera e a progressão acompanham a protagonista. O combate tem profundidade pela leitura de padrões, posicionamento, terreno e habilidades; a exploração recompensa a curiosidade; a história é contada pelo mundo e pelos personagens.

- Não é point-and-click.
- Campanha artesanal e persistente. Sem roguelite, sem reset de run, sem geração procedural obrigatória, sem ondas aleatórias, sem drafts de poderes.
- Plataformas: Windows e Android.
- Identidade visual totalmente nova.
- Título e nome da protagonista: não decididos.

## 2. Decisões confirmadas

| Tema | Decisão |
|---|---|
| Premissa | Uma formiga e a colônia sob ameaça da Névoa. O nome Névoa é mantido. |
| Gênero | Ação e exploração, com controle direto. |
| Inspirações | *The Legend of Zelda* (sobretudo o primeiro e *The Minish Cap*) para itens e dungeons; *TUNIC* para segredos e pistas. Inspirar sem copiar. |
| Escopo | Jogo completo em todos os degraus da lore. Entrega em degraus jogáveis. |
| Plataformas | Windows e Android. Formato exato de pacote ainda por definir. |
| Protagonista | Começa como formiga básica e generalista. Ganha possibilidades por itens e descobertas. Espécie e visual exatos em aberto. |
| Progressão | Só a vida máxima em corações aumenta. Itens não viram atributos numéricos. |
| Ajudantes | NPCs recrutáveis. Um ativo por vez. |
| Dungeon por ajudante | Uma dungeon própria para cada ajudante, ligada à habilidade dele. Se conta como principal, opcional ou extra, ainda em aberto. |
| Dungeons principais | Uma por degrau da lore. |
| Dungeons opcionais | Cinco no total como baseline inicial, sujeito a revisão. |
| Teste | Builds instaláveis para Windows e Android. Sem preview. |
| Produção | Um degrau por vez, após planejar a campanha inteira. |

## 3. Princípios de design

1. **Item novo é nova possibilidade.** Deve habilitar uma ação legível, não apenas aumentar um número.
2. **Corações são a única progressão de atributo.** Quantidade e ritmo são decisões de balanceamento em aberto.
3. **Um ajudante ativo, sem microgerenciar esquadrão.** Troca em locais seguros, como acampamentos, a avaliar.
4. **Sem softlock.** Se uma sala exigir um ajudante, o jogador sabe antes e pode obtê-lo. Nunca bloquear a campanha por um recrutamento opcional perdido.
5. **Rota principal clara, com desvios.** Segredos ensinam o mundo sem excesso de HUD.
6. **Combate pela leitura do espaço.** Telegraphs visuais e sonoros, padrões, terreno, objetos e habilidades. Sem hordas aleatórias.
7. **Não humanoide.** Protagonista, ajudantes, inimigos e chefes preservam leitura de fauna e inseto.
8. **Mobile desde o desenho.** Toda ação tem equivalente de toque confortável.
9. **HUD minimalista.** Mostrar corações, item ou ação atual e ajudante. Mapa, inventário, diário e diálogos em telas próprias.

## 4. Estilo de jogo

### Decisões de 2026-10-08 (rodada 2)
- **Visão e câmera:** top-down, câmera seguindo a formiga (como Zelda I).
- **Estilo visual:** **8 bits retrô, no espírito do Zelda I (NES).** Pixel art. As opções de pintura e de gráfico flat foram recusadas pelo usuário.
- **Motor:** **Godot 4** (em vez de Unity). Motivos: exporta para Windows e Android, é gratuito e sem taxas, roda nos binários do GitHub que o sandbox consegue baixar, e permite compilar os builds no GitHub Actions sem licença paga. A alternativa Unity foi descartada por exigir o editor e os módulos de build fora do alcance do sandbox.
- **Idioma de texto:** português pt-BR, fonte KiwiSoda.

### Propostas de referência técnica (aguardam aprovação)
- Resolução lógica de referência: **256×224** (ou 256×240), ampliada com escala inteira e sem filtro, com barras laterais ou letterbox conforme a tela.
- Tile base de **16×16 px**; personagens e inimigos em 16×16 ou 32×32 px.
- Paleta limitada por sprite (proposta: até 3 cores + transparência, no espírito do NES). Pode ser flexibilizada para chefes.
- Animações com poucos frames (2 a 4 por ação), como no NES.
- Referências: The Legend of Zelda (NES), The Minish Cap (GBA), tratadas só como estética e estrutura, sem copiar sprites, mapas ou personagens.

## 5. Pontos em aberto

- Título do jogo, nome da protagonista e elenco.
- Espécie da protagonista.
- Número de degraus e se o degrau 7 (Pálida) é jogável.
- Ordem de recrutamento e habilidade de cada ajudante.
- Lista de itens permanentes, ordem de obtenção e usos.
- Número e ritmo de corações e recuperação de vida.
- Checkpoints, derrota e respawn, saves e viagens entre áreas.
- Controles exatos de teclado, gamepad e toque.
- Idioma: somente português ou localização.
- Diálogos só em texto ou com voz.
- Motor e linguagem do jogo (ver [ROADMAP.md](ROADMAP.md), etapa 3).
- Formato de instalador Windows, pacote Android (APK ou AAB), versões mínimas e operação offline.

## 6. Direção visual aprovada (2026-10-08)

- **Protagonista (aprovada pelo usuário):** formiga operária em pixel art, vista de cima em três quartos, corpo marrom-âmbar com destaques claros, seis patas e antenas longas. Arquivo: `assets/source/estilo_8bit/opcao_A_nes/formiga_16px.png` (original, fora do Git).
- **Cenário de referência (aprovado pelo usuário):** clareira de floresta em pixel art, com grama, caminho de pedras, troncos, cogumelos e uma árvore central. Arquivo: `assets/source/estilo_8bit/opcao_B_cenario/cenario_256.png`.
- **Ressalvas técnicas:** as duas imagens foram geradas por IA e não têm grade exata de 16 px. Antes de integrar, precisam ser normalizadas para a grade do jogo (pixel snap e paleta reduzida). O cenário está em resolução maior que os 256×224 propostos.
- **Opções recusadas:** pintura digital suave e gráfico flat (rodada anterior).
