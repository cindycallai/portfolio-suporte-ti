from pymongo import MongoClient
from datetime import datetime

# Conexão com banco local – substitua URI se usar Mongo Atlas
client = MongoClient('mongodb://localhost:27017/')
db = client['visitas']
collection = db['cadastros']

def save_visit_data(form_data, image_urls):
    visita = {
        "cliente": form_data.get("cliente"),
        "grupo": form_data.get("grupo"),
        "cidade": form_data.get("cidade"),
        "data": form_data.get("data"),
        "motivo": form_data.get("motivo"),
        "observacoes": form_data.get("observacoes"),
        "imagens": image_urls,
        "cadastrado_em": datetime.utcnow()
    }
    result = collection.insert_one(visita)
    visita["_id"] = str(result.inserted_id)
    return visita
