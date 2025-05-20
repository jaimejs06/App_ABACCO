//
//  AgregarNoticia.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 29/4/25.
//

import SwiftUI

struct AgregarNoticia: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var noticiaViewModel:NoticiasViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    @State var titulo:String = ""
    @State var descripcion:String = ""
    var fecha:Date = Date.now
    @State var escritorID: String = ""
    
    @State var mostrarMensajeError:Bool = false
    @State var mensajeExito:Bool = false
    
    var body: some View {
        
        VStack {
            //Cabecera
            VStack{
                Text("Añadir noticia")
                    .bold()
                    .font(.system(size: 32))
                    
            }
            .padding(.bottom, 4)
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color("Button").opacity(0.4))
            
            //Panel para introducir el titulo
            VStack{
                ZStack{

                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                        )
                    
                    TextField("Introduce el título", text: $titulo)
                        .padding(.horizontal, 20)
                        .font(.title3)
                    
                }
            }
            .padding()
            
            //Panel para la descripcion
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                        )
                    
                    TextField("Descripción...", text: $descripcion)
                        .padding(.horizontal, 20)
                }
            }
            .padding()
            
            //mensaje de error si falta algún campo
            if mostrarMensajeError {
                Text("Te falta agregar algún dato")
                    .bold()
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }
            
            //Boton para guardar el evento
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
            
            //mensaje de exito si se inserta la noticia
            if mensajeExito {
                Text("Noticia agregada")
                    .bold()
                    .foregroundColor(.green)
                    .padding(.top, 8)
                    .font(.system(size: 22))
                    .padding(20)
            }
            
            Spacer()
        }
        .onAppear {
            //asignamos el usuario actual a la variable cuando aparece la vista
            self.escritorID = authenticationViewModel.user?.uid ?? ""
            mensajeExito = false
        }
        .background(Color.backgroundApp)
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
    //función para guardar la noticia
    func guardar() {
        
        //comprobamos los campos
        if titulo.isEmpty || descripcion.isEmpty || escritorID.isEmpty  {
            mostrarMensajeError = true
            
        } else {
            
            //insertamos en la BBDD
            noticiaViewModel.insertarNoticia(noticia: Noticia(titulo: titulo, descripcion: descripcion, fecha: fecha, escritorID: escritorID))
            
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
            
            //Formateamos los valores una vez insertado, solo de los textfield
            titulo = ""
            descripcion = ""

        }
    }

}

