<template>
  <v-app class="app-background">
    <v-main>
      <v-container class="content-container">
        <v-row justify="center" class="mt-5">
          <v-col cols="12" md="8">
            <v-card class="pa-4 header-card">
              <v-card-title class="text-h4 text-center">
                LegalCheck – Automatische Vertragsprüfung
              </v-card-title>
              <v-card-text class="text-body-1">
                Mit dieser App können Sie einen Auftragsverarbeitungsvertrag (AVV) automatisch von einem LLM (z. B.
                ChatGPT)
                prüfen lassen. Geben Sie Ihren individuellen Prompt ein und laden Sie die zu analysierende PDF-Datei
                hoch.
                Anschließend erhalten Sie eine erste rechtliche Einschätzung.
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>

        <v-row justify="center" class="mt-5">
          <v-col cols="12" md="8">
            <v-form @submit.prevent="uploadFile">
              <v-textarea v-model="prompt" label="Geben Sie Ihren Prompt ein" required outlined rows="4"
                class="custom-input"></v-textarea>
              <v-file-input v-model="file" label="Wählen Sie eine PDF-Datei aus" accept=".pdf" required outlined
                class="custom-input mt-4"></v-file-input>
              <v-btn :disabled="loading || !prompt || !file" type="submit" class="mt-4 custom-button">
                {{ loading ? "Verarbeite..." : "Upload & Analyse starten" }}
              </v-btn>
            </v-form>

            <v-card v-if="result" class="mt-4 result-card">
              <v-card-title>Rechtliche Einschätzung</v-card-title>
              <v-card-text>{{ result }}</v-card-text>
            </v-card>

            <v-alert v-if="error" type="error" class="mt-4">
              {{ error }}
            </v-alert>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import axios from "axios";

export default {
  name: "LegalCheck",
  data() {
    return {
      prompt: "",
      file: null,
      loading: false,
      result: "",
      error: ""
    };
  },
  methods: {
    async uploadFile() {
      if (!this.prompt || !this.file) {
        this.error = "Bitte geben Sie einen Prompt ein und wählen Sie eine PDF-Datei aus.";
        return;
      }
      this.loading = true;
      this.error = "";
      this.result = "";

      const formData = new FormData();
      formData.append("prompt", this.prompt);
      formData.append("file", this.file);

      try {
        // Bitte die URL an deinen Backend-Endpunkt anpassen
        const response = await axios.post(
          "http://localhost:44777/api/legalcheck/upload",
          formData,
          {
            headers: { "Content-Type": "multipart/form-data" }
          }
        );
        this.result = response.data.result;
      } catch (err) {
        if (err.response && err.response.data && err.response.data.error) {
          this.error = err.response.data.error;
        } else {
          this.error = "Ein Fehler ist aufgetreten.";
        }
      } finally {
        this.loading = false;
      }
    }
  }
};
</script>

<style>
/* Globale Farbvariablen (Passe diese Werte mit einem Farbpipetten-Tool an, falls nötig) */
:root {
  --primary-color: #0033cc;
  /* Beispiel für Blau */
  --secondary-color: #4cffc7;
  /* Beispiel für Grün */
}

/* Vollflächiger animierter Hintergrund mit CSS Art */
.app-background {
  min-height: 100vh;
  position: relative;
  overflow: hidden;
  /* Basis-Gradient als Hintergrund */
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
}

/* Pseudo-Element für ein animiertes Muster */
.app-background::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 200%;
  height: 200%;
  /* Erstelle ein Muster mit radialen Gradienten */
  background-image:
    radial-gradient(circle at 0 0, rgba(255, 255, 255, 0.2) 1px, transparent 1px),
    radial-gradient(circle at 50px 50px, rgba(255, 255, 255, 0.2) 1px, transparent 1px);
  background-size: 100px 100px;
  opacity: 0.5;
  animation: movePattern 20s linear infinite;
}

/* Animation für das Muster */
@keyframes movePattern {
  from {
    transform: translate(0, 0);
  }

  to {
    transform: translate(-100px, -100px);
  }
}

/* Container für den sichtbaren Inhalt (muss über dem Hintergrund liegen) */
.content-container {
  position: relative;
  z-index: 1;
}

/* Header-Card: Weißer Hintergrund mit primär gefärbtem Rand und Schatten */
.header-card {
  border: 2px solid var(--primary-color);
  border-radius: 12px;
  background: #fff;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

/* Custom Styles für Inputs: Hervorhebung der Ränder in den definierten Farben */
.custom-input .v-input__slot::before {
  border-color: var(--primary-color);
}

.custom-input .v-input__slot::after {
  border-color: var(--secondary-color);
}

/* Button-Styling: Farbverlauf aus Primär- und Sekundärfarbe */
.custom-button {
  background: linear-gradient(45deg, var(--primary-color) 0%, var(--secondary-color) 100%);
  color: #fff;
  font-weight: bold;
  text-transform: uppercase;
  transition: filter 0.3s ease;
}

.custom-button:hover {
  filter: brightness(1.1);
}

/* Ergebnis-Card: Linker Rand in Sekundärfarbe und Schatten */
.result-card {
  border-left: 5px solid var(--secondary-color);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
}

/* Hilfsklassen für Abstände */
.mt-4 {
  margin-top: 16px;
}

.mt-5 {
  margin-top: 32px;
}
</style>
