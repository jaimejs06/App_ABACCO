//
//  EventosViewModel.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 1/5/25.
//

import Foundation

final class EventosViewModel: ObservableObject {
    
    @Published var evento:[Evento] = []
    @Published var messageError: String?
    
    private let eventosRepository: EventosRepository
    
    init(eventosRepository: EventosRepository = EventosRepository()) {
        self.eventosRepository = eventosRepository
    }
    //Función para obtener todos los eventos de la BBDD
    func obtenerEventos(){
        eventosRepository.obtenerEventos { [weak self] result in
            switch result {
            case .success(let eventos):
                self?.evento = eventos
            case .failure(let error):
                self?.messageError = error.localizedDescription
            }
        }
    }
    
    
}
