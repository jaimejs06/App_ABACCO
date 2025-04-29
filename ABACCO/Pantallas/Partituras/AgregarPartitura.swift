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
    @State var mostrarMensaje: Bool = false
    
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
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde negro
                        )
                    
                    TextField("Introduce el título", text: $titulo)
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
                                .stroke(.button, lineWidth: 0.5) // Aplicamos el borde negro
                        )
                    
                    TextField("URL", text: $URL)
                        .padding(.horizontal, 20)
                        .font(.title3)
                    
                }
            }
            .padding()
            
            //Botón para insertar la Partitura en la BBDD
            Button {
                //Comprobamos que existen datos
                if URL.isEmpty || titulo.isEmpty {
                    
                    //mostramos mensjae de error
                    mostrarMensaje = true
                    
                } else {
                    
                    partituraViewModel.crearPartitura(partitura: Partitura(url: URL, titulo: titulo))
                    
                    //formateamos el TexField
                    URL = ""
                    titulo = ""
                    mostrarMensaje = false
                }
                
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
}

#Preview {
    AgregarPartitura(partituraViewModel: PartituraViewModel())
}
