//
//  ScrollNoticias.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 22/4/25.
//

import SwiftUI

//En esta estructura estamos definiendo el Scroll Horizontal que mostrará las Tarjetas de Noticias y que nos dirigirá al clicar hacia NoticiasDetalle
struct ScrollNoticias2: View {
    
    @ObservedObject var noticiasViewModel: NoticiasViewModel
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    @State private var noticiaSeleccionada: Noticia? = nil
    @State private var mostrarDialogoEliminar = false
    
    var body: some View {
        VStack {
            //Scroll Horizontal
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    //Mostramos una tarjeta para cada noticia
                    ForEach(noticiasViewModel.noticias) { noticia in
                        
                        //Buscamos el autor que coincida con el id, para pasarlo por parametro a NoticiaTarjeta
                        let autor = usuarioViewModel.usuario.first(where: { $0.id == noticia.escritorID })
                        
                        //Hacemos que cada tarjeta sea seleccionable y muestre el diseño de NoticiaDetalle
                        NavigationLink(destination: NoticiasDetalle3(
                            noticia: noticia,
                            usuarioViewModel: usuarioViewModel,
                            noticiasViewModel: noticiasViewModel
                            
                        )) {
                            //Si no se selecciona se muestra el diseño de tarjetas en scroll horizontal
                            NoticiaTarjeta1(noticia: noticia, autor: autor)
                                .onLongPressGesture{
                                    if isAdmin() {
                                        noticiaSeleccionada = noticia
                                        mostrarDialogoEliminar = true
                                    }
                                }
                        }
                        .buttonStyle(PlainButtonStyle()) //quitar diseño por defecto
                    }
                }
                .padding(2) //separacion de todos los bordes
                .padding(.horizontal, 30) //separacion lateral

            }
            .confirmationDialog("¿Deseas eliminar este evento?", isPresented: $mostrarDialogoEliminar, titleVisibility: .visible) {
                Button("Eliminar", role: .destructive) {
                    if let noticia = noticiaSeleccionada {
                        noticiasViewModel.borrarNoticia(noticia: noticia)
                    }
                }
                Button("Cancelar", role: .cancel) {}
            }
            
        }
        .task { //Cargamos las noticias y los usuarios cuando aparezca la vista
            noticiasViewModel.obtenerNoticias()
            usuarioViewModel.obtenerUsuario()
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


