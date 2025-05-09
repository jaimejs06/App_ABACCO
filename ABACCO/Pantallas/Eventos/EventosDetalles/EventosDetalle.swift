//
//  EventosDetalle.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 8/5/25.
//

import SwiftUI

//Pantalla Detalle de eventos donde mostramos las opciones diferentes disponibles "detalles" y "participantes"
struct EventosDetalle: View {
    @Environment(\.dismiss) var dismiss
    
    var evento:Evento
    
    @ObservedObject var eventosViewModel:EventosViewModel
    
    //opcion para mostrar diferentes vistas
    @State private var opcionSeleccionada: String = "Detalles"
    
    
    
    var body: some View {
        
        VStack{
            
            //Panel para el menú superior
            VStack {
                //titulo del evento
                Text(evento.titulo.uppercased())
                    .bold()
                    .font(.system(size: 30))
                    .frame(maxWidth: .infinity, alignment: .top)
                //opciones disponibles
                HStack{
                    Button {
                        opcionSeleccionada = "Detalles"
                    } label: {
                        Text("Detalles")
                            .foregroundColor(opcionSeleccionada == "Detalles" ? .white : .button)
                            .bold()
                    }
                    Button {
                        opcionSeleccionada = "Asistentes"
                    } label: {
                        Text("Asistentes")
                            .foregroundColor(opcionSeleccionada == "Asistentes" ? .white : .button)
                            .bold()
                    }
                }
                    
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color("Button").opacity(0.4))
            
            
            
            //Llamo a las diferentes opciones
            VStack {
                if opcionSeleccionada == "Detalles" {
                    Detalles(evento: evento)
                } else {
                    ListaParticipantes()
                }
                
            }
            
            Spacer()
               
        }
        .background(Color.backgroundApp)
        .navigationBarBackButtonHidden(true) //ocultamos flecha atrás por defecto
        .toolbar { //Flecha hacia atrás personalizada
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
