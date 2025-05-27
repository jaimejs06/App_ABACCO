//
//  Principal.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 5/3/25.
//

import SwiftUI
//Vista principal de la aplicación
struct Principal: View {
    
    //Variable para mostrar el menu deslizante
    @State private var showMenu = false
    //Esperamos recibir una instancia de AuthenticationViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var noticiasViewModel: NoticiasViewModel = NoticiasViewModel()
    @StateObject var partituraViewModel: PartituraViewModel = PartituraViewModel()
    @StateObject var usuarioViewModel: UsuarioViewModel = UsuarioViewModel()
    @StateObject var eventosViewModel = EventosViewModel()
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                VStack {
                    
                    MenuSuperior(showMenu: $showMenu)
                        .padding(.bottom, 2)
                    //Hacemos que la pantalla se deslizable
                    ScrollView(showsIndicators: false) {
                        //Seccion de noticias
                        HStack {
                            Text("NOTICIAS")
                                .bold()
                                .font(.system(size: 30))
                                .padding(.horizontal, 30)
                                .padding(.top, 12)
                            
                            //Si el usuario es administrador mostramos la opcion de insertar
                            if isAdmin() {
                                Spacer()
                                Insertar(destino: AnyView(AgregarNoticia(noticiaViewModel: noticiasViewModel, authenticationViewModel: authenticationViewModel)))
                                    .padding(.top, 12)
                            }
                        }
                        
                        //Vista de scroll de las noticias
                        Noticias4(noticiasViewModel: noticiasViewModel, usuarioViewModel: usuarioViewModel, authenticationViewModel: authenticationViewModel)
                        
                        //Seccion de partituras
                        HStack {
                            Text("PARTITURAS")
                                .bold()
                                .font(.system(size: 30))
                                .padding(.horizontal, 30)
                                .padding(.bottom, 4)
                            
                            if isAdmin() {
                                Spacer()
                                Insertar(destino: AnyView(AgregarPartitura(partituraViewModel: partituraViewModel)
                                    .background(.backgroundApp)))
                            }
                        }
                        //Vista de scroll de las partituras
                        Partituras(partituraViewModel: partituraViewModel)
                        
                        //Seccion de eventos
                        HStack {
                            Text("EVENTOS")
                                .bold()
                                .font(.system(size: 30))
                                .padding(.horizontal, 30)
                            
                            if isAdmin() {
                                Spacer()
                                Insertar(destino: AnyView(AgregarEvento(eventosViewModel: eventosViewModel)))
                            }
                        }
                        //Vista de lista de los eventos
                        Eventos(eventosViewModel: eventosViewModel, authenticationViewModel: authenticationViewModel)
                            
                    }
                }
                .background(.backgroundApp)
                .onTapGesture {
                    withAnimation {
                        showMenu = false  // Cerramos el menú al tocar fuera
                    }
                }
                .task {
                    eventosViewModel.obtenerEventos()
                }
                
                // Si hemos pulsado el botón se abre el menú
                if showMenu {
                    MenuLateral(usuarioViewModel: usuarioViewModel, authenticationViewModel: authenticationViewModel, partituraViewModel: partituraViewModel, eventosViewModel: eventosViewModel)
                        .transition(.move(edge: .leading))
                        .onTapGesture {
                            withAnimation {
                                showMenu = false  // Cerramos el menú al tocar fuera
                            }
                        }
                }
            }
        }
        .background(.backgroundApp)
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

