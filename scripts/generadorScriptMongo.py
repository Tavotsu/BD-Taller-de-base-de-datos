import json
import random
from datetime import datetime, timedelta

NUM_REGISTROS = 550
CAMARAS = [
    {"id": "CAM-01", "zona": "Graderia"},
    {"id": "CAM-02", "zona": "Mesa central"},
    {"id": "CAM-03", "zona": "Computadores"}
]

ACCIONES_POR_ZONA = {
    "Graderia": ["usando impresora 3d", "ensamblando robot", "conversando"],
    "Mesa central": ["conversando", "sentado usando laptop", "usando pizarra", "jugando juegos de mesa", "comiendo", "viendo tv"],
    "Computadores":["usando el celular", "usando el pc", "comiendo", "conversando"]
}

RUTS_CONOCIDOS = [
    19795715, 20928566, 18740982, 21752565, 19888809, 18098800, 203864832,
    15234567, 15398742, 15600123, 15987654, 16234589, 16543210, 16890123,
    17123456, 17456789, 17789012, 18123467, 18432109, 18654321, 18901234,
    19123456, 19456789, 19654321, 20012345, 20567890, 21234567
]

def generar_auditoria_json():
    logs = []
    fecha_base = datetime.now() - timedelta(days=7)

    print(f"Generando {NUM_REGISTROS} registros de auditoría de IA...")

    for _ in range(NUM_REGISTROS):
        camara = random.choice(CAMARAS)
        fecha_evento = fecha_base + timedelta(minutes=random.randint(1, 10000))
        
        num_personas = random.randint(0, 4)
        eventos = []

        for _ in range(num_personas):
            accion = random.choice(ACCIONES_POR_ZONA[camara["zona"]])
            confianza = round(random.uniform(0.75, 0.99), 2)
            
            match_sql = None
            if random.random() < 0.6:
                match_sql = random.choice(RUTS_CONOCIDOS)

            evento = {
                "entidad": "persona",
                "accion": accion,
                "confianza_ia": confianza,
                "posible_match_sql": match_sql
            }
            eventos.append(evento)

        log_doc = {
            "timestamp": { "$date": fecha_evento.isoformat() + "Z" },
            "metadata_camara": {
                "id_dispositivo": camara["id"],
                "zona": camara["zona"]
            },
            "total_personas_detectadas": num_personas,
            "eventos_detectados": eventos
        }
        
        logs.append(log_doc)

    with open('auditoria_mongo.json', 'w', encoding='utf-8') as f:
        json.dump(logs, f, indent=4, ensure_ascii=False)
    
    print("¡Archivo 'auditoria_mongo.json' generado exitosamente!")

if __name__ == "__main__":
    generar_auditoria_json()
