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
    var asistentes:[String]? //lista de los ids de usuarios que asisten al evento
}

final class EventosDataSource {
    
    private let database = Firestore.firestore()
    private let coleccion = "eventos"
    
    
    //función para obtener los eventos
    func obtenerEventos(completionBlock: @escaping (Result<[Evento], Error>) -> Void) {
        //conectamos a la BBDD
        database.collection(coleccion)
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
}
