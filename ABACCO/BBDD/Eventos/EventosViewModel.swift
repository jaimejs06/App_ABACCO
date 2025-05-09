//
//  EventosViewModel.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 1/5/25.
//

import Foundation

final class EventosViewModel: ObservableObject {
    
    @Published var eventos:[Evento] = []
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
                //print("Eventos obtenidos: \(eventos.count)")
                self?.eventos = eventos
            case .failure(let error):
                print("Error al obtener eventos: \(error.localizedDescription)")
                self?.messageError = error.localizedDescription
            }
        }
    }
    
    func actualizarAsistencia(eventoID: String, userID:String, asistencia:Bool) {
        eventosRepository.actualizarAsistencia(eventoID: eventoID, userID: userID, asistencia: asistencia) 
    }
    
    
}
