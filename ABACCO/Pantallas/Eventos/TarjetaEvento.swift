//
//  TarjetaEvento.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 1/5/25.
//

import SwiftUI

struct TarjetaEvento: View {
    //iniciamos una variable del tipo evento
    var evento: Evento
    
    var body: some View {
        VStack(spacing: 0) {
            
            //Título del evento
            VStack{
                Text(evento.titulo.uppercased())
                    .bold()
                    .font(.system(size: 20))
                    .padding(.bottom, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .padding(.top, 6)
                
                
                //Lugar del evento
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .padding(.trailing, 6)
                    
                    Text(evento.lugar ?? "")
                        .font(.system(size: 16))
                        .lineLimit(1)
                        .foregroundColor(.gray).opacity(0.7)
                    
                    Spacer ()
                }
            }
            .padding()
            
            ZStack { //Para aplicar el color de fondo gris
                
                VStack(spacing: 0) {
                    
                    Divider() //linea separadora
                    
                    //fecha del evento
                    HStack {
                        Text(formatearFecha(evento.fecha))
                            .font(.system(size: 16))
                            .foregroundColor(.button)
                            .lineLimit(1)
                            .padding(.trailing, 10)
                            
                        
                        Spacer()
                        
                        //Botón para aceptar
                        Button {
                            //Por implementar
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundColor(.green)
                                .padding(.trailing, 10)
                        }
                        //Botón para denegar
                        Button {
                            //Por implementar
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
  
                }
                
            }
            .background(Color(.gray).opacity(0.1)).ignoresSafeArea()
        }
        .frame(width: 310, height: 140) //tamaño de la tarjeta
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
    
    //Función para cambiar la forma de la fecha
    func formatearFecha(_ date: Date) -> String {
        let nuevaFecha = DateFormatter()
        
        nuevaFecha.locale = Locale(identifier: "es_ES") //Cambiamos idioma a español
        nuevaFecha.dateStyle = .full //Cambiamos el formato a largo
        
        return nuevaFecha.string(from: date)
    }
}

#Preview {
    TarjetaEvento(evento: Evento(id: "", titulo: "", fecha: Date.now, categoria: "", descripcion: "", asistentes: ["",""]))
}
