//
//  Configuracion.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 30/4/25.
//

import SwiftUI

struct Configuracion: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack{
            //Cabecera
            VStack{
                Text("Configuración")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.bottom, 4)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color("Button").opacity(0.4))
            
            //Lista de opciones
            List {
                
                NavigationLink("Nombre", destination: CambioNombre( usuarioViewModel: usuarioViewModel, authenticationViewModel: authenticationViewModel))
                NavigationLink("Email", destination: CambioEmail(usuarioViewModel: usuarioViewModel, authenticationViewModel: authenticationViewModel))
                NavigationLink("Contraseña", destination: CambioContrasena(usuarioViewModel: usuarioViewModel, authenticationViewModel: authenticationViewModel))
                NavigationLink("Fecha de nacimiento", destination: FechaNacimiento(usuarioViewModel: usuarioViewModel, authenticationViewModel: authenticationViewModel))
                NavigationLink("Ciudad", destination: CambioCiudad(usuarioViewModel: usuarioViewModel, authenticationViewModel: authenticationViewModel))
            }
            .scrollContentBackground(.hidden)
            
            Spacer()
            
            Button("CERRAR SESIÓN"){
                authenticationViewModel.logout()
            }
            .bold()
            .foregroundColor(.button)
            .font(.title2)
            .frame(width: 200, height: 50)
   
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
}

#Preview {
    Configuracion(usuarioViewModel: UsuarioViewModel(), authenticationViewModel: AuthenticationViewModel())
}
