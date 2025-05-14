//
//  AgregarPartitura.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 29/4/25.
//

import SwiftUI

struct AgregarPartitura: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var partituraViewModel: PartituraViewModel
    
    @State var URL: String = ""
    @State var titulo: String = ""
    @State var autor:String = ""
    @State var mostrarMensaje: Bool = false
    
    @State var mensajeExito:Bool = false
    
    var body: some View {
        VStack{
            
            //Cabecera
            VStack{
                Text("Añadir Partitura")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.bottom, 4)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color("Button").opacity(0.4))
            
            //Panel para el Título
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
            
            //Panel para el autor
            VStack{
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                        )
                    
                    TextField("Autor", text: $autor)
                        .padding(.horizontal, 20)
                        .font(.title3)
                    
                }
            }
            .padding()
            
            //Panel para la URL
            VStack{
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield)
                        .frame(height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                        )
                    
                    TextField("URL", text: $URL)
                        .padding(.horizontal, 20)
                        .font(.title3)
                    
                }
            }
            .padding()
            
            //Botón para insertar la Partitura en la BBDD
            Button {
                guardar()
                
            } label: {
                Label("Crear link", systemImage: "link")
            }
            .tint(.button).opacity(0.8)
            .controlSize(.regular)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            
            //mensaje de campos vacios
            if mostrarMensaje {
                Text("Te falta agregar algún dato")
                    .bold()
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }
            
            //mensaje de error al insertar en BBDD
            if (partituraViewModel.messageError != nil){
                
                Text(partituraViewModel.messageError!)
                    .bold()
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }
            
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
        
        //Comprobamos que existen datos
        if URL.isEmpty || titulo.isEmpty {
            //mostramos mensajae de error
            mostrarMensaje = true
        } else {
            
            //Creamos la partitura
            partituraViewModel.crearPartitura(partitura: Partitura(url: URL, titulo: titulo, autor: autor))
            
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
            
            //formateamos el TexField
            URL = ""
            titulo = ""
            autor = ""
            mostrarMensaje = false
        }
    }
}

#Preview {
    AgregarPartitura(partituraViewModel: PartituraViewModel())
}
