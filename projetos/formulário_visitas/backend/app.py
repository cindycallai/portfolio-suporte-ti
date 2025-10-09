from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
import os
from drive_upload import upload_file_to_drive
from db import save_visit_data

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'temp_uploads'

# Cria pasta temporária se não existir
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

@app.route('/upload', methods=['POST'])
def upload():
    try:
        data = request.form
        files = request.files.getlist("imagens")

        uploaded_files = []

        for file in files:
            if file.filename == '':
                continue
            filename = secure_filename(file.filename)
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(filepath)

            # Faz upload no Drive
            drive_url = upload_file_to_drive(filepath)
            uploaded_files.append(drive_url)

            # Remove arquivo local após upload
            os.remove(filepath)

        # Salva dados no banco
        saved_data = save_visit_data(data, uploaded_files)

        return jsonify({"message": "Dados e imagens salvos com sucesso!", "data": saved_data}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
