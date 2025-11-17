import random
from datetime import datetime, timedelta
import json

NOMBRES_FEMENINOS = [
    'Sofía', 'Emilia', 'Isabella', 'Julieta', 'Trinidad', 'Isidora', 'Emma', 'Agustina', 'Amanda', 'Florencia',
    'Mía', 'Antonella', 'Josefa', 'Catalina', 'Martina', 'Valentina', 'Victoria', 'Maite', 'Antonia', 'Renata'
]
NOMBRES_MASCULINOS = [
    'Mateo', 'Gaspar', 'Liam', 'Lucas', 'Santiago', 'Benjamín', 'Vicente', 'Agustín', 'Maximiliano', 'Tomás',
    'Joaquín', 'Bastián', 'Martín', 'Matías', 'Facundo', 'Emiliano', 'Alonso', 'Thiago', 'Bruno', 'Gabriel'
]
APELLIDOS = [
    'González', 'Muñoz', 'Rojas', 'Díaz', 'Pérez', 'Soto', 'Contreras', 'Silva', 'Martínez', 'Sepúlveda',
    'Morales', 'Rodríguez', 'López', 'Fuentes', 'Torres', 'Araya', 'Flores', 'Espinoza', 'Valenzuela', 'Castillo'
]
TRACKS = [
    'Track de Robótica', 'Track de Programación Competitiva', 'Track de Inteligencia Artificial',
    'Track de Ciberseguridad', 'Track de Desarrollo de Videojuegos', 'Track de Desarrollo Web y Móvil'
]
PROFESORES = [
    ('Juan', 'Pérez'), ('Ana', 'García'), ('Carlos', 'López'),
    ('María', 'Martínez'), ('Luis', 'Hernández'), ('Elena', 'Gómez')
]
PLANTILLAS_PROYECTOS = {
    'Track de Robótica': ['Brazo Robótico Autónomo', 'Robot Seguidor de Línea', 'Sistema de Navegación para Drones'],
    'Track de Programación Competitiva': ['Plataforma de Juez en Línea', 'Visualizador de Algoritmos', 'Framework para Pruebas de Estrés'],
    'Track de Inteligencia Artificial': ['Modelo de Detección de Emociones', 'Sistema de Recomendación Educativo', 'Chatbot Asistente DUOC'],
    'Track de Ciberseguridad': ['Herramienta de Análisis de Vulnerabilidades', 'Sistema de Detección de Intrusiones', 'Framework de Simulación de Phishing'],
    'Track de Desarrollo de Videojuegos': ['Juego de Estrategia en Tiempo Real', 'RPG 2D con Narrativa Interactiva', 'Juego Educativo sobre Historia'],
    'Track de Desarrollo Web y Móvil': ['App para la Gestión de Proyectos CITT', 'Plataforma Web de Intercambio de Habilidades', 'Marketplace de Proyectos Freelance']
}
NOMBRES_EVENTOS = [
    "Charla Introductoria a la IA Generativa", "Taller de Ethical Hacking", "Competencia de Programación 'CodeMasters'",
    "Seminario de Desarrollo con Unity", "Workshop de Robótica con Arduino", "Presentación de Proyectos de Ciberseguridad"
]
LUGARES_EVENTOS = ["Auditorio Principal", "Sala CatchAI", "Laboratorio de Redes", "Sala de Conferencias B", "Patio Central"]

NUM_ESTUDIANTES = 140
NUM_PROYECTOS = 50
NUM_EVENTOS = 15
RUT_MIN = 18000000
RUT_MAX = 22000000

def calcular_dv(rut_sin_dv):
    rut_reverso = str(rut_sin_dv)[::-1]
    multiplicador, suma = 2, 0
    for digito in rut_reverso:
        suma += int(digito) * multiplicador
        multiplicador = 2 if multiplicador == 7 else multiplicador + 1
    resto = suma % 11
    dv = 11 - resto
    if dv == 11:
        return '0'
    if dv == 10:
        return 'K'
    return str(dv)

def generar_json_estudiantes():
    ruts_usados = set()
    lista_estudiantes_json = []
    proyectos_generados_data = {}

    print("Iniciando la generación de datos en memoria...")

    tracks_generados = [{'id': i + 1, 'nombre': nombre} for i, nombre in enumerate(TRACKS)]

    print(f"Generando {NUM_PROYECTOS} proyectos en memoria...")
    proyectos_por_track = {track['id']: [] for track in tracks_generados}

    for i in range(NUM_PROYECTOS):
        track_asignado = random.choice(tracks_generados)
        nombre_proyecto = f"{random.choice(PLANTILLAS_PROYECTOS[track_asignado['nombre']])} v{random.randint(1,5)}"
        id_proyecto = 101 + i
        proyectos_por_track[track_asignado['id']].append(id_proyecto)
        proyecto_info = {
            "id_proyecto_sql": id_proyecto,
            "nombre": nombre_proyecto.replace("'", "''"),
            "descripcion": "Descripción del proyecto.",
            "track": {
                "id_track_sql": track_asignado['id'],
                "nombre": track_asignado['nombre']
            }
        }
        proyectos_generados_data[id_proyecto] = proyecto_info

    print(f"Generando {NUM_ESTUDIANTES} estudiantes...")

    asignaciones_obligatorias = []
    proyectos_ya_seleccionados = set()

    for track_id in proyectos_por_track:
        proyectos_disponibles_en_track = [p for p in proyectos_por_track[track_id] if p not in proyectos_ya_seleccionados]
        random.shuffle(proyectos_disponibles_en_track)

        for i in range(min(3, len(proyectos_disponibles_en_track))):
            proyecto = proyectos_disponibles_en_track[i]
            asignaciones_obligatorias.append(proyecto)
            proyectos_ya_seleccionados.add(proyecto)

    todos_los_proyectos = [p for lista in proyectos_por_track.values() for p in lista]
    proyectos_disponibles = [p for p in todos_los_proyectos if p not in proyectos_ya_seleccionados]
    random.shuffle(proyectos_disponibles)

    for i in range(NUM_ESTUDIANTES):
        while True:
            numrun = random.randint(RUT_MIN, RUT_MAX)
            if numrun not in ruts_usados:
                ruts_usados.add(numrun)
                break

        dv_run = calcular_dv(numrun)

        if random.random() < 0.80:
            id_genero, pnombre, snombre = 2, random.choice(NOMBRES_MASCULINOS), random.choice(NOMBRES_MASCULINOS)
            genero_str = "Masculino"
        else:
            id_genero, pnombre, snombre = 1, random.choice(NOMBRES_FEMENINOS), random.choice(NOMBRES_FEMENINOS)
            genero_str = "Femenino"

        papellido, mapellido = random.choice(APELLIDOS), random.choice(APELLIDOS)
        fec_nac = datetime.now() - timedelta(days=random.randint(18*365, 30*365))

        id_proyecto_asignado = None

        if asignaciones_obligatorias:
            id_proyecto_asignado = asignaciones_obligatorias.pop(0)
        elif proyectos_disponibles and random.random() < 0.7:
            id_proyecto_asignado = proyectos_disponibles.pop()

        proyecto_embebido = None
        if id_proyecto_asignado is not None:
            proyecto_embebido = proyectos_generados_data[id_proyecto_asignado]

        estudiante_doc = {
            "_id": numrun,
            "dv_run": dv_run,
            "pnombre": pnombre,
            "snombre": snombre,
            "papellido": papellido,
            "mapellido": mapellido,
            "fec_nac": fec_nac.strftime('%Y-%m-%d'),
            "genero": genero_str,
            "proyecto": proyecto_embebido
        }

        lista_estudiantes_json.append(estudiante_doc)

    nombre_archivo_salida = 'estudiantes_mongo.json'
    print(f"Escribiendo {len(lista_estudiantes_json)} estudiantes en {nombre_archivo_salida}...")

    with open(nombre_archivo_salida, 'w', encoding='utf-8') as f:
        json.dump(lista_estudiantes_json, f, indent=4, ensure_ascii=False)

    print("¡Archivo JSON generado exitosamente!")

if __name__ == "__main__":
    generar_json_estudiantes()
