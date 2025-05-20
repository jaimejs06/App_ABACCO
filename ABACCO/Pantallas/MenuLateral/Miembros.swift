//
//  Miembros.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 25/3/25.
//

import SwiftUI

struct Miembros: View {
    @Environment(\.dismiss) var dismiss
    
    //mostrar la lista de usuarios
    @StateObject var usuarioViewModel: UsuarioViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(spacing: 0){
            VStack{
                Text("Lista de Miembros")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.bottom, 4)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color("Button").opacity(0.4))
            
            //mostramos la lista de usuarios
            UsuarioView(usuarioViewModel: usuarioViewModel, authenticationViewModel: authenticationViewModel)
                .background(Color.backgroundApp)
        }
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

//vista para mostrar los usuarios registrados en la BBDD
struct UsuarioView: View {
    
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        
        //realizamos una lista
        List {
            //por cada usuario existente en la BBDD, creamos un nuevo VStack
            ForEach(usuarioViewModel.usuario){ usuario in
                VStack {
                    HStack {
                        //obtenemos el string de la imagen
                        if let imagenName = usuario.imagenName, let uiImage = cargarImagenDesdeArchivo(nombre: imagenName) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                        } else { // si no mostramos la imagen por defecto
                            Image("defaultProfile")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                        }
                        
                        
                        Text(usuario.nombre + " " + usuario.apellidos)
                            .bold()
                            .font(.system(size: 18))
                            .padding(.bottom, 4)
                            .padding(.leading, 8)
                        
                        Spacer()
   
                    }

                    HStack {
                        Spacer() //Hacemos que quede pegado a la derecha
                        
                        let emoticono = obtenerEmoticono(instrumento: usuario.instrumento ?? "") //obtenemos el emoticono
                        
                        Text(usuario.instrumento?.uppercased() ?? "SIN ESPECIFICAR") //si no tiene instrumento, mostramos valor por defecto
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        EmoticonoImage(imageName: emoticono)
                            .padding(.trailing, 4)
                        
                    }
                    
                    //mostramos la opción de poder hacer administrador a otros miembros
                    if isAdmin() {
                        HStack(alignment: .top) {
                            
                            Spacer()
                            
                            Text("Administrador")
                                .font(.system(size: 16))
                                .foregroundColor(Color("Button"))
                                .bold()
                            
                            Toggle("", isOn: adminToggle(for: usuario))
                                .toggleStyle(SwitchToggleStyle(tint: Color("Button")))
                                .scaleEffect(0.9) //reducimos el tamaño
                            
                        }
                    }
                      
                }
            }
            .padding(4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cornerRadius(10)
            .listRowSeparator(.hidden)   //Quita la línea entre elementos
            .listRowInsets(EdgeInsets()) //Elimina el padding interno de la celda
            .background(Color("BackgroundApp"))
        }
        .task {
            usuarioViewModel.obtenerUsuario()
        }
        .scrollContentBackground(.hidden) //Oculta el fondo predeterminado de la lista
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
    //funcion para actualizar la funcion del Toggle en BBDD
    func adminToggle(for usuario:Usuario) -> Binding<Bool> {
        Binding(
            get: {
                usuario.isAdmin ?? false
            },
            set: { newValue in
                //actualizamos en la vista
                if let index = usuarioViewModel.usuario.firstIndex(where: { $0.id == usuario.id }) {
                    usuarioViewModel.usuario[index].isAdmin = newValue
                }
                //Actualizamos en la base de datos
                usuarioViewModel.actualizarAdmin(usuarioID: usuario.id ?? "", isAdmin: newValue)
            })
    }
}


//estructura para la imagen del emoticono
struct EmoticonoImage: View{
    var imageName: String
    var body: some View{
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 15, height: 15)
    }
}

//función para mostrar el código del emoticono
func obtenerEmoticono(instrumento: String) -> String{
    var emoticono: String
    //Comprobamos el tipo de instrumento que tiene
    switch (instrumento.lowercased()) {
    case "clarinete":
        emoticono = "clarinet"
    case "flauta":
        emoticono = "flute"
    case "saxofon":
        emoticono = "saxo"
    case "trompeta":
        emoticono = "trumpet"
    case "trombon":
        emoticono = "trombone"
    case "tuba":
        emoticono = "tube"
    case "percusion":
        emoticono = "drums"
    default:
        emoticono = "question" //si no tiene instrumento mostramos ?
    }
    
    return emoticono
}

