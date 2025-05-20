//
//  Perfil.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 30/4/25.
//

import SwiftUI

struct Perfil: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var eventosViewModel: EventosViewModel
    
    @State private var profileImg: Image? = nil
    @State private var inputImage: UIImage?
    @State private var showPicker: Bool = false
    @State private var instrumento: String = "Selecciona tu instrumento"
    
    var body: some View {
        VStack {
            //Cabecera
            VStack{
                Text("Perfil")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.bottom, 4)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color("Button").opacity(0.4))
            
            //Panel para la imagen de perfil
            VStack{
                //seleccionamos imagen
                if let profileImg = profileImg {
                    profileImg.resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .onTapGesture {
                            withAnimation(.smooth){
                                self.showPicker.toggle()
                            }
                        }
                    
                } else if let uiImage = cargarImagenDesdeArchivo(nombre: obtenerImagen()){
                    //cargamos imagen guardada
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .onTapGesture {
                            withAnimation(.smooth){
                                self.showPicker.toggle()
                            }
                        }
                } else {
                    Image("defaultProfile")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .onTapGesture {
                            withAnimation(.smooth) {
                                self.showPicker.toggle()
                            }
                        }
                }
            }
            .padding(.top, 15)
            .frame(maxWidth: .infinity, alignment: .center)
            
            //Panel para el nombre del usuario actual
            VStack{
                Text(obtenerNombre())
                    .font(.system(size: 25))
                    .bold()
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity, alignment: .center)
            
            //Panel para modificar el instrumento
            HStack {
                
                Text(instrumento)
                    .padding(10)
                    .background(.white.opacity(0.5))
                    .cornerRadius(15)
                
                Menu {
                    Button("Clarinete"){
                        actualizarInstrumento("clarinete")
                    }
                    Button("Flauta"){
                        actualizarInstrumento("flauta")
                    }
                    Button("Saxofón") {
                        actualizarInstrumento("saxofon")
                    }
                    Button("Tuba") {
                        actualizarInstrumento("tuba")
                    }
                    Button("Trombón") {
                        actualizarInstrumento("trombon")
                    }
                    Button("Percusión") {
                        actualizarInstrumento("percusion")
                    }
                    Button("Trompeta") {
                        actualizarInstrumento("trompeta")
                    }
                } label: {
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.button)
                        .frame(width: 30, height: 30)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            
            Divider()
                
            
            //panel para las estadísticas
            VStack {
                Text("Estadísticas")
            }
            .bold()
            .font(.system(size: 25))
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            TarjetaEstadisticas(authenticationViewModel: authenticationViewModel, eventosViewModel: eventosViewModel)
            
            
            Spacer()
        }
        .onAppear() {
            cargarInstrumentoActual()
        }
        .sheet(isPresented: self.$showPicker, onDismiss: loadImage, content: {
            ImagenPicker(image: self.$inputImage)
        })
        .background(.backgroundApp)
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
    //Funcion para actualizar el instrumento en la BBDD
    func actualizarInstrumento(_ nuevoInstrumento: String) {
        //Obtenemos el usuario actual
        guard let userId = authenticationViewModel.user?.uid else { return }
        //actualizamos el isntrumento en la BBDD
        usuarioViewModel.actualizarInstrumento(instrumento: nuevoInstrumento, userId: userId)
        //actualiza la vista
        instrumento = formatearInstrumento(nuevoInstrumento)
        
    }
    
    //Funcion para cargar el instrumento asignado si tiene
    func cargarInstrumentoActual() {
        guard let userId = authenticationViewModel.user?.uid else { return }
        
        if let usuario = usuarioViewModel.usuario.first(where: { $0.id == userId }),
           let instrumentoBD = usuario.instrumento {
            instrumento = formatearInstrumento(instrumentoBD)
        }
    }
    //Funcion que formatea los datos de la BBDD para mostrarlos en mayúscula y con tílde
    func formatearInstrumento(_ instrumentoBD: String) -> String {
        switch instrumentoBD {
        case "clarinete": return "Clarinete"
        case "flauta": return "Flauta"
        case "saxofon": return "Saxofón"
        case "tuba": return "Tuba"
        case "trombon": return "Trombón"
        case "percusion": return "Percusión"
        case "trompeta": return "Trompeta"
        default: return "Instrumento"
        }
    }
    
    //Funcion para cargar la imagen del perfil
    func loadImage() {
        guard let inputImage = inputImage, let userId = authenticationViewModel.user?.uid else { return }
        profileImg = Image(uiImage: inputImage) //Convertimos el UIImage a Image
        
        //guardamos la imagen localmente
        if let nombreImagen = guardarImagen(inputImage, userId: userId) {
            //actualizamos el nombre de la imagen en firebase
            usuarioViewModel.actualizarImagen(nombre: nombreImagen, userId: userId)
        }
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


