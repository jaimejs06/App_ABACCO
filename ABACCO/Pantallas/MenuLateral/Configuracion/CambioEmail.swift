//
//  CambioEmail.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 21/5/25.
//

import SwiftUI

struct CambioEmail: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    @State private var emailActual: String = ""
    @State private var contrasena: String = ""
    @State private var nuevoEmail: String = ""
    
    @State private var mensajeExito: Bool = false
    @State private var mensajeError: Bool = false
    @State private var mensaje:String = ""
    
    var body: some View {
        VStack {
            //Cabecera
            VStack{
                Text("Modificar email")
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
                    
                    TextField("Email Actual", text: $emailActual)
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
                    
                    SecureField("Contraseña", text: $contrasena)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 20)
            
            //Nuevo email
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                        )
                    
                    TextField("Escribe el nuevo email", text: $nuevoEmail)
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
                Text("Se te ha enviado un mensaje al nuevo correo para confirmarlo")
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
        //   .onAppear(){
        //       sincronizarEmailsiCambia()
        //   }
    }
    
    //Función para guardar los cambios
    func guardar() {
        
        //llamamos a la funcion que actualiza el email de autenticacion
        authenticationViewModel.cambiarCorreoUsuario(emailActual: emailActual, contrasenaActual: contrasena, nuevoCorreo: nuevoEmail) { result in
            switch result {
            case .success:
                
                // si se actualiza lo actualizamos tambien en nuestra BBDD de usuario -> actualiza antes de confirmar el email
                usuarioViewModel.actualizarEmail(userId: authenticationViewModel.user?.uid ?? "", nuevoEmail: nuevoEmail)
                
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
    
 /*   //Comprobamos si el email de authenticacion es diferente al de usuarios y lo sincronizamos
    func sincronizarEmailsiCambia() {
        
        if authenticationViewModel.user?.email != obtenerEmail() {
            usuarioViewModel.actualizarEmail(userId: authenticationViewModel.user?.uid ?? "", nuevoEmail: authenticationViewModel.user?.email ?? emailActual)
        }
    }
    
    //Funcion que obtiene el email de usuarios con el id del usuarioActual
    func obtenerEmail() -> (String) {
        
        guard let userId = authenticationViewModel.user?.uid else {
            return ("Usuario no encontrado")
        }
        if let usuario = usuarioViewModel.usuario.first(where: { $0.id == userId }) {
            return (usuario.email)
        } else {
            return ("Usuario no encontrado")
        }
    }
} */





