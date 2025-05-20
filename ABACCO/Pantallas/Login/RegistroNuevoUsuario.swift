//
//  Registro.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 4/3/25.
//

import SwiftUI

struct RegistroNuevoUsuario: View {
    
    //Esperamos recibir una instancia de AuthenticationViewModel
    @ObservedObject var authenticationViewModel : AuthenticationViewModel
    var usuarioViewModel: UsuarioViewModel = UsuarioViewModel()
    
    @Environment(\.dismiss) var dismiss //Variable para cerrar la vista
    @State var password:String = ""
    @State var verificarContrasena:String = ""
    @State var email:String = ""
    @State var nombre:String = ""
    @State var apellidos:String = ""
    @State var pais:String = ""
    @State var ciudad:String = ""
    @State var telefono:String = ""
    @State var mensaje:String = ""
    
    var body: some View {
        VStack{
            
            
            Cajas(texto: "Email", imageName: "envelope.fill", datos: $email, keyboardType: .emailAddress)
            Cajas(texto:"Nombre", imageName:"person.fill", datos: $nombre)
            Cajas(texto: "Apellidos", imageName: "person.fill", datos: $apellidos)
            Cajas(texto: "País", imageName: "globe.central.south.asia.fill", datos: $pais)
            Cajas(texto: "Ciudad", imageName: "house.fill", datos: $ciudad)
            Cajas(texto: "Teléfono", imageName: "phone.fill", datos: $telefono, keyboardType: .phonePad)
            EstructuraContraseña(texto: "Contraseña", imageName: "lock.shield.fill", contrasena: $password)
            EstructuraContraseña(texto: "Verificar contraseña", imageName: "lock.shield.fill", contrasena: $verificarContrasena)
            
            
            //Botón para Registrarse
            HStack{
                VStack {
                    Button {
                        
                        //comprobamos que los campos no esten vacios
                        if nombre != "" && apellidos != "" && pais != "" && ciudad != "" && telefono != "" {
                            
                            //Comprobamos que las contraseñas sean iguales
                            if password == verificarContrasena{
                                
                                //creamos el nuevo usuario
                                authenticationViewModel.createNewUser(email: email, password: password) { result in
                                    
                                    switch result {
                                        
                                    case .success(let user):
                                        let userId = user.uid
                                        //Si el registro es exitoso, agregamos el usuario a Firestore
                                        let nuevoUsuario = Usuario(
                                            id: userId, //id del usuario actual
                                            email: email,
                                            nombre: nombre,
                                            apellidos: apellidos,
                                            pais: pais,
                                            ciudad: ciudad,
                                            telefono: telefono,
                                            instrumento: nil
                                        )
                                        
                                        usuarioViewModel.insertarUsuario(usuario: nuevoUsuario, userId: userId)
                                        self.mensaje = ""
                                        
                                    case .failure(let error):
                                        mensaje = "Error en el registro \(error.localizedDescription)"
                                    }
                                    //Limpiamos la variable mensaje
                                    self.mensaje = ""
                                }
                                
                            } else {
                                self.mensaje = "La contraseña no coincide"
                            }
                            //si algun campo esta vacio mostramos un mensaje
                        } else {
                            self.mensaje = ""
                            self.mensaje = "Debes rellenar todos los campos"
                        }
                        
                        } label: {
                            
                            Text("REGISTRARSE")
                                .bold()
                                .foregroundColor(.black)
                                .font(.title2)
                                .frame(width: 200, height: 50)
                    }
                }
                .background(.button)
                .cornerRadius(20)
                .padding(.bottom, 5)
            }
            .padding(.top, 10)
            
            //mensaje no coincidencia contraseña y campos vacios
            Mensaje(mensaje: mensaje)
            //mensaje error Firebase
            Mensaje(mensaje: authenticationViewModel.messageError)
                
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundApp)
        .navigationBarBackButtonHidden() //quitar el botón hacia atrás
        .toolbar{ //creamos nuestro propio toolbar con el color personalizado
            ToolbarItem(placement: .principal) {
                Text("Página de registro")
                    .padding(.top, 30)
                    .foregroundColor(.button.opacity(0.7))
                    .font(.system(size: 30))
    
            }
            //flecha hacia ventana principal
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()  //cierra la vista actual y regresa
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .bold()
                            .foregroundColor(.button)
                    }
                }
            }
        }
        // Limpia el mensaje cuando la vista aparece
        .onAppear {
            mensaje = ""
            authenticationViewModel.messageError = "" // Resetea el mensaje global
        }
    }
}

//Estructura para mostrar mensajes de error
struct Mensaje:View{
    //variable mensaje opcional
    var mensaje:String?
    var body:some View{
        
        VStack{
            //Comprobamos que no sea nil y también que no este vacio, si se cumple entra en el if
            if let mensaje = mensaje, !mensaje.isEmpty{
                Text(mensaje)
                    .bold()
                    .font(.system(size: 15))
                    .foregroundColor(.red)
                    .padding(.top, 5)
                    .multilineTextAlignment(.leading) // Permite que el texto se divida en varias líneas
            }
        }
    }
}

//Estructura para realizar el formulario de registro
struct Cajas:View {
    //variables que hay que pasar cuando se llame a la estructura
    var texto:String
    var imageName:String
    @Binding var datos:String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View{
        VStack{
            HStack{
                //panel para el emoticono
                ZStack {
                    Circle()
                        .opacity(0.1)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 0.5)
                        )
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30,height: 30)
                        .padding()
                }
                .frame(width: 50,height: 50)
                .padding(.trailing, 10) //margen solo lado derecho
                
                //panel para los datos
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(Color.black, lineWidth: 0.5) // Aplicamos el borde negro
                        )
                    TextField(texto, text: $datos)
                        .keyboardType(keyboardType)
                        .padding(.horizontal, 20)
                        .font(.title3)
                }
                .padding(.leading, 0) //margen solo lado izquierdo
            }
            .padding(.bottom, 10) //margenes entre cajas
        }
    }
}
//Estructura para la contraseña
struct EstructuraContraseña:View{
    var texto:String
    @State var imageName:String
    @Binding var contrasena:String
    
    var body: some View{
        //Caja específica para la contraseña
        HStack{
            ZStack {
                Circle()
                    .opacity(0.1)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30,height: 30)
                    .padding()
            }
            .frame(width: 50,height: 50)
            .padding(.trailing, 10) //margen solo lado derecho
            
            //panel para los datos
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.texfield)
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                            .stroke(Color.black, lineWidth: 0.5) // Aplicamos el borde negro
                    )
                SecureField(texto, text: $contrasena)
                    .keyboardType(.default)
                    .padding(.horizontal, 20)
                    .font(.title3)
            }
        }
        .padding(.bottom, 10) //margenes entre cajas
    }
}

#Preview {
    RegistroNuevoUsuario(authenticationViewModel: AuthenticationViewModel())
}
