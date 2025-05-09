//
//  Detalles.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 8/5/25.
//

import SwiftUI
import MapKit

//En esta estructura mostramos la seleccion de Detalle cunado aparece al clickear las tarjetas de los eventos
struct Detalles: View {
    
    var evento:Evento


    var body: some View {
        
        let region: MapCameraPosition = .region(.init(center: .init(latitude: evento.ubicacion?.latitude ?? 0.0, longitude: evento.ubicacion?.longitude ?? 0.0), latitudinalMeters: 1300, longitudinalMeters: 1300))
        
        VStack{
            VStack {
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
                        .padding(.trailing, 10)
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
                        .padding(.trailing, 10)
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
                            .padding(.trailing, 6)
                        
                        Text(evento.lugar ?? "")
                            .font(.system(size: 18))
                            .lineLimit(1)
                            .foregroundColor(.button)
                        Spacer()
                    }
                    
                }
                
                //Panel para el mapa
                VStack{
                    Map(initialPosition: region) {
                        Marker(evento.titulo, coordinate: CLLocationCoordinate2D(latitude: evento.ubicacion?.latitude ?? 0.0, longitude: evento.ubicacion?.longitude ?? 0.0))
                    }
                    .mapStyle(.hybrid)
                    .cornerRadius(20)
                }
                .frame(width: 350, height: 300)
                .padding()
                
                
            }
            .padding()
        }
        
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


