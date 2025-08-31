#Todo


#Posibles errores/cambios futuro
- La función on_session_completed no comprueba que existan 3 archivos de audio. Esto debe mejorarse para que no se produzcan errores
-- Básicamente no tengo ningún manejo de error



#Mejoras futuras
2. Herramientas especializadas en pronunciación
OpenAI no tiene una API directa para análisis fonético o corrección de pronunciación (por ejemplo, con IPA o fonemas). Para eso existen herramientas especializadas como:
🔹 Google Cloud Speech + Speech Adaptation – puedes obtener hipótesis alternativas de transcripción.
🔹 Azure Speech Service (Pronunciation Assessment) – analiza fonéticamente palabra por palabra con accuracy, fluency y completeness.
🔹 iSpeech, Speechace o Elsa API – diseñadas específicamente para aprendizaje de idiomas.