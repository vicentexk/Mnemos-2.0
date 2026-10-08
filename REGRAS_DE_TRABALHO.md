# Regras de trabalho — Mnemos 2.0

Estas regras valem para todas as alterações deste repositório. Elas vêm do kit de continuidade da aventura e das regras do FUMIGA, adaptadas. Onde uma regra antiga do FUMIGA divergir, esta versão vence.

## 1. Escopo e direção

1. **Não é point-and-click.** A formiga é controlada diretamente, com resposta imediata, em câmera que a acompanha.
2. **Jogo do zero.** Nenhum código, arte, música, texto ou tela do FUMIGA é copiado para cá. O FUMIGA é só referência de leitura.
3. **Campanha completa, produção por degrau.** Planejar a campanha inteira em alto nível; implementar e validar **um degrau por vez**, com build instalável. Não encerrar o jogo no primeiro degrau.
4. **Progressão:** a única estatística que sobe é a **vida máxima em corações**. Itens ampliam ações (atravessar, alcançar, revelar, manipular, lutar de outra forma). Sem árvores de força, dano, velocidade ou níveis de atributo.
5. **Ajudantes:** um ajudante ativo por vez. Cada ajudante tem conteúdo próprio.
6. **Personagens não humanoides.** Formigas, insetos, aracnídeos e animais reais ou criaturas míticas não humanoides. Sem rostos humanos, mãos, postura bípede ou roupas humanas. Exceção só por pedido explícito do usuário.

## 2. Processo obrigatório a cada pedido

1. **Pesquisar** inspirações em jogos indie quando a mudança for de design ou arte. Citar fontes com link e dizer o que foi aproveitado.
2. **Perguntar** com opções objetivas (A, B, C…) quando houver mais de um caminho razoável, descrevendo o impacto de cada um. Não reabrir decisões já confirmadas em [docs/BRIEF.md](docs/BRIEF.md).
3. **Implementar** só depois da confirmação.
4. **Arte:** gerar em alta resolução, mostrar **pelo menos duas opções** para escolha e integrar apenas a aprovada. Guardar o original aprovado no repositório (ou em `assets/source/` quando for pesado, conforme a seção 6).
5. **Mostrar** toda arte gerada ao usuário, no tamanho de uso e no contexto de jogo. Descrição em texto não conta como entrega.
6. **Mobile:** todo controle novo precisa de equivalente de toque, com alvos de pelo menos 44 pt reais. Ações de teclado ou gamepad não podem ficar sem equivalente no Android.
7. **Verificar:** checklist de conferência do que foi pedido, com status (feito, parcial, pendente) e motivo quando não estiver feito.
8. **Testar** em build ou em ambiente real (Windows e Android). Distinguir sempre:
   - **proposto**: recomendado, ainda não aprovado;
   - **implementado**: código escrito;
   - **testado**: verificado em build ou dispositivo.
9. **Documentar** a mudança em [docs/ROADMAP.md](docs/ROADMAP.md) e nos documentos afetados.

## 3. Preview e testes

- **Não iniciar servidor de preview** e não pedir que o usuário teste no navegador. O teste é por build instalável.
- Testes automatizados são bem-vindos e devem rodar localmente, sem expor porta pública.

## 4. Git e GitHub

- Trabalhar **somente** na branch da sessão (`arena/30d8e357-mnemos-2-0`).
- **Não criar PR, fazer merge, publicar release ou fazer push** sem pedido explícito do usuário.
- Não versionar binários de build, saves, arquivos de teste exportados ou originais pesados (ver seção 6).

## 5. Qualidade e otimização

- Sem dependências desnecessárias. Preferir o que já existe no ambiente.
- Sem arquivos duplicados ou temporários (nada de `versao2`, `backup`, `teste123`).
- Remover código morto e assets órfãos ao refatorar.
- Desempenho é entrega: buscar 60 FPS no PC e fluidez no Android de referência, definido na etapa de base jogável.

## 6. Arquivos pesados e originais

- Arquivos de trabalho e de alta resolução ficam em `assets/source/`. Essa pasta é ignorada pelo Git, mas deve permanecer no workspace do Arena.
- Arquivos aprovados e que o jogo carrega ficam em `assets/` (versionados, otimizados).
- Toda arte e música aprovada precisa ter o original preservado no workspace, para não ser refeita do zero depois.

## 7. Áudio e texto

- Música e efeitos **originais** ou licenciados corretamente. Nunca imitar ou copiar trilhas de *Zelda* ou *TUNIC*.
- Todo texto de jogo em português (pt-BR). Localização só se o usuário pedir.
- Caracteres fora da fonte KiwiSoda precisam de tratamento explícito (fallback testado ou reformulação).

## 8. Créditos e licenças

- Cada recurso de terceiro entra em [docs/LICENCAS_E_CREDITOS.md](docs/LICENCAS_E_CREDITOS.md) com origem, licença e obrigação de crédito, **antes** de ser usado.
- Recurso sem licença verificada não entra no jogo.
