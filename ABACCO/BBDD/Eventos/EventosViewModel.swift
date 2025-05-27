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
    
    func comprobarAsistencia(eventoID: String, userID: String, completion: @escaping (EstadoAsistencia) -> Void) {
        eventosRepository.comprobarAsistencia(eventoID: eventoID, userID: userID, completion: completion)
    }
    
    func insertarEvento(evento:Evento){
        eventosRepository.insertarEvento(evento: evento) { [weak self] result in
            DispatchQueue.main.async {
                
                switch result {
                case .success:
                    self?.obtenerEventos() //refrescamos la lista de eventos
                case .failure(let error):
                    self?.messageError = error.localizedDescription
                    
                }
            }  
        }
    }
    //Funcion para obtener un resumen de los asistentes para las estadisticas
    func obtenerResumenAsistencia(userId: String) -> ResumenAsistencia {
        var resumen = ResumenAsistencia()
        
        for evento in eventos {
            if evento.categoria == "ensayo" {
                resumen.totalEnsayos += 1
                if evento.asistentes?.contains(userId) ?? false {
                    resumen.asistidosEnsayo += 1
                }
            } else if evento.categoria == "actuacion" {
                resumen.totalActuaciones += 1
                if evento.asistentes?.contains(userId) ?? false {
                    resumen.asistidosActuacion += 1
                }
            }
        }
        
        return resumen
    }
    
    //función para borrar un evento
    func borrarEvento(evento:Evento){
        eventosRepository.borrarEvento(evento: evento)
    }
}
