<template>
  <v-container class="content-container">
    <!-- Header mit Überschrift und Erklärung -->
    <v-row justify="center" class="mt-5">
      <v-col cols="12" md="8">
        <v-card class="pa-4 header-card">
          <v-card-title class="text-h4 text-center">
            LegalCheck – Automatische Vertragsprüfung
          </v-card-title>
          <v-card-text class="text-body-1">
            Mit dieser App können Sie einen Auftragsverarbeitungsvertrag (AVV) automatisch von einem
            LLM prüfen lassen. Geben Sie einen individuellen Prompt ein und laden Sie die zu
            analysierende PDF-Datei hoch. Anschließend erhalten Sie eine erste rechtliche
            Einschätzung.
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Upload-Formular -->
    <v-row justify="center" class="mt-5">
      <v-col cols="12" md="8">
        <v-form @submit.prevent="uploadFile">
          <v-textarea
            v-model="prompt"
            label="Geben Sie Ihren Prompt ein"
            required
            outlined
            rows="4"
            class="custom-input"
          ></v-textarea>

          <!-- Button, um einen Standard-Prompt in das Textfeld zu setzen -->
          <v-btn color="secondary" class="mt-2" @click="setStandardPrompt">
            Standard Prompt einfügen
          </v-btn>

          <v-file-input
            v-model="file"
            label="Wählen Sie eine PDF-Datei aus"
            accept=".pdf"
            required
            outlined
            class="custom-input mt-4"
          ></v-file-input>
          <v-btn :disabled="loading || !prompt || !file" type="submit" class="mt-4 custom-button">
            {{ loading ? 'Verarbeite...' : 'Upload & Analyse starten' }}
          </v-btn>
        </v-form>

        <!-- Ergebnisanzeige -->
        <v-card v-if="result" class="mt-4 result-card">
          <v-card-title>Rechtliche Einschätzung</v-card-title>
          <v-card-text>{{ result }}</v-card-text>
        </v-card>

        <!-- Fehlermeldung -->
        <v-alert v-if="error" type="error" class="mt-4">
          {{ error }}
        </v-alert>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from 'axios'

export default {
  name: 'LegalCheck',
  data() {
    return {
      prompt: '',
      file: null,
      loading: false,
      result: '',
      error: '',
    }
  },
  methods: {
    // Methode, um den Standard-Prompt in das Textfeld zu laden
    setStandardPrompt() {
      this.prompt = `Bitte prüfen Sie den folgenden Auftragsverarbeitungsvertrag (AVV) rechtlich gemäß den aktuellen DSGVO-Richtlinien. Erstellen Sie als Antwort eine detaillierte rechtliche Einschätzung sowie, falls erforderlich, eine Maßnahmen-Checkliste zur Risikominimierung.`
    },
    async uploadFile() {
      if (!this.prompt || !this.file) {
        this.error = 'Bitte geben Sie einen Prompt ein und wählen Sie eine PDF-Datei aus.'
        return
      }
      this.loading = true
      this.error = ''
      this.result = ''

      const formData = new FormData()
      formData.append('prompt', this.prompt)
      formData.append('file', this.file)

      try {
        // Passe die URL an deinen Backend-Endpunkt an
        const response = await axios.post(
          'http://localhost:44777/api/legalcheck/upload',
          formData,
          {
            headers: { 'Content-Type': 'multipart/form-data' },
          },
        )
        this.result = response.data.result
      } catch (err) {
        if (err.response && err.response.data && err.response.data.error) {
          this.error = err.response.data.error
        } else {
          this.error = 'Ein Fehler ist aufgetreten.'
        }
      } finally {
        this.loading = false
      }
    },
  },
}
</script>

<style scoped>
/* Abstände */
.mt-2 {
  margin-top: 8px;
}
.mt-4 {
  margin-top: 16px;
}
.mt-5 {
  margin-top: 32px;
}

/* Beispielhafte Styles, die du weiter anpassen kannst */
.header-card {
  border: 2px solid var(--primary-color, #0033cc);
  border-radius: 12px;
  background: #fff;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}
.custom-button {
  font-weight: bold;
  text-transform: uppercase;
}
</style>
