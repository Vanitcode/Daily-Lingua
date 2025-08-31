import requests

url = "https://upload-audio-response-tgm6qoqxqq-uc.a.run.app"

files = {
    "audio": open("./testing/respuesta3.wav", "rb")
}
data = {
    "userId": "test001",
    "sessionId": "session003",
    "questionIndex": "1",
    "articleId": "fOYJBo4sZVjUy6dcJIKf"
}

response = requests.post(url, files=files, data=data)
print(response.status_code)
print(response.text)