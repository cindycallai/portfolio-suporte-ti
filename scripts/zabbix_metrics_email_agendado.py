import requests
import json
import csv
from datetime import datetime, timedelta
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders
import schedule
import time

# Zabbix API key
api_key = "e359306592e9f4f6f3876d452733f2dcacc2c5e8c2606f4468dc9ce13f67ef36"

# Zabbix API URL
url = "http://35.208.97.77/zabbix/api_jsonrpc.php"

# Lista de hosts a serem excluídos
hosts_to_exclude = ["GCP Server Zabbix"]  # Adicione os hosts que deseja excluir

# Função para fazer uma chamada à API do Zabbix
def call_zabbix_api(method, params):
    payload = {
        "jsonrpc": "2.0",
        "method": method,
        "params": params,
        "auth": api_key,
        "id": 1,
    }
    response = requests.post(url, json=payload)
    return response.json()

# Função para enviar e-mail com anexo
def send_email_with_attachment(file_path, recipients):
    email_from = "cindy.braun@cromai.com"  # Altere para o seu e-mail
    email_password = "livy hnir hand wkcc"  # Altere para a sua senha

    msg = MIMEMultipart()
    msg['From'] = email_from
    msg['To'] = ", ".join(recipients)
    msg['Subject'] = 'Zabbix Metrics CSV'

    body = "Segue em anexo o arquivo CSV com as métricas do Zabbix."

    msg.attach(MIMEText(body, 'plain'))

    with open(file_path, 'rb') as attachment:
        part = MIMEBase('application', 'octet-stream')
        part.set_payload(attachment.read())
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', f'attachment; filename= {file_path}')
    msg.attach(part)

    # Envio do e-mail
    with smtplib.SMTP('smtp.gmail.com', 587) as server:
        server.starttls()
        server.login(email_from, email_password)
        text = msg.as_string()
        server.sendmail(email_from, recipients, text)

# Função para exportar os dados para um arquivo CSV e enviar o e-mail após 5 minutos
def export_and_send_email():
    # Obter a data para 7 dias atrás
    seven_days_ago = datetime.now() - timedelta(days=7)

    # Lista para armazenar os dados a serem exportados para CSV
    csv_data = []

    # Iterar sobre cada dia nos últimos 7 dias
    for i in range(7):
        current_date = seven_days_ago + timedelta(days=i)
        
        # Obter todos os hosts
        hosts_result = call_zabbix_api("host.get", {"output": ["hostid", "host"], "selectInterfaces": "extend"})
        hosts = hosts_result["result"]
        
        # Iterar sobre cada host
        for host in hosts:
            hostname = host["host"]
            
            # Verificar se o host atual está na lista de exclusão
            if hostname in hosts_to_exclude:
                continue  # Pular este host
                
            hostid = host["hostid"]
            
            # Obter todas as métricas do host para o dia atual
            items_result = call_zabbix_api("item.get", {"output": ["name", "lastvalue", "lastclock", "units"], "hostids": hostid, "time_from": current_date.timestamp(), "time_till": (current_date + timedelta(days=1)).timestamp()})
            items = items_result["result"]
            
            # Filtrar as métricas para percentual, MB e GB
            for item in items:
                metric_name = item["name"]
                metric_value = item["lastvalue"]
                metric_date = current_date.strftime("%Y-%m-%d")  # Usando current_date
                metric_units = item["units"]
                
                # Converter o valor da métrica para percentual, MB ou GB conforme necessário
                if metric_units == "%":
                    metric_value = str(round(float(metric_value), 4)) + " %"
                elif metric_units == "B":
                    metric_value = str(round(float(metric_value) / 1024 / 1024 / 1024, 4)) + " GB"
                elif metric_units == "MB":
                    metric_value = str(round(float(metric_value) / 1024, 4)) + " MB"
                
                csv_data.append([hostname, metric_name, metric_value, metric_date])

    # Exportar os dados para um arquivo CSV
    csv_file_path = "zabbix_metrics.csv"
    with open(csv_file_path, "w", newline="") as csvfile:
        csv_writer = csv.writer(csvfile)
        csv_writer.writerow(["Hostname", "Metric Name", "Metric Value", "Date"])  # Adicionando "Date" ao cabeçalho
        csv_writer.writerows(csv_data)

    # Lista de destinatários
    recipients = ["douglas.bueno@cromai.com", "cindy.braun@cromai.com"]

    # Enviar e-mail com o arquivo CSV como anexo para os destinatários
    send_email_with_attachment(csv_file_path, recipients)
    print("Dados exportados para zabbix_metrics.csv e e-mail enviado com sucesso.")

# Agendar a exportação e envio do e-mail após 5 minutos
schedule.every(5).minutes.do(export_and_send_email)

# Loop para continuar executando o agendamento
while True:
    schedule.run_pending()
    time.sleep(1)
