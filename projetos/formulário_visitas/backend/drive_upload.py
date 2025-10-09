from google.oauth2 import service_account
from googleapiclient.discovery import build
import mimetypes

SCOPES = ['https://www.googleapis.com/auth/drive.file']
SERVICE_ACCOUNT_FILE = 'credentials.json'

# Cria serviço do Drive
credentials = service_account.Credentials.from_service_account_file(
    SERVICE_ACCOUNT_FILE, scopes=SCOPES)
service = build('drive', 'v3', credentials=credentials)

def upload_file_to_drive(file_path):
    file_metadata = {
        'name': file_path.split('/')[-1],
        'parents': ['PASTE_FOLDER_ID_HERE']  # Substitua pelo ID da pasta no seu Drive
    }
    mimetype = mimetypes.guess_type(file_path)[0]
    media = MediaFileUpload(file_path, mimetype=mimetype)

    uploaded_file = service.files().create(
        body=file_metadata,
        media_body=media,
        fields='id'
    ).execute()

    file_id = uploaded_file.get('id')
    file_url = f"https://drive.google.com/file/d/{file_id}/view?usp=sharing"
    return file_url
