//
//  CambioNombre.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 21/5/25.
//

import SwiftUI

struct CambioNombre: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    @State private var nombre: String = ""
    @State private var apellidos: String = ""
    
    @State private var mensajeExito: Bool = false
    @State private var mensajeError: Bool = false
    
    var body: some View {
        VStack {
            //Cabecera
            VStack{
                Text("Modificar nombre")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.bottom, 4)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color("Button").opacity(0.4))
            
            //nombre
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                        )
                    
                    TextField("Nuevo nombre", text: $nombre)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 15)
            
            //apellidos
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                        )
                    
                    TextField("Apellidos...", text: $apellidos)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 15)
            
            //Boton para guardar el cambio
            Button {
                guardar()
            } label: {
                Text("Guardar")
                    .font(.system(size: 20))
            }
            .tint(.button).opacity(0.8)
            .controlSize(.regular)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            
            if mensajeError {
                Text("Debes cambiar alguno de los campos")
                    .bold()
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }
            
            //mensaje de exito si se inserta la noticia
            if mensajeExito {
                Text("Has modificado el nombre correctamente")
                    .bold()
                    .foregroundColor(.green)
                    .padding(.top, 8)
                    .font(.system(size: 22))
                    .padding(20)
            }
            
           Spacer()
        }
        .onAppear{ //cargamos los valores del nombre actual en el texfield
            let (nombreActual, apellidoActual) = obtenerNombre()
            self.nombre = nombreActual
            self.apellidos = apellidoActual
        }
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
    //Función para guardar los cambios
    func guardar() {
        //nombre actual
        let (nombreActual, apellidosActuales) = obtenerNombre()
        
        if nombre != nombreActual || apellidos != apellidosActuales {
            //actualizamos si hay algun cambio
            if let userId = authenticationViewModel.user?.uid {
                usuarioViewModel.actualizarNombre(userId: userId, nuevoNombre: nombre, nuevoApellido: apellidos)
                
                withAnimation {
                    mensajeExito = true
                }
                
                //Hacemos que desaparezca cuando pasen 2 segundos
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        mensajeExito = false
                    }
                }
                
            } else {
                //Volvemos a pintar en el texfield los valores originales
                nombre = nombreActual
                apellidos = apellidosActuales
                
                mensajeError = true
            }
        }
    }
    //Funcion que comprueba el nombre del usuario actual y lo devuelve
    func obtenerNombre() -> (String, String) {
        var nombre = ""
        var apellido = ""
        
        guard let userId = authenticationViewModel.user?.uid else {
            return ("Usuario no encontrado", "Apellido no encontrado")
        }
        
        if let usuario = usuarioViewModel.usuario.first(where: { $0.id == userId }) {
            nombre = usuario.nombre
            apellido = usuario.apellidos
            return (nombre, apellido)
        } else {
            return ("Usuario no encontrado", "Apellido no encontrado")
        }
    }
}

#Preview {
    CambioNombre(usuarioViewModel: UsuarioViewModel(), authenticationViewModel: AuthenticationViewModel())
}
