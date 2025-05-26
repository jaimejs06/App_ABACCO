//
//  CambioContraseña.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 21/5/25.
//

import SwiftUI

import SwiftUI

struct CambioContrasena: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    @State private var emailActual: String = ""
    @State private var contrasenaActual: String = ""
    @State private var nuevaContrasena: String = ""
    @State private var comprobarContrasena: String = ""
    
    @State private var mensajeExito: Bool = false
    @State private var mensajeError: Bool = false
    @State private var mensaje:String = ""
    
    var body: some View {
        VStack {
            //Cabecera
            VStack{
                Text("Modificar Contraseña")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.bottom, 4)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color("Button").opacity(0.4))
            
            //Email Actual
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                        )
                    
                    TextField("Email", text: $emailActual)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 15)
            
            //Contraseña
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                        )
                    
                    SecureField("Contraseña actual", text: $contrasenaActual)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 20)
            
            //Nueva contraseña
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                        )
                    
                    SecureField("Escribe la nueva contraseña", text: $nuevaContrasena)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 15)
            
            //Comprobar contraseña
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                        )
                    
                    SecureField("Vuelva a escribir la contraseña", text: $comprobarContrasena)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 8)
            
            
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
            
            //Mostramos un mensaje de error
            if mensajeError {
                Text(mensaje)
                    .bold()
                    .foregroundColor(.red)
                    .padding(.top, 8)
                    .padding(.horizontal, 10)
            }
            
            //mensaje de exito si se modifica el email correctamente
            if mensajeExito {
                Text("Se ha cambiado la contraseña con exito")
                    .bold()
                    .foregroundColor(.green)
                    .padding(.top, 8)
                    .font(.system(size: 18))
                    .padding(20)
            }
            
            Spacer()
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
        
        //comprobamos que sean iguales las contraseñas
        if nuevaContrasena == comprobarContrasena {
            
            //llamamos a la funcion que actualiza el email de autenticacion
            authenticationViewModel.cambiarContrasenaUsuario(emailActual: emailActual, contrasenaActual: contrasenaActual, nuevaContrasena: nuevaContrasena) { result in
                switch result {
                case .success:
                    
                    //aparece el mensaje de exito
                    withAnimation {
                        mensajeExito = true
                    }
                    
                    //Hacemos que desaparezca cuando pasen 2 segundos
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            mensajeExito = false
                        }
                    }
                    
                    mensajeError = false
                    
                case .failure(let error):
                    mensaje = error.localizedDescription
                    mensajeError = true
                    mensajeExito = false
                }
            }
        }
    }
}
