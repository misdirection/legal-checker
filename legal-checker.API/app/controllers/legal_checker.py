from blacksheep import json, Response, FromFiles
from blacksheep.server.controllers import Controller, post
from typing import Optional
import PyPDF2
import io
from google import genai


API_KEY = "1234"


class LegalCheckerController(Controller):
    @classmethod
    def route(cls) -> Optional[str]:
        return "/api/legalcheck"

    @classmethod
    def class_name(cls) -> str:
        return "LegalChecker"

    @post("/upload")
    async def upload_pdf(self, request, files: FromFiles) -> Response:
        form = await request.form()
        file_field = form.get("file")
        user_prompt = form.get("prompt")

        if isinstance(file_field, list) and len(file_field) > 0:
            uploaded_file = file_field[0]
        else:
            uploaded_file = file_field

        if not uploaded_file:
            return json({"error": "Bitte eine PDF-Datei hochladen."}, status=400)

        file_name = uploaded_file.file_name.decode("utf-8")
        content_type = uploaded_file.content_type
        file_bytes = uploaded_file.data  # statt uploaded_file.read()

        if not (file_name and file_name.lower().endswith(".pdf")):
            return json({"error": "Bitte eine PDF-Datei hochladen."}, status=400)
        if not user_prompt:
            return json({"error": "Bitte einen Prompt bereitstellen."}, status=400)

        pdf_content = extract_text_from_pdf(file_bytes)

        combined_prompt = f"{user_prompt}\n\n{pdf_content}"

        try:
            llm_result = call_llm_api(combined_prompt)
        except Exception as e:
            return json({"error": str(e)}, status=500)

        return json({"result": llm_result})


def extract_text_from_pdf(file_bytes: bytes) -> str:
    """
    Extrahiert den gesamten Text aus einer PDF-Datei, die als Bytearray vorliegt.
    """
    reader = PyPDF2.PdfReader(io.BytesIO(file_bytes))
    text = ""
    for page in reader.pages:
        page_text = page.extract_text()
        if page_text:
            text += page_text
    return text


def call_llm_api(prompt: str) -> str:
    """
    Sendet den kombinierten Prompt an einen LLM-Anbieter (Beispiel: Gemini) und gibt die Antwort zurück.
    """

    client = genai.Client(api_key=API_KEY)

    response = client.models.generate_content(model="gemini-2.0-flash", contents=prompt)
    return response.text
