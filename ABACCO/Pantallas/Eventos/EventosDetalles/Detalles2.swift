//
//  Detalles2.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 9/5/25.
//

import SwiftUI
import MapKit

struct Detalles2: View {
    
    var evento:Evento
    
    var body: some View {
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
            .padding(.bottom, 8)
            
                    
           // MapView()
            
            
        }
        .padding()
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

struct MapView: View {
    var body: some View {
        // Este Map tiene una altura fija
        Map()
            .frame(height: 300) // Limitar altura para que no cambie dinámicamente
            .cornerRadius(15) // Opcional: Para bordes redondeados
            .padding(.horizontal)
    }
}

