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
    
    @State var fechaNacimiento: Date = Date()
    
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
            
            Fecha(fecha: $fechaNacimiento)
            
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
                Text("No se ha podido actualizar la fecha de nacimiento")
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
    }
    func guardar() {
        //si la fecha es menor que la de hoy
        if fechaNacimiento < Date.now {
            //Actualizamos la fecha de nacimiento
            usuarioViewModel.actualizarFechaNacimiento(userID: authenticationViewModel.user?.uid ?? "", fechaNacimiento: fechaNacimiento)
            
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
            
        } else {
            mensajeError = true
        }
    }

}

struct Fecha:View {
    @Binding var fecha: Date
    var body: some View {
        VStack{
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.texfield)
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("Button"), lineWidth: 0.5)
                    )
                
                //hacemos que solo se pueda seleccionar desde hoy
                DatePicker("Fecha de nacimiento", selection: $fecha, in: ...Date(), displayedComponents: [.date])
                    .accentColor(Color("Button").opacity(0.4)) //color del selector
                    .padding(.horizontal, 20)
                    .environment(\.locale, Locale(identifier: "es")) //Forzamos que aparezca en español
            }
        }
        .padding(.horizontal, 15)
    }
}
