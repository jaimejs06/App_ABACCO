//
//  EventosRepository.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 1/5/25.
//

import Foundation

final class EventosRepository {
    
    @Published var evento:[Evento] = []
    @Published var messageError: String?
    private let eventoDataSource: EventosDataSource
    
    init(eventoDataSource: EventosDataSource = EventosDataSource()) {
        self.eventoDataSource = eventoDataSource
    }
    //función para obtener los eventos
    func obtenerEventos(completionBlock: @escaping (Result<[Evento], Error>) -> Void) {
        eventoDataSource.obtenerEventos(completionBlock: completionBlock)
    }
    
    
}
