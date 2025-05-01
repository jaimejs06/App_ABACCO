//
//  ScrollVerticalPartituras.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 30/4/25.
//

import SwiftUI

struct ScrollVerticalPartituras: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var partituraViewModel: PartituraViewModel
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    //variable que almacena el titulo a buscar
    @State var buscador:String = ""
    
    //Variable que almacena las Partituras que contenga/coincida con el buscador
    var partiturasFiltradas: [Partitura] {
        if buscador.isEmpty {
            //si está vacio devolvemos todas
            return partituraViewModel.partituras
        } else {
            //realizamos un filtro en el que iteramos por el titulo
            return partituraViewModel.partituras.filter { partitura in
                partitura.titulo.lowercased().contains(buscador.lowercased())
            }
        }
    }

    var body: some View {
        VStack{
            //Título
            VStack{
                Text("Partituras")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.bottom, 4)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color("Button").opacity(0.4))
            
            //TextField para buscar las partituras
            VStack {
                TextField("", text: $buscador, prompt:
                            Text("Buscador...")
                    .font(.title3)
                    .foregroundColor(.gray.opacity(0.7)))
                .font(.title2)
                .padding(16) //padding interno
                .overlay(
                    RoundedRectangle(cornerRadius: 20) //un RoundedRectangle para el borde
                        .stroke(.button, lineWidth: 0.5) //Aplicamos el borde
                )
                .autocorrectionDisabled() //Desactivamos la autocorreccion
                .padding(10) //padding externo
            }
            
            //Lista de las partituras
            List {
                //Creamos una tarjeta por cada partitura que exista
                ForEach(partiturasFiltradas) { partitura in
                    //Comprobamos si el usuario es admin para mostrar la opción de eliminar
                    if isAdmin() {
                        PartituraTarjeta(partitura: partitura, anchura: 340, altura: 210 )
                            .swipeActions(edge: .trailing) { //hacemos que se desplace hacia la izquierda
                                Button(action: { //cuando desplazamos borramos la partitura
                                    partituraViewModel.borrarPartitura(partitura: partitura)
                                }, label : {
                                    Label("Eliminar", systemImage:"trash.fill")
                                })
                                .tint(.red)
                            }
                            .listRowSeparator(.hidden)   //quita la línea entre elementos
                            .frame(maxWidth: .infinity, alignment: .center) //centrado
                            .listRowBackground(Color.clear) //cada celda transparente
                        
                    } else {
                        PartituraTarjeta(partitura: partitura, anchura: 340, altura: 210 )
                            .listRowSeparator(.hidden)   //quita la línea entre elementos
                            .frame(maxWidth: .infinity, alignment: .center) //centrado
                            .listRowBackground(Color.clear) //cada celda transparente
                    }
                }
            }
            .listStyle(PlainListStyle()) //utiliza un estilo de lista plano para eliminar el espaciado adicional
            .padding(.horizontal, 20) //separacion lateral
            .scrollContentBackground(.hidden) //oculta el fondo de la lista
            .background(Color("BackgroundApp")) //otorgamos el mismo color de fondo
            
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
        .task {
            partituraViewModel.obtenerPartituras()
        }
    }
    //Función que comprueba si el usuario logueado es administrador
    func isAdmin() -> Bool {
        //obtenemos el usuario autenticado
        guard let userId = authenticationViewModel.user?.uid else {
            return false
        }
        //vemos en la coleccion de usuarios si es admin
        if let usuario = usuarioViewModel.usuario.first(where: { $0.id == userId }) {
            return usuario.isAdmin ?? false
        } else {
            return false
        }
    }
}

