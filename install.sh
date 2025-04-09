#!/bin/bash
set -e

echo "Pruefe, ob Python3 installiert ist..."
if ! command -v python3 &>/dev/null; then
    echo "Python3 ist nicht installiert. Bitte installieren Sie Python 3.7 oder hoeher."
    exit 1
fi

# -----------------------
# Backend installieren
# -----------------------
echo "Wechsle in das Backend-Verzeichnis..."
cd backend || { echo "Backend-Verzeichnis nicht gefunden."; exit 1; }

echo "Erstelle virtuelle Umgebung fuer das Backend..."
python3 -m venv venv

echo "Aktiviere die virtuelle Umgebung..."
source venv/bin/activate

echo "Aktualisiere pip und installiere Backend-Abhaengigkeiten..."
pip install --upgrade pip
pip install -r requirements.txt

cd ..

# -----------------------
# Frontend installieren
# -----------------------
echo "Wechsle in das Frontend-Verzeichnis..."
cd frontend || { echo "Frontend-Verzeichnis nicht gefunden."; exit 1; }

echo "Pruefe, ob Node.js installiert ist..."
if ! command -v node &>/dev/null; then
    echo "Node.js ist nicht installiert. Bitte installieren Sie Node.js."
    exit 1
fi

echo "Installiere Frontend-Abhaengigkeiten..."
npm install

echo "Installation abgeschlossen."

