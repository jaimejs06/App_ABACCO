//
//  PartituraDataSource.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 29/4/25.
//

import Foundation
import FirebaseFirestore

struct Partitura: Decodable, Identifiable, Encodable {
    @DocumentID var id: String?
    let url:String
    let titulo:String
    let autor:String?
}

final class PartituraDataSource {
    
    private let database = Firestore.firestore()
    private let coleccion = "partituras"
    
    func obtenerPartituras(completionBlock: @escaping (Result<[Partitura], Error>) -> Void){
        
        database.collection(coleccion)
            .addSnapshotListener { query, error in
                if let error = error {
                    print("Error al obtener las partituras \(error.localizedDescription)")
                    completionBlock(.failure(error))
                    return
                }
                guard let documentos = query?.documents.compactMap({ $0 }) else {
                    completionBlock(.success([]))
                    return
                }
                let partituras = documentos.map { try? $0.data(as: Partitura.self) }
                    .compactMap { $0 }
                completionBlock(.success(partituras))
        }
    }
    
    //función para crear una nueva partitura
    func crearPartitura(partitura: Partitura, completionBlock: @escaping (Result<Partitura, Error>) -> Void){
        do {
            _ = try database.collection(coleccion).addDocument(from: partitura)
            completionBlock(.success(partitura))
        } catch {
            completionBlock(.failure(error))
        }
    }
    
    //función para borrar una partitura
    func borrarPartitura(partitura:Partitura){
        
        guard let documentId = partitura.id else {
            return
        }
        database.collection(coleccion).document(documentId).delete()

    }
}


