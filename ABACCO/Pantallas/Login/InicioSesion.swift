 //
//  ContentView.swift
//  Abbacco
//
//  Created by Jaime Jimenez sanchez on 3/3/25.
//

import SwiftUI
import SwiftHEXColors


struct InicioSesion: View {
    
    //Esperamos recibir una instancia de AuthenticationViewModel
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    
    //variable para el email y contraseña
    @State var email:String = ""
    @State var password = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("ABACCO")
                    .resizable()
                    .scaledToFill() //que se ajuste a la escala del frame
                    .frame(width: 250, height: 100)
                    .padding(.bottom, 80)
                
                Text("Inicio de sesion")
                    .font(.system(size: 35))
                    .bold()
                
                HStack {
                    Text("Inicia sesión en tu cuenta")
                        .fontWeight(.light)
                    Text("ABACCO")
                        .bold()
                    
                }
                .padding(.bottom, 80)
                
                //Campo para usuario
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(Color.black, lineWidth: 0.5) // Aplicamos el borde negro
                        )
                    
                    TextField("Introduce tu email", text: $email)
                        .keyboardType(.default)
                        .padding(.horizontal, 20)
                        .font(.title3)
                }
                .padding(.bottom, 8)
                
                //Campo para contraseña
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(Color.black, lineWidth: 0.5) // Aplicamos el borde negro
                        )
                    
                    SecureField("Introduce tu contaseña", text: $password)
                        .keyboardType(.emailAddress)
                        .padding(.horizontal, 20)
                        .font(.title3)
                }
                .padding(.bottom, 40)
                
                //Botón de iniciar sesion
                VStack {
                    Button {
                        authenticationViewModel.login(email: email, password: password)
                    } label: {
                        
                        Text("Iniciar sesión")
                            .bold()
                            .foregroundColor(.black)
                            .font(.title2)
                            .frame(width: 200, height: 50)
                    }
                }
                .background(.button)
                .cornerRadius(20)
                .padding(.bottom, 5)
                
                 
                if let messageError = authenticationViewModel.messageError {
                    
                    Text(messageError)
                        .bold()
                        .font(.system(size: 15))
                        .foregroundColor(.red)
                        .padding(12)
                }
                
                //Botón para la página de registro
                HStack {
                    Text("¿No tienes cuenta?")
                    
                    //pasamos por parametro la variable creada authenticacionViewModel
                    NavigationLink(destination: RegistroNuevoUsuario(authenticationViewModel: authenticationViewModel)){
                        Text("Registrate")
                            .foregroundColor(.button)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.backgroundApp)
            // Limpia el mensaje cuando la vista aparece
            .onAppear {
                authenticationViewModel.messageError = "" // Resetea el mensaje global
            }
        }
    }
}



    
#Preview {
    InicioSesion()
}
 
