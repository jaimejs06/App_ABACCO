//
//  FechaNacimiento.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 21/5/25.
//

import SwiftUI

struct FechaNacimiento: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    @State var fechaNacimiento: String = ""
    
    @State private var mensajeExito: Bool = false
    @State private var mensajeError: Bool = false
    
    var body: some View {
        VStack {
            //Cabecera
            VStack{
                Text("Modificar fecha de nacimiento")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.bottom, 4)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color("Button").opacity(0.4))
            
            //Fecha de nacimiento
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                        )
                    
                    TextField("dd/mm/yyyy", text: $fechaNacimiento)
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
            
            //Mostramos un mensaje de error
            if mensajeError {
                Text("No se ha podido actualizar la fecha de nacimiento, introduce una fecha válida")
                    .bold()
                    .foregroundColor(.red)
                    .padding(.top, 8)
                    .padding(.horizontal, 10)
            }
            
            //mensaje de exito si se modifica el email correctamente
            if mensajeExito {
                Text("Fecha de nacimiento actualizada correctamente")
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
        .onAppear {
            //obtenemos la fecha de nacimiento al cargar la pagina
            fechaNacimiento = obtenerfNacimiento()
        }
    }
    func guardar() {
        //formateamos la fecha
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" //dia/mes/año
        dateFormatter.locale = Locale(identifier: "es") //español
        
        //Comprobamos que el formato sea válido
        guard let fecha = dateFormatter.date(from: fechaNacimiento) else {
            withAnimation{
                mensajeError = true
            }
            return
        }
        //Comprobamos que no sea una fecha futura
        if fecha > Date() {
            // Fecha futura no permitida
            withAnimation {
                mensajeError = true
                mensajeExito = false
            }
            return
        }
        
        //si la fecha es válida y no futura guardamos
        usuarioViewModel.actualizarFechaNacimiento(userID: authenticationViewModel.user?.uid ?? "", fechaNacimiento: fecha)
        
        //aparece el mensaje de exito
        withAnimation {
            mensajeExito = true
            mensajeError = false
        }
        
        //Hacemos que desaparezca cuando pasen 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                mensajeExito = false
            }
        }
    }
    
    //Funcion que comprueba la fecha Nacimiento
    func obtenerfNacimiento() -> (String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" //dia/mes/año
        dateFormatter.locale = Locale(identifier: "es") //español
        
        
        guard let userId = authenticationViewModel.user?.uid else {
            return ("Usuario no encontrado")
        }
        
        if let usuario = usuarioViewModel.usuario.first(where: { $0.id == userId }) {
            if let fecha = usuario.fNacimiento {
                let fechaTexto = dateFormatter.string(from: fecha) //convertimos la fecha a string
                return fechaTexto
            } else {
                return ""
            }
            
        } else {
            return ("Usuario no encontrado")
        }
    }

}


