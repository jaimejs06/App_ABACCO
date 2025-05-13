//
//  Detalles2.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 9/5/25.
//

import SwiftUI
import MapKit

struct Detalles: View {
    
    var evento:Evento
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var eventosViewModel: EventosViewModel
    
    var body: some View {
        
        //region a mostrar
        let region: MapCameraPosition = .region(.init(center: .init(latitude: evento.ubicacion?.latitude ?? 0.0, longitude: evento.ubicacion?.longitude ?? 0.0), latitudinalMeters: 200, longitudinalMeters: 200))
        
        VStack{
            
            //Fecha del evento
            HStack{
                Image(systemName: "calendar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(formatearFecha(evento.fecha))
                    .font(.system(size: 18))
                    .foregroundColor(.button)
                    .lineLimit(1)
                    .padding(.leading, 8)
                Spacer()
            }
            
            Divider()
            
            //Hora del evento
            HStack {
                Image(systemName: "clock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(horaFecha(evento: evento))
                    .font(.system(size: 18))
                    .foregroundColor(.button)
                    .lineLimit(1)
                    .padding(.leading, 8)
                Spacer()
            }
            
            Divider()
            
            //Panel para la ubicación
            VStack {
                //lugar
                HStack{
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text(evento.lugar ?? "")
                        .font(.system(size: 18))
                        .lineLimit(1)
                        .foregroundColor(.button)
                        .padding(.leading, 8)
                    Spacer()
                }
            }
            .padding(.bottom, 12)
            
            //Mapa
            Map(initialPosition: region) {
                Marker(evento.titulo, coordinate: CLLocationCoordinate2D(latitude: evento.ubicacion?.latitude ?? 0.0, longitude: evento.ubicacion?.longitude ?? 0.0))
            }
            .mapStyle(.hybrid)
            .frame(height: 220)
            .cornerRadius(15)
            
            Spacer()
            
        }
        .padding()
        .background(.backgroundApp)
        .cornerRadius(15)
        .frame(height: 400)
        
        PanelInferior(evento: evento, authenticationViewModel: authenticationViewModel, eventosViewModel: eventosViewModel)
    }
    
    //Función para cambiar la forma de la fecha
    func formatearFecha(_ date: Date) -> String {
        let nuevaFecha = DateFormatter()
        
        nuevaFecha.locale = Locale(identifier: "es_ES") //Cambiamos idioma a español
        nuevaFecha.dateStyle = .full //Cambiamos el formato a largo
        
        return nuevaFecha.string(from: date).capitalized
    }
    //función que devuelve la hora de la fecha
    func horaFecha(evento:Evento) -> String {
        let fecha = evento.fecha
        let hora = DateFormatter()
        hora.dateFormat = "HH:mm"
        return hora.string(from: fecha)
    }
}


struct PanelInferior: View {
    
    var evento:Evento
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var eventosViewModel: EventosViewModel
    @State private var estadoAsistencia: EstadoAsistencia = .ninguna
    
    var body: some View {
        
        VStack{
            HStack{
  
                switch estadoAsistencia {
                case .ninguna:
                    Text("Esperando respuesta...")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                case .asiste:
                    Text("Asistiré")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                case .noAsiste:
                    Text("No asistiré")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Botones(evento: evento, authenticationViewModel: authenticationViewModel, eventosViewModel: eventosViewModel)
                
            }
            .padding()
        }
        .background(.backgroundApp)
        .frame(width: 340, alignment: .bottom)
        .cornerRadius(15)
        .task{
            comprobarEstado()
        }
    }
    //funcion que comprueba en que estado se encuentra el usuario en el evento(asiste, no...)
    func comprobarEstado() {
        let userID = authenticationViewModel.user?.uid ?? ""
        
        eventosViewModel.comprobarAsistencia(eventoID: evento.id ?? "", userID: userID) { estado in //estado que se devuelve
            DispatchQueue.main.async { // hace que se ejecute en el hilo principal
                self.estadoAsistencia = estado
            }
        }
    }
}
