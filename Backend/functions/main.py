from firebase_functions import firestore_fn, https_fn
from firebase_functions.params import SecretParam
from firebase_admin import initialize_app, firestore, storage
import google.cloud.firestore

from flask import Request
from openai import OpenAI
import datetime
import io
import os
import tempfile
import uuid
import json

# Inicializamos Firebase
initialize_app()

# Definimos el secreto
OPENAI_API_KEY = SecretParam("OPENAI_API_KEY")

@https_fn.on_request()
def get_article_by_date(req: https_fn.Request) -> https_fn.Response:
    try:
        date = req.args.get("date")
        if date is None:
            return https_fn.Response("No date provided", status= 400)
        
        #Checking the format of the date
        try:
            parsed_date = datetime.datetime.strptime(date, "%Y-%m-%d")
        except ValueError:
            return https_fn.Response("Date format invalid", 400)
        
        firestore_client: google.cloud.firestore.Client = firestore.client()
        
        #Query to Firestore
        dailyLingua_ref = firestore_client.collection("dailyLingua")
        query = dailyLingua_ref.where("date", "==", date).limit(1).stream()
        article = next(query, None)
        
        if article is None:
            return https_fn.Response("There is no article for this date", 404)
        
        return https_fn.Response(
            json.dumps(article.to_dict()),
            status=200,
            content_type="application/json"
        )
    except Exception as e:
        return https_fn.Response(f"Error 500 {str(e)}", 500)

@https_fn.on_request()
def get_articles_by_week(req: https_fn.Request) -> https_fn.Response:
    try:
        week_id = req.args.get("weekId")
        if week_id is None:
            return https_fn.Response("No weekId provided", status=400)

        firestore_client = firestore.client()
        articles_ref = firestore_client.collection("dailyLingua")
        query = articles_ref.where("weekId", "==", week_id).stream()

        articles = [doc.to_dict() for doc in query]

        if not articles:
            return https_fn.Response("No articles found for this week", status=404)

        return https_fn.Response(
            json.dumps(articles),
            status=200,
            content_type="application/json"
        )
    except Exception as e:
        return https_fn.Response(f"Error 500: {str(e)}", 500)

@https_fn.on_request()
def get_free_article_by_week(req: https_fn.Request) -> https_fn.Response:
    try:
        week_id = req.args.get("weekId")
        if week_id is None:
            return https_fn.Response("No weekId provided", status=400)

        firestore_client = firestore.client()
        articles_ref = firestore_client.collection("dailyLingua")
        query = articles_ref.where("weekId", "==", week_id).where("isFree", "==", True).limit(1).stream()

        free_article = next(query, None)

        if free_article is None:
            return https_fn.Response("No free article found for this week", status=404)

        return https_fn.Response(
            json.dumps(free_article.to_dict()),
            status=200,
            content_type="application/json"
        )
    except Exception as e:
        return https_fn.Response(f"Error 500: {str(e)}", 500)

@firestore_fn.on_document_created(document="dailyLingua/{docId}", secrets=[OPENAI_API_KEY])
def document_to_audio(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:
    """Convierte los campos de texto ('article', 'title', 'question1-3') en audio,
    guarda las URLs y las fechas en el documento Firestore."""

    if event.data is None:
        return

    # Campos a procesar
    text_fields = ["article", "title", "question1", "question2", "question3"]
    audio_urls = {}
    api_key = OPENAI_API_KEY.value
    client = OpenAI(api_key=api_key)
    bucket = storage.bucket()

    try:
        for field in text_fields:
            text_value = event.data.get(field)
            if not text_value:
                continue  # Campo vacío o inexistente

            # Crear archivo temporal
            with tempfile.NamedTemporaryFile(suffix=".mp3", delete=False) as temp_file:
                audio_path = temp_file.name

            # Generar audio con OpenAI
            with client.audio.speech.with_streaming_response.create(
                model="tts-1",
                voice="alloy",
                input=text_value,
            ) as response:
                response.stream_to_file(audio_path)

            # Subir a Firebase Storage
            file_id = str(uuid.uuid4())
            blob = bucket.blob(f"audio_articles/{file_id}.mp3")
            blob.upload_from_filename(audio_path)
            blob.make_public()
            audio_url = blob.public_url

            # Asociar la URL al campo correspondiente
            audio_urls[f"{field}_audio_url"] = audio_url
            print(f"Audio generated in {field}: {audio_url}")

            # Eliminar el archivo temporal
            os.remove(audio_path)

        # Guardar todas las URLs en el documento
        if audio_urls:
            event.data.reference.update(audio_urls)
            print(f" URLs added to {event.params['docId']}: {audio_urls}")

    except Exception as e:
        print(f"Error processing the audios: {str(e)}")

@https_fn.on_request()
def upload_audio_response(req: https_fn.Request) -> https_fn.Response:
    
    #I must use .form insted of .args because we send a file
    user_id = req.form.get("userId")
    session_id = req.form.get("sessionId")
    question_index = req.form.get("questionIndex")
    file = req.files.get("audio")
    article_id = req.form.get("articleId")

    if not all([user_id, session_id, question_index, file]):
        return https_fn.Response("Missing parameters", status=400)

    # Guardar el archivo en temp
    tmp = tempfile.NamedTemporaryFile(delete=False)
    file.save(tmp.name)

    # Ruta en Storage
    storage_path = f"audiosDailyLinguaUsers/{user_id}/{session_id}/q{question_index}.wav"
    bucket = storage.bucket()
    blob = bucket.blob(storage_path)
    blob.upload_from_filename(tmp.name, content_type=file.content_type)

    # Actualizar Firestore
    db = firestore.client()
    sessions_ref = db.collection("dailyLinguaUsers").document(user_id) \
        .collection("sessions").document(session_id)
    
    session_updates = {
        f"responseAudio{int(question_index)}Path": storage_path
    }

    # Si es la primera pregunta → guardar articleId
    if question_index == "1" and article_id:
        session_updates["articleId"] = article_id

    # Si es la tercera pregunta → marcar como completado y guardar fecha
    if question_index == "3":
        session_updates["completed"] = True
        session_updates["createdAt"] = firestore.SERVER_TIMESTAMP

    # Subimos todo junto
    sessions_ref.set(session_updates, merge=True)

    return https_fn.Response("Audio uploaded successfully", status=200)

@firestore_fn.on_document_updated(document="dailyLinguaUsers/{userId}/sessions/{sessionId}", secrets=[OPENAI_API_KEY])
def on_session_completed(event: firestore_fn.Event[firestore_fn.Change]) -> None:
    previous_data = event.data.before.to_dict()
    new_data = event.data.after.to_dict()
    
    #Checking if the sessions is completed
    if not previous_data.get("completed") and new_data.get("completed") is True:
        user_id = event.params["userId"]
        session_id = event.params["sessionId"]
        
        print(f"Generating report for: {user_id}. Session: {session_id}")
        
        #Audio responses paths
        audio_paths = [
            new_data.get("responseAudio1Path"),
            new_data.get("responseAudio2Path"),
            new_data.get("responseAudio3Path")
        ]
        # Text article and questions
        article_id = new_data.get("articleId")
        db = firestore.client()
        article_doc = db.collection("dailyLingua").document(article_id).get()
        if not article_doc.exists:
            print(f"Article {article_id} not found")
            return
        article_data = article_doc.to_dict()
        article_text = article_data.get("article")
        questions = [
            article_data.get("question1"),
            article_data.get("question2"),
            article_data.get("question3")
        ]
        #Download audio responses and transcribe
        bucket = storage.bucket()
        transcriptions = []
        client = OpenAI(api_key = OPENAI_API_KEY.value)
        for path in audio_paths:
            if not path:
                transcriptions.append("(sin respuesta)")
                continue

            blob = bucket.blob(path)
            with tempfile.NamedTemporaryFile(delete=False, suffix=".mp3") as tmp:
                blob.download_to_file(tmp)
                tmp_path = tmp.name

            with open(tmp_path, "rb") as f:
                transcription = client.audio.transcriptions.create(
                    model="whisper-1",
                    file=f,
                    response_format="text",
                    language= "en"
                )
                transcriptions.append(transcription)

            os.remove(tmp_path)

        # 4. Creating prompt and generating report
        instructions = "You are a language teacher who has to analyze the quality of a student's oral responses based on a previously read article and three questions. I'll now pass everything on to you. This student is trying to learn and improve their oral expressions, as well as overcome their fear of speaking English."
        input_text = f"Artículo: {article_text}\n\n"
        for i in range(3):
            input_text += f"Question {i+1}: {questions[i]}\nAnswer: {transcriptions[i]}\n\n"
            print(f"Q{i+1}: {questions[i]}")
            print(f"A{i+1}: {transcriptions[i]}")

        response = client.responses.create(
            model="gpt-4.1",
            instructions=instructions,
            input=input_text,
        )

        report = response.output_text.strip()

        # 5. Save report in Firestore
        session_ref = db.collection("dailyLinguaUsers").document(user_id).collection("sessions").document(session_id)
        session_ref.update({"report": report})

        print("Informe generado y guardado correctamente.")

#Endpoint for audio_url's
@https_fn.on_request()
def get_article_urls_for_id(req: https_fn.Request) -> https_fn.Response:
    try:
        article_id = req.args.get("articleId")
        if article_id is None:
            return https_fn.Response("No articleId provided", status=400)

        firestore_client = firestore.client()
        articles_ref = firestore_client.collection("dailyLingua")
        query = articles_ref.where("id", "==", article_id).limit(1).stream()
        
        article_doc = next(query, None)

        if not article_doc:
            return https_fn.Response("No article found for this id", status=404)
        
        data = article_doc.to_dict()
        article = {
            "id": article_id,
            "title_audio_url": data.get("title_audio_url"),
            "article_audio_url": data.get("article_audio_url"),
            "question1_audio_url": data.get("question1_audio_url"),
            "question2_audio_url": data.get("question2_audio_url"),
            "question3_audio_url": data.get("question3_audio_url")
        }
        
        return https_fn.Response(
            json.dumps(article),
            status=200,
            content_type="application/json"
        )
    except Exception as e:
        return https_fn.Response(f"Error 500: {str(e)}", 500)