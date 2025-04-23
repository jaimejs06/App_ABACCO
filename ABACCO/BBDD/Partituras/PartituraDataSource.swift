//
//  PartituraDataSource.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 29/4/25.
//

import Foundation
import FirebaseFirestore

struct Partitura: Decodable, Identifiable {
    @DocumentID var id: String?
    let url:String
    let titulo:String
}

final class PartituraDataSource {
    
    private let database = Firestore.firestore().collection("partituras")
    
    func obtenerPartituras(completionBlock: @escaping (Result<[Partitura], Error>) -> Void){
        
        database.addSnapshotListener { query, error in
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
}


