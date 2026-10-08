# Resume o log de um passo da CI em até 10 anotações (o GitHub mostra só as 10 primeiras).
# Uso: python3 tools/ci_resumo.py arquivo.txt
import re
import sys

RUIDO = re.compile(r"first_scan|API HASH|TextServer|Using \"|udev|WorkerThread|Godot Engine v|loading_editor|^\s*$")
linhas = [l.rstrip() for l in open(sys.argv[1], errors="replace") if not RUIDO.search(l)]
linhas = linhas[-120:]
texto = " | ".join(linhas)
TAM = 900
partes = [texto[i:i + TAM] for i in range(0, len(texto), TAM)][:10]
for i, p in enumerate(partes):
    print("::error::[%d/%d] %s" % (i + 1, len(partes), p))
