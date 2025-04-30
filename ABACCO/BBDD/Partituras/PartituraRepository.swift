//
//  PartituraRepository.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 29/4/25.
//

import Foundation

final class PartituraRepository {
    @Published var partituras: [Partitura] = []
    @Published var messageError: String?
    private let partituraDataSource: PartituraDataSource

    
    init(partituraDataSource: PartituraDataSource = PartituraDataSource()) {
        self.partituraDataSource = partituraDataSource

    }
    
    func obtenerPartituras(completionBlock: @escaping (Result<[Partitura], Error>) -> Void) {
        partituraDataSource.obtenerPartituras(completionBlock: completionBlock)
    }
    
    func crearPartitura(partitura: Partitura, completionBlock: @escaping (Result<Partitura, Error>) -> Void) {
        partituraDataSource.crearPartitura(partitura: partitura, completionBlock: completionBlock)
    }
    
    func borrarPartitura(partitura:Partitura){
        partituraDataSource.borrarPartitura(partitura: partitura) 
    }
}
