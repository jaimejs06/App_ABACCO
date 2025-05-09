//
//  EventosDataSource.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 1/5/25.
//

import Foundation
import FirebaseFirestore

//Estructura para el evento
struct Evento: Codable, Identifiable {
    @DocumentID var id: String?
    var titulo:String
    var fecha:Date //fecha del evento
    var categoria:String //actuacion o ensayo
    var lugar:String? //lugar del evento
    var descripcion:String?
    var ubicacion:GeoPoint?

    
    var asistentes:[String]? //lista de los ids de usuarios que asisten al evento
    var noAsistentes:[String]?
}

final class EventosDataSource {
    
    private let database = Firestore.firestore()
    private let coleccion = "eventos"
    
    
    //función para obtener los eventos
    func obtenerEventos(completionBlock: @escaping (Result<[Evento], Error>) -> Void) {
        //conectamos a la BBDD
        database.collection(coleccion)
            .order(by: "fecha", descending: false) //ordenar por los eventos que son antes
            .addSnapshotListener { query, error in
                if let error = error {
                    print("Error al obtener los eventos \(error.localizedDescription)")
                    completionBlock(.failure(error))
                    return
                }
                guard let documentos = query?.documents.compactMap({ $0 }) else {
                    completionBlock(.success([]))
                    return
                }
                let eventos = documentos.map { try? $0.data(as: Evento.self) }
                    .compactMap { $0 }
                completionBlock(.success(eventos))
            }
    }
    //función para insertar o borrar un user en el Array de asistentes
    func actualizarAsistencia(eventoID: String, userID:String, asistencia:Bool) {
        let evento = database.collection(coleccion).document(eventoID)
        //comprobamos si asiste o no y lo añadimos o lo borramos
        if asistencia {
            //añadimos en asistentes
            evento.updateData(["asistentes": FieldValue.arrayUnion([userID])])
            //borramos de no asistentes
            evento.updateData(["noAsistentes": FieldValue.arrayRemove([userID])])
        } else {
            evento.updateData(["asistentes": FieldValue.arrayRemove([userID])])
            //añadimos en no asistentes
            evento.updateData(["noAsistentes": FieldValue.arrayUnion([userID])])
        }
    }
}

