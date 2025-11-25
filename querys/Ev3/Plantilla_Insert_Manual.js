// primer comando al iniciar al mongosh es *** use Citt_audit ***

// segundo comando es *** db.use_audit *** 

// para poder hacer un insertOne, updateOne, deleteOne y finalmente un find se tiene que utilizar de la siguiente manera: 

//db.use_audit.updateOne ¨para actualizar¨

//db.use_audit.insertOne ¨para insertar¨

//db.use_audit.deleteOne ¨para eliminar¨

//db.use_audit.deletemany ¨para eliminar varios¨

// db.use_audit.find ¨para buscar¨

db.use_audit.find({ //aqui le estas diciendo que dentro de la collecion llamda use_audit busque:
    "eventos_destacados" : { // que busque dentro de eventos destacados
        $eleMath: { // $eleMath le dice que solo devuelva los elementos que cumplan con las siguientes condiciones 
            "accion": "usando Impresora 3D", // por ejemplo aqui, que la accion que se este realizando sea que este usando la impresora 3D 
            "confianza_ia":{ $gt: 0.90} // $gt (mayor que) y que la confianza de la IA sea mayor a 0.90
        }
    }
})

db.use_audit.updateOne({
    "metadata_camara.id_dispositivo": "CAM-03", // aqui le estamos diciendo que dentro de metada_camara busque el id del dispositivo que sea igual a CAM-03
    "eventos_destacados": { // que busque dentro de los eventos destacados 
        $eleMath: { // $eleMath le dice que solo devuelva los elementos que cumplan con las siguientes condiciones
            "accion": "conversando", // la accion que debe estar es realizando es conversando  
            "confianza_ia": { $lt: 0.80} // y que la confianza de la IA debe ser menor que 0.80
        }
    }
},
    {   
        $set: 
        {
            "eventos_destacados.$.accion": "reunion de equipo", // aqui el $set le dice que actualice la accion de *conversando* a *reunion de equipo* 
                "eventos_destacados.$.validado_manual": true // se le asigna *true* si fue validado por una persona de manera manual y *false* si NO esta validado
        }

    }
)

db.use_audit.updateMany(
    {}, // aqui se aplicara el filtro para todos las colecciones que se indiquen
    
    {
        $pull: { // ña funcion que se utilizando con el pull es que elimine todos los elementos que cumplan con la condicion que se le indique
            "eventos_destacados":{ // que busque dentro de los eventos destacado 
                "confianza_ia":{$lt: 0.50} // que borre todos los elementos que tengan una confianza de la IA menor a 0.50 
            }
        }
    }
)

db.use_audit.updateOne({ 
    "metadata_camara": { // aqui le estamos diciendo que dentro de metadata_camara que es un documento anidado
        "id_dispositivo": "CAM-04", // que busque el id de la camara *CAM-04*
        "zona": "Sala de impresion 3D", // que este ubicada en la zona de *Sala de impresion 3D* 
        "resolucion": "1920x1080" // y que tenga la resolucion de *1920x1080*
    },
    "eventos_destacados": [{ // aqui le estamos diciendo que dentro de eventos destacados, el cual es un ARRAY busque que tenga los siguientes elementos
        "entidad": "persona", // que contenga entidad de persona 
        "accion": "calibrando impresora", // como accion calibrando impresora
        "confianza_ia": 0.98, // con una confianza de la IA de 0.98 
        "coordenadas_bbox": [50, 60, 200, 300] // con las coordenadas del bounding box de [50, 60, 200, 300]
    }]
})

db.use_audit.deleteOne({"_id": ObjectId("648f1e5f5f3c88b1a2d4e9c3")}) // aqui se esta eliminando el documento que tenga el id igual al que se indica entre parentesis

db.use_audit.deleteMany({                          // aqui le estamos diciendo que borre todos los documentos que esten dentro de eventos destacados 
    "eventos_destacados.confianza_ia": {lt: 0.40 } // los cuales que tengan una confianza menor a 0.40
})

db.use_audit.deleteMany({// aqui le estamos diciendo que borre todos los documentos que tengan el id de dispositivo igual a CAM-02
    "metadata_camara.id.dispositivo": "CAM-02" // en este caso se utiliza mucho para camaras fuera de servicio que hayan grabado informacion no deseada
})