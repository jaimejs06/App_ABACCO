//
//  PartituraViewModel.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 29/4/25.
//

import Foundation

final class PartituraViewModel: ObservableObject {
    
    //Almacenar las partituras
    @Published var partituras: [Partitura] = []
    //Almacenar los errores
    @Published var messageError: String?
    
    private let partituraRepository: PartituraRepository
    
    //Constructor
    init(partituraRepository: PartituraRepository = PartituraRepository()) {
        self.partituraRepository = partituraRepository
    }
    
    //Función para obtener las partituras de Firebase
    func obtenerPartituras() {
        partituraRepository.obtenerPartituras { [weak self] result in
            switch result {
            case .success(let partituras):
                self?.partituras = partituras
            case .failure(let error):
                self?.messageError = error.localizedDescription
            }
            
        }
    }
    
    func crearPartitura(partitura: Partitura) {
        partituraRepository.crearPartitura(partitura: partitura) { [weak self]  result in
            switch result {
            case .success(let partitura):
                print("Partitura añadida \(partitura.titulo)")
            case .failure(let error):
                self?.messageError = error.localizedDescription
            }
        }
    }
    
    func borrarPartitura(partitura: Partitura) {
        partituraRepository.borrarPartitura(partitura: partitura)
    }
    
    
}
