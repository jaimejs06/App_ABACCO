//
//  MenuLateral2.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 27/3/25.
//

import SwiftUI

struct MenuLateral: View {
    
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var partituraViewModel: PartituraViewModel
    @ObservedObject var eventosViewModel:EventosViewModel
    
    var body: some View {
        
        ZStack {
            VStack {
                PerfilItem(usuarioViewModel: usuarioViewModel, authenticationViewModel: authenticationViewModel, eventosViewModel: eventosViewModel)
                Opcion(titulo: "Eventos", view: ScrollMenuEventos(eventosViewModel: eventosViewModel, authenticationViewModel: authenticationViewModel, usuarioViewModel: usuarioViewModel), icon: "calendar")
                Opcion(titulo: "Partituras", view: ScrollVerticalPartituras(partituraViewModel: partituraViewModel, usuarioViewModel: usuarioViewModel, authenticationViewModel: authenticationViewModel), icon: "paperclip")
                Opcion(titulo: "Miembros", view: Miembros(usuarioViewModel: usuarioViewModel, authenticationViewModel: authenticationViewModel), icon: "person.3.fill")
                
                Rectangle()
                    .frame(height: 1)
                    .padding(.horizontal, 6)
                    .padding(.bottom, 18)
                
                Opcion(titulo: "Configuración", view: Configuracion(usuarioViewModel: usuarioViewModel, authenticationViewModel: authenticationViewModel), icon: "gear")
                Opcion(titulo: "Info", view: Informacion(), icon: "info.circle")
                
                Spacer()
                
            }
        }
        .padding()
        .background(Color.button.opacity(0.98))
        .frame(width: 350, height: 650) //Le damos anchura y altura
        .cornerRadius(20) //Bordes redondeados
        .task {
            usuarioViewModel.obtenerUsuario()
        }
        Spacer() //Hacemos que quede pegado en la parte superior
    
    }
}

//Estructura base para cada opcion disponibles en el menú
struct Opcion<window: View>: View {
    var view: window
    var titulo: String
    var icon: String
    
    //constructor
    init(titulo: String, view: window, icon:String) {
        self.titulo = titulo
        self.view = view
        self.icon = icon
    }
    
    var body: some View {

        NavigationLink(destination: view) {
            RowViewItem(icon: self.icon, titulo: self.titulo)
        }
        .foregroundColor(.black)
        .padding(.bottom, 6)
    } //formateamos el color por defecto
}

//Estructura para cada fila de opcion en el menú
struct RowViewItem: View {
    //variables por parametro
    var icon:String
    var titulo:String
    
    var body: some View {
        
        VStack {
            HStack{
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text(titulo)
                    .font(.system(size: 25))
                    .bold()
                    .padding(.horizontal, 10)
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .bold()
                    .frame(width: 30, height: 30)
            }
            
        }
        
        .padding(.horizontal, 20) //margen desde la derecha para que se pegue a la izq
    }
}

//Estructura para la parte de la Foto + Nombre del usuario
struct PerfilItem: View {
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var eventosViewModel: EventosViewModel
    @State private var nombreUsuario: String = "" //Almacenamos el nombre de usuario
    
    var body: some View {
        
        VStack {
            HStack {
                NavigationLink (destination: Perfil(usuarioViewModel: usuarioViewModel, authenticationViewModel: authenticationViewModel, eventosViewModel: eventosViewModel)){
                    
                    if let uiImage = cargarImagenDesdeArchivo(nombre: obtenerImagen()){
                        //cargamos imagen guardada
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    } else {
                        Image("defaultProfile")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                }
                .foregroundColor(.black)
                
                VStack {
                    Text(obtenerNombre())
                        .font(.system(size: 25))
                        .bold()
                        
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .padding(.bottom, 70)
                .padding(.horizontal, 10)
        }
        .padding(.trailing, 20)
        
    }
    //Funcion que comprueba el nombre del usuario actual y lo devuelve
    func obtenerNombre() -> String {
        guard let userId = authenticationViewModel.user?.uid else {
            return "Usuario no encontrado"
        }
        
        if let usuario = usuarioViewModel.usuario.first(where: { $0.id == userId }) {
            return "\(usuario.nombre) \(usuario.apellidos)"
        } else {
            return "Usuario no encontrado"
        }
    }
    //Funcion para obtener la imagen del usuarioActual
    func obtenerImagen() -> String {
        guard let userId = authenticationViewModel.user?.uid else {
            return "defaultProfile"
        }
        
        if let usuario = usuarioViewModel.usuario.first(where: { $0.id == userId }) {
            return "\(usuario.imagenName ?? "defaultProfile")"
        } else {
            return "defaultProfile"
        }
    }
}

