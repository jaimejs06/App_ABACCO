//
//  CambioCiudad.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 21/5/25.
//

import SwiftUI

struct CambioCiudad: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    @State private var ciudad: String = ""
    
    
    @State private var mensajeExito: Bool = false
    @State private var mensajeError: Bool = false
    
    var body: some View {
        VStack {
            //Cabecera
            VStack{
                Text("Modificar ciudad")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.bottom, 4)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color("Button").opacity(0.4))
            
            //nombre ciudad
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                        )
                    
                    TextField("Nueva ciudad", text: $ciudad)
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
                Text("No se ha podido actualizar la ciudad")
                    .bold()
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }
            
            //mensaje de exito si se inserta la ciudad
            if mensajeExito {
                Text("Ciudad modificada correctamente")
                    .bold()
                    .foregroundColor(.green)
                    .padding(.top, 8)
                    .font(.system(size: 22))
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
        
        
        if !ciudad.isEmpty {
            //actualizamos la ciudad
            usuarioViewModel.actualizarCiudad(userID: authenticationViewModel.user?.uid ?? "", ciudad: ciudad)
            
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
        } else {
            
            mensajeError = true
        }
    }
}

