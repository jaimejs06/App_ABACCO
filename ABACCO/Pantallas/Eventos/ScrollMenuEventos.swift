//
//  ScrollMenuEventos.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 1/5/25.
//

import SwiftUI

enum CategoriasEvento: String {
    case todos = "todos"
    case actuaciones = "actuacion"
    case ensayos = "ensayo"
}

//Esta vista se muestra en el menu desplegable en el que podemos ver todos los eventos disponibles e interactuar con ellos
struct ScrollMenuEventos: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var eventosViewModel:EventosViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    
    @State private var eventoSeleccionado: Evento? = nil
    @State private var mostrarDialogoEliminar = false
    
    @State private var categoriaSeleccionada: CategoriasEvento = .todos //por defecto aparecen todos

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
                    categoriaSeleccionada = .todos
                } label: {
                    Text("Todos")
                        .foregroundColor(categoriaSeleccionada == .todos ? .button : .white)
                        .bold()
                }
                .tint(categoriaSeleccionada == .todos ? .white : .button)
                .controlSize(.regular)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                
                Button {
                    categoriaSeleccionada = .ensayos
                } label: {
                    Text("Ensayos")
                        .foregroundColor(categoriaSeleccionada == .ensayos ? .button : .white)
                        .bold()
                }
                .tint(categoriaSeleccionada == .ensayos ? .white : .button)
                .controlSize(.regular)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                
                Button {
                    categoriaSeleccionada = .actuaciones
                } label: {
                    Text("Actuaciones")
                        .foregroundColor(categoriaSeleccionada == .actuaciones ? .button : .white)
                        .bold()
                }
                .tint(categoriaSeleccionada == .actuaciones ? .white : .button)
                .controlSize(.regular)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }
            .padding(.top, 6)
            
            //lista para los eventos
            ScrollView {
                VStack{
                    ForEach(eventosFiltrados(categoria: categoriaSeleccionada)) { evento in
                        NavigationLink(destination: EventosDetalles(evento: evento, authenticationViewModel: authenticationViewModel, eventosViewModel: eventosViewModel, usuarioViewModel: usuarioViewModel)) {
                            
                            TarjetaEvento(evento: evento, authenticationViewModel: authenticationViewModel, eventosViewModel: eventosViewModel)
                                .onLongPressGesture {
                                    if isAdmin() {
                                        eventoSeleccionado = evento
                                        mostrarDialogoEliminar = true
                                    }
                                }
                        }
                        .buttonStyle(PlainButtonStyle()) //quitar diseño por defecto
                    }
                    
                }
                .padding(.top, 8)
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
            }
            .confirmationDialog("¿Deseas eliminar este evento?", isPresented: $mostrarDialogoEliminar, titleVisibility: .visible) {
                Button("Eliminar", role: .destructive) {
                    if let evento = eventoSeleccionado {
                        eventosViewModel.borrarEvento(evento: evento)
                    }
                }
                Button("Cancelar", role: .cancel) {}
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
    //función para filtrar por categoria
    func eventosFiltrados(categoria: CategoriasEvento) -> [Evento] {
        switch categoria {
        case .todos:
            return eventosViewModel.eventos
        case .ensayos:
            return eventosViewModel.eventos.filter{ $0.categoria.lowercased() == "ensayo"}
        case .actuaciones:
            return eventosViewModel.eventos.filter{ $0.categoria.lowercased() == "actuacion"}
        }
    }
    //Función que comprueba si el usuario logueado es administrador
    func isAdmin() -> Bool {
        //obtenemos el usuario autenticado
        guard let userId = authenticationViewModel.user?.uid else {
            return false
        }
        //vemos en la coleccion de usuarios si es admin
        if let usuario = usuarioViewModel.usuario.first(where: { $0.id == userId }) {
            return usuario.isAdmin ?? false
        } else {
            return false
        }
    }
}

