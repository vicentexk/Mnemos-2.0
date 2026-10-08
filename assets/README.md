# Assets

| Pasta | Conteúdo | Versionada no Git |
|---|---|---|
| `fonts/` | Fontes usadas pelo jogo, com crédito em [../docs/LICENCAS_E_CREDITOS.md](../docs/LICENCAS_E_CREDITOS.md) | Sim |
| `source/` | Originais de alta resolução, arquivos de trabalho e pastas de estudo de arte | **Não** (ignorada pelo `.gitignore`), mas deve permanecer no workspace |

Pastas de sprites, música e som serão criadas quando o estilo visual e o primeiro degrau forem aprovados. Ver a lista completa em [../docs/INVENTARIO_ASSETS.md](../docs/INVENTARIO_ASSETS.md).

Regras:
- Arquivo aprovado entra em `assets/` já otimizado para o uso (tamanho e formato corretos).
- Original aprovado fica em `assets/source/` (ou no workspace) antes de qualquer otimização.
- Nenhum binário de build vai para o Git.
