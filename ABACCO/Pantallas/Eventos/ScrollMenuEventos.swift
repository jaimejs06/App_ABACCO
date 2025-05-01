//
//  ScrollMenuEventos.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 1/5/25.
//

import SwiftUI

//Esta vista se muestra en el menu desplegable en el que podemos ver todos los eventos disponibles e interactuar con ellos
struct ScrollMenuEventos: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var eventosViewModel:EventosViewModel
    
    
    var body: some View {
        VStack{
            //Título de la ventana
            VStack{
                Text("Eventos")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.bottom, 4)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color("Button").opacity(0.4))
            
            //Botones
            HStack{
                Button {
                    //Por completar
                } label: {
                    Text("Todos")
                        .foregroundColor(.white)
                }
                .tint(.button)
                .controlSize(.regular)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                
                Button {
                    //Por completar
                } label: {
                    Text("Ensayos")
                        .foregroundColor(.white)
                }
                .tint(.button)
                .controlSize(.regular)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                
                Button {
                    //Por completar
                } label: {
                    Text("Actuaciones")
                        .foregroundColor(.white)
                }
                .tint(.button)
                .controlSize(.regular)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
            .padding(.top, 6)
            
            //lista para los eventos
            ScrollView {
                VStack{
                    ForEach(eventosViewModel.eventos) { evento in
                        TarjetaEvento(evento: evento, eventosViewModel: eventosViewModel)
                        
                    }
                    
                }
                .padding(.top, 8)
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
            }
            
            
        }
        .background(.backgroundApp)
        .navigationBarBackButtonHidden(true) //ocultamos flecha atrás por defecto
        .toolbar{
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

#Preview {
    ScrollMenuEventos( eventosViewModel: EventosViewModel())
}
