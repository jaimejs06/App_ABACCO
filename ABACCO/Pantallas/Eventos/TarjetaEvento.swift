//
//  TarjetaEvento.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 1/5/25.
//

import SwiftUI

//enum para el estado de la asistencia
enum EstadoAsistencia {
    case ninguna
    case asiste
    case noAsiste
}

//Estructura base de tarjeta para los eventos
struct TarjetaEvento: View {
    //iniciamos una variable del tipo evento
    var evento: Evento
    
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var eventosViewModel: EventosViewModel
        
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
                        
                        Botones(evento: evento, authenticationViewModel: authenticationViewModel, eventosViewModel: eventosViewModel)
                    }
                    .padding()
  
                }
                
            }
            .background(Color(.gray).opacity(0.1)).ignoresSafeArea()
        }
        .frame(width: 340, height: 140) //tamaño de la tarjeta
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
        
        
    }
    
    //Función para cambiar la forma de la fecha
    func formatearFecha(_ date: Date) -> String {
        let nuevaFecha = DateFormatter()
        
        nuevaFecha.locale = Locale(identifier: "es_ES") //Cambiamos idioma a español
        nuevaFecha.dateStyle = .full //Cambiamos el formato a largo
        
        return nuevaFecha.string(from: date).capitalized
    }
}

struct Botones:View {
    
    var evento: Evento
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var eventosViewModel: EventosViewModel
    
    //variable que almacena el estado
    @State var estadoAsistencia: EstadoAsistencia = .ninguna
    
    var body: some View {
    
        //Id del usuario registrado
        let userID = authenticationViewModel.user?.uid ?? ""
        
        HStack{
            //Botón para aceptar
            Button {
                estadoAsistencia = .asiste
                eventosViewModel.actualizarAsistencia(eventoID: evento.id ?? "", userID: userID, asistencia: true)
                print("asiste")
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.green)
                    .padding(.trailing, 10)
                    .opacity(estadoAsistencia == .noAsiste ? 0.1 : 1.0)
            }
            //Botón para denegar
            Button {
                estadoAsistencia = .noAsiste
                eventosViewModel.actualizarAsistencia(eventoID: evento.id ?? "", userID: userID, asistencia: false)
                print("no asiste")
            } label: {
                Image(systemName: "multiply.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.red)
                    .opacity(estadoAsistencia == .asiste ? 0.1 : 1.0)
            }
        }
        .onAppear{
            //Cargamos el estado de la asistencia del usuario logueado al mostrar la vista
            if let asistentes = evento.asistentes, asistentes.contains(userID){
                estadoAsistencia = .asiste
            } else if let noAsistentes = evento.noAsistentes, noAsistentes.contains(userID){
                estadoAsistencia = .noAsiste
            } else {
                estadoAsistencia = .ninguna
            }
        }
    }
}


