# Auditoria inicial — FUMIGA como referência para a nova aventura

- **Data:** 2026-10-08
- **Repositório de trabalho (destino proposto):** `vicentexk/Mnemos-2.0`, branch `arena/30d8e357-mnemos-2-0`
- **Repositório de referência (somente leitura):** `vicentexk/Fumiga-GOAT`, branch `arena/ad8884de-fumiga-goat` (HEAD `2959e61`)
- **Status:** diagnóstico. **Nenhum código foi escrito, nenhum asset copiado e nenhum commit/PR foi feito.** Aguardando a escolha do destino (opção A ou B abaixo).

> Legenda: **lido** = aberto e revisado nesta auditoria · **verificado** = conferido por comando/teste de estrutura · **proposto** = recomendação, não aprovada.

---

## 1. Repositórios e instruções lidos

### Mnemos-2.0 (estado atual, verificado)
- Branch `main` e a branch da sessão: ambas contêm apenas `LICENSE` (MIT, Vicente_XK), em um único commit `Initial commit`. Nenhum código de jogo.

### Fumiga-GOAT (lido)
- **Pasta `nova aventura/`** (kit de continuidade, 2026-10-08):
  - `00_LEIA_ME.md`, `01_BRIEF_DO_JOGO.md`, `02_PLANO_DE_PRODUCAO.md`, `03_REGRAS_E_MIGRACAO.md`, `04_PROMPT_NOVA_SESSAO.md`
  - `KIT_NOVA_AVENTURA.zip` — **verificado:** os 5 arquivos do ZIP são idênticos aos soltos.
  - `referencias_fumiga/` — cópias de `AGENTS`, `REGRAS_DE_TRABALHO`, `LORE` e direção anterior (`DIRECAO_ANTERIOR_FUMIGA.md` é idêntica a `DOCUMENTO_DIRECAO_NOVA_AVENTURA.md`).
- **Regras vigentes do FUMIGA:** `REGRAS_DE_TRABALHO.md` (Regras 1–14) e `AGENTS.md` (mapa técnico, receitas, armadilhas, CI e saves).
- **Lore:** `LORE.md` (prólogo, 11 povos, 6 degraus, Pálida, final e apêndice de modo infinito).
- **Documentos de design:** `README.md`, `game/README.md`, `installers/README.md`, `installers/THIRD_PARTY_NOTICES.md`, `DOCUMENTO_*.md`, `PENDENCIAS.md`, `PLAYTEST.md`, `PROXIMOS_PASSOS_DA_ARVORE.md`, `MEGA_ARQUIVO.md` (317 KB; só o índice e trechos, conforme o próprio AGENTS pede).
- **Código e configuração:** `package.json`, `.gitignore`, `.github/workflows/*.yml`, lista completa de `game/js/` (~19,3 mil linhas, 36 módulos), `game/mobile/`, `game/test/` (≈40 testes), `tools/`, `installers/` (Electron + Android/GeckoView), `sw.js`, `app/`.
- **Limite honesto:** não li linha a linha as ~19 mil linhas de JS nem os ~1.400 arquivos de arte. Esta auditoria cobre a documentação completa e a arquitetura; o mapeamento fino de cada módulo fica para a fase de migração, se a opção A for escolhida.

---

## 2. Diagnóstico de reaproveitamento e licença

### O que é o FUMIGA hoje
- Roguelite de colônia de formigas, **JavaScript puro com módulos ES, Canvas 2D 960×540, sem build e sem dependências de runtime** (só `playwright` em dev).
- Duas versões paralelas sobre o mesmo motor: PC (`game/`) e mobile de toque (`game/mobile/`), com saves separados.
- Pacotes nativos: **Windows** (Electron + NSIS) e **Android** (APK com GeckoView, ARM64/ARMv7, offline).
- PWA com `sw.js` e download offline de ~24,8 MB.
- Testes headless (`node game/test/run-all.mjs`) e de navegador (`npm run inspect*`), e CI em `.github/workflows/testes.yml` e `pacotes-nativos.yml` (este último dispara no push da branch `arena/01a0fc42-fumiga-goat`, não na sua).

### Classificação proposta

| Categoria | Itens | Recomendação |
|---|---|---|
| **Infraestrutura candidata a reaproveitar** | Empacotamento Windows (Electron/NSIS) e Android (GeckoView) com lista de assets; pipeline de testes headless; `tools/make_assets_list.mjs`; `ui.js`/`font.js` (primitivos de canvas); `audio.js` (áudio procedural); `input.js`; `camera.js`; `playtest.js` (diário local) | **Proposto:** portar só após leitura detalhada e validação. |
| **Gameplay que precisa ser reescrita** | `game.js`, `units.js`, `brain.js`, `waves.js`, `enemies.js`, `mutations.js`, `meta.js` (árvore), `world.js` (geração procedural), `fog.js`, `combat.js`, `config.js` (dados de castas e mapas) | **Proposto:** não aproveitar; o loop é de comando indireto e o novo é controle direto com mapas feitos à mão. |
| **Conteúdo que não deve ser importado automaticamente** | Toda arte (`animais/`, `arvores/`, `arbustos/`, `cristais/`, `pedras/`, `icones*/`, `game/assets/`), a Noite Branca, a fonte, textos e a lore | **Proposto:** não importar. A identidade visual será nova (decisão do usuário). |

### Licenças — pontos que precisam de verificação antes de qualquer reuso
- O `LICENSE` do FUMIGA é **MIT** (© 2026 FeufeuP). Isso cobre o **código**, mas **não garante** a licença de arte, música ou fonte.
- **Arte:** os sprites de animais (`animais/animais/...`) e árvores/arbustos parecem vir de um pack de terceiros, mas o repositório **não documenta origem nem licença**. Tratar como não licenciado para reuso até confirmar.
- **Fonte KiwiSoda** (`fonte/kiwisoda/KiwiSoda.ttf`): **não há arquivo de licença no repositório**. Verificar antes de usar.
- **Áudio:** é procedural (WebAudio), então não há faixas de terceiros aparentes; confirmar em `audio.js`.
- **GeckoView (MPL-2.0)** e **Electron/Chromium** são dependências dos pacotes nativos: se forem reaproveitados, é preciso manter os avisos de `installers/THIRD_PARTY_NOTICES.md`.

### Investigação de licenças (feita em 2026-10-08, a pedido do usuário)

Esta seção registra o que foi encontrado publicamente. Nada foi copiado.

| Recurso | Onde aparece no FUMIGA | Origem documentada | Licença encontrada | Situação |
|---|---|---|---|---|
| **Fonte KiwiSoda** | `fonte/kiwisoda/KiwiSoda.ttf`, `game/assets/font/` | Autor *jeti* (fontenddev.com) | **CC BY 4.0** — uso comercial permitido com **crédito obrigatório** ([fontenddev.com](https://fontenddev.com/fonts/kiwi-soda/); [blogfonts.com](https://blogfonts.com/kiwisoda.font)). Um agregador cita OFL ([deefont.com](https://www.deefont.com/kiwi-soda-font/)), mas o próprio autor diz CC BY — **prevalece o do autor** | Pode ser usada no Mnemos com crédito; confirmar a versão do TTF do repo |
| **Growing Plants** (Soppycraft) | Mencionado no `MEGA_ARQUIVO.md` como base das flores | Soppycraft (itch.io) | Uso pessoal e comercial permitido; **sem revenda nem redistribuição**, mesmo modificado; atribuição apreciada, não obrigatória ([itch.io](https://soppycraft.itch.io/growing-plants-pixel-pack)) | Sprites modificados ainda estão sob esses termos. Não redistribuir os arquivos |
| **Mystic Flora** (Tayziulei) | Mencionado no `MEGA_ARQUIVO.md` | Tayziulei Studio (itch.io) | Uso pessoal e comercial permitido; crédito apreciado, não obrigatório ([itch.io](https://tayziulei.itch.io/mystic-flora-pixel-plant-flower-pack)) | Mesma regra: não redistribuir |
| **Pixel Crops & Plants, Pixelwood Valley, Rustic Wood UI, packs de insetos do itch.io** | Citados no `MEGA_ARQUIVO.md` | Não confirmados (só nomes) | **Não verificado** | Não usar sem localizar o pack e a licença |
| **Animais** (`animais/`) e **árvores/arbustos** (`arvores/`, `arbustos/`) | Sprites de bichos, árvores e arbustos | **Não documentada.** Adicionados por "Add files via upload" em 2026-09-14 | **Desconhecida** | Tratar como **não licenciado** para reuso |
| **Imagens de inspiração** (`Imagens inspiração/`) | 4 PNGs de referência | Não documentada | Desconhecida | Só como referência visual, não como asset |

**Conclusões:**
1. **Código MIT** do FUMIGA pode ser reaproveitado com o aviso de copyright preservado.
2. **Fonte KiwiSoda** é a única que pode ser reaproveitada sem problema conhecido, desde que haja crédito ao autor *jeti*.
3. **Packs do itch.io** permitem uso comercial, mas **não** permitem redistribuir os arquivos. Para o Mnemos, o uso correto é como arte própria ou com licença comprada, não como cópia dos sprites.
4. **Sprites de animais, árvores e arbustos** não têm origem comprovada. Como a identidade visual será nova, a recomendação é **não reutilizar**.
5. **Arte gerada/criada no próprio projeto** (commits como "feat(art): sprites Dead Cells" e "gera sprites reais"): o histórico não documenta a ferramenta nem a licença. Tratar como não licenciado até o autor confirmar.

---

## 3. Opções de destino

### Opção A — Mnemos como destino (recomendada pelo kit)
- **Como:** Mnemos recebe o jogo novo do zero e aproveita, por cópia seletiva e revisada, somente a infraestrutura listada acima. FUMIGA fica apenas como leitura.
- **Vantagens:** mantém a decisão anterior; separa a identidade nova do código antigo; evita herdar o roguelite, as regras de preview e a árvore de upgrades.
- **Riscos:** custo maior para portar a infraestrutura; é preciso decidir de que forma o código será trazido (cópia com licença preservada ou reescrita).
- **Custo:** médio–alto no início, baixo depois.

### Opção B — FUMIGA como destino
- **Como:** transformar o próprio `Fumiga-GOAT` na aventura, substituindo o gameplay.
- **Vantagens:** a infraestrutura já está pronta e testada; não há porte.
- **Riscos:** muda a decisão anterior do usuário; o nome, a árvore, os saves antigos e as regras de CI (`pacotes-nativos`, `testes`) ficam ligados a um jogo que deixa de existir; o histórico mistura dois produtos.
- **Custo:** baixo para começar, alto para limpar e reconstruir sem arrastar o antigo.

**Recomendação (proposta):** **A**, mantendo o FUMIGA como referência de leitura.

---

## 4. Mapa de alto nível (referência, não aprovado)

Os itens abaixo vêm da lore e da direção antiga. **Nenhum nome está aprovado como conteúdo novo** (brief, seção 4).

| Degrau | Área (referência FUMIGA) | Chefe (referência FUMIGA) | Observação |
|---|---|---|---|
| 1 | Planície do Amanhecer | O Tamborilador | Direção antiga propunha só este capítulo; brief substitui por campanha completa |
| 2 | Floresta de Musgo | A Caçadora Astuta | — |
| 3 | Pântano Pútrido | A Sombra Alada | — |
| 4 | Deserto Calcinado | A Matriarca Rival | — |
| 5 | Bosque Dourado | O Galhada Real | — |
| 6 | Pico Congelado | O Devastador | — |
| 7 | Topo do mundo | A Pálida (Névoa-Mãe) | Ficha técnica existe na lore; é "para implementação futura" |

- **Ajudantes candidatos** (direção antiga, não aprovados): Tecelã (primeira candidata para a Planície), Matabele, Cortadeira, Prata.
- **Dungeons:** uma principal por degrau (≈ 6 a 7, a confirmar), **cinco opcionais no total como baseline**, e uma dungeon própria por ajudante (ainda não decidido se conta nas anteriores ou se são vagas extras).
- **Inconsistência a registrar:** `DIRECAO_ANTERIOR` fala em "seis capítulos/biomas", o brief fala em "todos os degraus". O kit diz que a Pálida fica como degrau 7 na lore, mas o brief não a menciona como degrau jogável; precisa confirmar.

---

## 5. Primeiro marco proposto (Windows + Android)

Conforme `02_PLANO_DE_PRODUCAO.md`, Etapas 0 a 4, com a regra do usuário de **sem preview ao vivo** e **identidade visual nova**:

1. **Etapa 0 (agora):** esta auditoria. Confirmar o destino (A ou B).
2. **Etapa 1:** bíblia da campanha (degraus, ajudantes, itens, matriz de dungeons) aprovada pelo usuário.
3. **Etapa 2:** apresentar opções de identidade visual (2 ou mais) e aguardar a escolha antes de qualquer sprite.
4. **Etapa 3:** base jogável mínima: movimento e colisão da formiga, câmera, interação, um item com efeito de ação, dano/corações, diálogo curto, salvamento, controles de teclado/gamepad **e** toque.
5. **Etapa 4:** primeiro degrau vertical completo (começo → progressão → chefe → conclusão), com build Windows (instalador) e Android (APK) para download e teste do usuário.

**Critério de aceite:** instalar, iniciar, entender os controles, concluir o percurso principal e salvar nas duas plataformas.

**Pré-requisitos técnicos a confirmar:** runtime Windows (Electron ou outro), formato Android (APK sideload ou AAB), versão mínima de Android, e se o jogo precisa ser offline (o FUMIGA é).

---

## 6. Regras vigentes e conflitos com o kit

| Regra do FUMIGA | Situação no novo projeto |
|---|---|
| Regra 7 — abrir preview após toda tarefa | **Sobrescrita:** sem preview; entregar builds instaláveis (decisão do usuário). |
| Regra 6 — pixel art 8-bit / paleta violeta-âmbar | **Sobrescrita:** identidade visual totalmente nova. |
| Regra 8 — personagens não humanoides | **Mantida** (está no brief). |
| Regra 9 — toda mudança precisa de equivalente mobile | **Mantida** (princípio 8 do brief). |
| Regra 11 — "salvar no GitHub" = criar PR e fazer merge juntos | **Não se aplica sem pedido explícito** (kit, seção 5). |
| Regra 12 — atualizar `MEGA_ARQUIVO.md` | **Adaptar:** o Mnemos não tem esse arquivo; usar documentação própria do novo projeto. |
| Regra 14 — tela de carregamento só na troca de mundo | **Avaliar** quando houver mundo para trocar. |
| Regra 1 — perguntar antes de implementar, com opções | **Mantida.** |
| Regra 2 — pesquisar inspirações indies | **Mantida**, mas o kit já fixou Zelda I, Minish Cap e TUNIC. |

**Divergência no kit:** o `04_PROMPT_NOVA_SESSAO.md` manda ler `KIT_CONTINUIDADE_MNEMOS_2.zip`, mas o arquivo real se chama `KIT_NOVA_AVENTURA.zip`. Não afeta o conteúdo.

---

## 7. Decisões pendentes para o usuário

1. **Destino de escrita:** A (Mnemos, com FUMIGA só como leitura) ou B (FUMIGA como destino)?
2. **Porte de infraestrutura:** copiar código do FUMIGA (com aviso MIT preservado) ou reescrever inspirando-se nele?
3. **Plataforma de runtime:** manter o mesmo modelo (Electron para Windows e GeckoView para Android), ou escolher outro?
4. **Título e nome da protagonista:** ainda não decididos.
5. **Número de degraus e se a Pálida é jogável** (degrau 7).
6. **Dungeons dos ajudantes:** contam nas principais, nas cinco opcionais, ou são vagas extras?
7. **Licenças:** autorizar a verificação da origem dos sprites de terceiros e da fonte KiwiSoda antes de qualquer reuso.

---

## 8. Estado após esta auditoria

- **Feito:** leitura da documentação e das regras, verificação do kit, diagnóstico de arquitetura e licenças, esta síntese.
- **Não feito:** nenhum código; nenhuma arte; nenhum asset copiado; nenhum commit, push, PR ou merge; nenhum servidor iniciado.
