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
    @StateObject var usuarioViewModel: UsuarioViewModel = UsuarioViewModel()
    
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
            UsuarioView(usuarioViewModel: usuarioViewModel)
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
    
    var body: some View {
        
        //realizamos una lista
        List{
            //por cada usuario existente en la BBDD, creamos un nuevo VStack
            ForEach(usuarioViewModel.usuario){ usuario in
                VStack{
                    HStack{
                        //Imagen del usuario, pendiente por implementar
                        Image(usuario.imagenName ?? "defaultProfile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                
                        VStack{
                            
                            HStack {
                    
                                Text(usuario.nombre + " " + usuario.apellidos)
                                    .bold()
                                    .font(.system(size: 20))
                                    .padding(.bottom, 4)
                                    .padding(.leading, 8)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Spacer() //Hacemos que quede pegado a la derecha
                                
                                let emoticono = obtenerEmoticono(instrumento: usuario.instrumento ?? "") //obtenemos el emoticono
                                
                                Text(usuario.instrumento?.uppercased() ?? "SIN ESPECIFICAR") //si no tiene instrumento, mostramos valor por defecto
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                
                                EmoticonoImage(imageName: emoticono)
                                    .padding(.trailing, 4)
                                
                            }
                        }
                        
                    }
                }
                .padding(6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .cornerRadius(10)
                .listRowInsets(EdgeInsets()) //Elimina el padding interno de la celda
                .background(Color("BackgroundApp"))
            }
        }
        .task {
            usuarioViewModel.obtenerUsuario()
        }
        .scrollContentBackground(.hidden) //Oculta el fondo predeterminado de la lista
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


#Preview {
    Miembros()
}
