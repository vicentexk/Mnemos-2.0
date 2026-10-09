# Resume o log de um passo da CI em anotações (o GitHub mostra só as primeiras linhas de um passo).
# Uso: python3 tools/ci_resumo.py arquivo.txt
import re
import sys

RUIDO = re.compile(r"first_scan|API HASH|TextServer|udev|WorkerThread|Godot Engine v|Loading resource")
linhas = [l.rstrip() for l in open(sys.argv[1], errors="replace") if l.strip() and not RUIDO.search(l)]
texto = " | ".join(linhas)[-8000:]
for i in range(0, len(texto), 900):
    print("::error::" + texto[i:i + 900])
