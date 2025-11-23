
//! Antes de leer: $gt = mayor que | $lt = menor que | $elemMatch = busca que c 

//- Leer
db.use_audit.find({
    "eventos_detectados": {
        $elemMatch: {
            "accion": "usando impresora 3d",
            "confianza_ia": { $gt: 0.90 }
        }
    }
})

//- Actualizar
db.use_audit.updateOne(
   // Filtramos: Buscamos el documento y el elemento específico
   {
       "metadata_camara.id_dispositivo": "CAM-01",
       "eventos_detectados": {
           $elemMatch: {
               "accion": "conversando",
               "confianza_ia": { $lt: 0.8 }
           }
       }
   },
   // Ahora si el update: Usamos '$' para referirnos al elemento que encontramos arriba
   {
       $set: {
           "eventos_detectados.$.accion": "reunión de equipo", 
           "eventos_detectados.$.validado_manual": true
       }
   }
)

db.use_audit.updateMany(
   {}, //Aqui se aplica el filtro
   {
       $pull: {
           "eventos_detectados": {
               "confianza_ia": { $lt: 0.50 }
           }
       }
   }
)

//- Insertar
db.use_audit.insertOne({
    "timestamp": new Date(), // Crea la fecha actual automática
    "metadata_camara": {
        "id_dispositivo": "CAM-04",
        "zona": "Sala de Impresión 3D",
        "resolucion": "1080p"
    },
    "eventos_detectados": [
        {
            "entidad": "persona",
            "accion": "calibrando impresora",
            "confianza_ia": 0.98,
            "coordenadas_bbox": [50, 60, 200, 300]
        }
    ]
})

//- Eliminar

// Borra un log usando la ID
db.use_audit.deleteOne({ "_id": ObjectId("654abchsdjfhbdsjh12312") })

// Caso: Borra todos los log con menos de 40% de confianza
db.use_audit.deleteMany({
  "eventos_detectados.confianza_ia": { $lt: 0.40 }
})

// Caso: Borra los log de la camara X
db.use_audit.deleteMany({
  "metadata_camara.id_dispositivo": "CAM-EJ"
})