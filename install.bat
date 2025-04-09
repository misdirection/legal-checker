@echo off
REM -----------------------
REM Backend installieren
REM -----------------------

echo Ueberpruefe, ob Python installiert ist...
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Python ist nicht installiert. Bitte installieren Sie Python 3.7 oder hoeher.
    pause
    exit /b 1
)

echo Wechsle in das Backend-Verzeichnis...
cd backend

echo Erstelle virtuelle Umgebung fuer das Backend...
python -m venv venv
IF %ERRORLEVEL% NEQ 0 (
    echo Fehler beim Erstellen der virtuellen Umgebung im Backend.
    pause
    exit /b 1
)

echo Aktiviere die virtuelle Umgebung...
call venv\Scripts\activate

echo Aktualisiere pip und installiere Backend-Abhaengigkeiten...
python -m pip install --upgrade pip
pip install -r requirements.txt

cd ..

REM -----------------------
REM Frontend installieren
REM -----------------------

echo Wechsle in das Frontend-Verzeichnis...
cd frontend

echo Ueberpruefe, ob Node.js installiert ist...
node --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Node.js ist nicht installiert. Bitte installieren Sie Node.js.
    pause
    exit /b 1
)

echo Installiere Frontend-Abhaengigkeiten...
npm install

echo Frontend-Installation abgeschlossen.
cd ..

echo Installation von Backend und Frontend abgeschlossen.
pause

