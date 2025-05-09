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
    
    @StateObject var partituraViewModel: PartituraViewModel = PartituraViewModel()
    @StateObject var usuarioViewModel: UsuarioViewModel = UsuarioViewModel()
    @StateObject var eventosViewModel = EventosViewModel()
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                VStack {
                    
                    MenuSuperior(showMenu: $showMenu)
                        .padding(.bottom, 2)
                    
                    ScrollView(showsIndicators: false) {
                        //Seccion de noticias
                        HStack {
                            Text("NOTICIAS")
                                .bold()
                                .font(.system(size: 30))
                                .padding(.leading, 50)
                                .padding(.top, 12)
                            
                            if isAdmin() {
                                Spacer()
                                Insertar(destino: AnyView(AgregarNoticia()))
                                    .padding(.top, 12)
                            }
                        }
                        
                        //Vista de scroll de las noticias
                        Noticias4(usuarioViewModel: usuarioViewModel)
                        
                        //Seccion de partituras
                        HStack {
                            Text("PARTITURAS")
                                .bold()
                                .font(.system(size: 30))
                                .padding(.leading, 50)
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
                                .padding(.leading, 50)
                            
                            if isAdmin() {
                                Spacer()
                                Insertar(destino: AnyView(AgregarEvento()))
                            }
                        }
                        //Vista de lista de los eventos
                        Eventos(eventosViewModel: eventosViewModel)
                        
                        
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

struct MenuSuperior: View {
    
    @Binding var showMenu: Bool
    
    var body: some View {

            VStack {
                Button {
                    withAnimation {
                        showMenu.toggle()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 15, height: 15)
                        .bold()
                        .foregroundColor(.button)
                        .padding(.leading, 20)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            VStack {
                Image("ABACCO")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 25)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            

    }
}



#Preview {
    Principal(authenticationViewModel: AuthenticationViewModel(), partituraViewModel: PartituraViewModel(), usuarioViewModel: UsuarioViewModel())
}
