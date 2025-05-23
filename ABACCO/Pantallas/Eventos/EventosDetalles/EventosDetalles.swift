//
//  Detalles2.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 9/5/25.
//

import SwiftUI

struct EventosDetalles: View {
    
    var evento:Evento
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var eventosViewModel: EventosViewModel
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    
    @Environment(\.dismiss) var dismiss

    //opcion para mostrar diferentes vistas
    @State private var opcionSeleccionada: String = "Detalles"
    
    var body: some View {
        VStack (spacing: 0){
            
            //Panel para el apartado superior
            VStack{
                //Título
               Text(evento.titulo.uppercased())
                    .bold()
                    .font(.system(size: 30))
                    .padding(.top, 4)
                    .padding(.bottom, 6)
                    .foregroundColor(.button)
                
                //Panel para los botones
                HStack{
                    Button {
                        opcionSeleccionada = "Detalles"
                    } label: {
                        VStack{ //Texto del botón
                            Text("Detalles")
                                .foregroundColor(opcionSeleccionada == "Detalles" ? .button : .black)
                                .font(.system(size: 20))
                                .bold()
                                .padding(.bottom, 2)
                            Rectangle()
                                .frame(height: 3)
                                .foregroundColor(opcionSeleccionada == "Detalles" ? .button : .clear) //solo cuando está seleccionada
                        }
                        .frame(maxWidth: .infinity, alignment: .bottom)
                    }
                    Button {
                        opcionSeleccionada = "Asistentes"
                    } label: {
                        VStack{
                            Text("Asistentes")
                                .foregroundColor(opcionSeleccionada == "Asistentes" ? .button : .black)
                                .font(.system(size: 20))
                                .bold()
                                .padding(.bottom, 2)
                            Rectangle()
                                .frame(height: 3)
                                .foregroundColor(opcionSeleccionada == "Asistentes" ? .button : .clear)
                        }
                        .frame(maxWidth: .infinity, alignment: .bottom)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
            //.background(Color("Button").opacity(0.4))
            .padding(.bottom, 10)
            
            
            if opcionSeleccionada == "Detalles"{
                Detalles(evento: evento, authenticationViewModel: authenticationViewModel, eventosViewModel: eventosViewModel)
                    .padding()
            }else {
                ListaParticipantes(evento: evento, eventosViewModel: eventosViewModel, usuarioViewModel: usuarioViewModel)
            }

            Spacer()
        }
        .navigationBarBackButtonHidden(true) //ocultamos flecha atrás por defecto
        .toolbar {
            //Flecha hacia atrás personalizada
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss() //volver atrás
                } label: {
                    Image(systemName: "chevron.left")
                        .bold()
                        .foregroundColor(.button)
                        .padding(.bottom, 1)
                }
            }
        }
    }
}

