//
//  NoticiasDetalle.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 22/4/25.
//

import SwiftUI

//Esta estructura muestra toda la información de la noticia
struct NoticiasDetalle3: View {
    @Environment(\.dismiss) var dismiss
    
    var noticia: Noticia
    @ObservedObject var usuarioViewModel : UsuarioViewModel
   
    @ObservedObject var noticiasViewModel: NoticiasViewModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            //Titulo de la noticia
            VStack{
                Text(noticia.titulo.uppercased())
                    .bold()
                    .font(.system(size: 32))
                    
            }
            .padding(.bottom, 4)
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color("Button").opacity(0.4))
            
            
            if let usuario = usuarioViewModel.usuario.first(where: { $0.id == noticia.escritorID }){
                NoticiaAutor(nombre: usuario.nombre,
                              apellidos: usuario.apellidos,
                              foto: usuario.imagenName ?? "defaultProfile",
                              fecha: noticia.fecha) .padding()
                
            }
            
            
            Divider() //añadimos una linea separadora
            
            NoticiaDescripcion(descripcion: noticia.descripcion)
                .padding()
            
            Divider()
            
            
            NoticiaComentarios(comentarios: noticia.comentarios, usuarioViewModel: usuarioViewModel, noticiaId: noticia.id ?? "", noticiasViewModel: noticiasViewModel)
                .padding()
            
            Spacer()
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
}

//Autor de la noticia
struct NoticiaAutor: View {
    var nombre: String
    var apellidos: String
    var foto: String
    var fecha: Date
    var body: some View {
        VStack {
            HStack {
                Image(foto )
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                    .padding(.leading, 2)
                
                Text(nombre + " " + apellidos)
                
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.bottom, 2)
            
            Text(fecha, style: .date)
                .font(.system(size: 10))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.bottom, 2)
    }
}

//Descripcion de la noticia
struct NoticiaDescripcion: View {
    var descripcion: String
    
    var body: some View {
        Text(descripcion)
            .font(.system(size: 20))
            .padding(.bottom, 6)
    }
}

//Vista para los comentarios
struct NoticiaComentarios: View {
    var comentarios: [Comentario]?
    @ObservedObject var usuarioViewModel : UsuarioViewModel
    @State var textoComentario: String = ""
    
    let noticiaId:String

    @ObservedObject var noticiasViewModel: NoticiasViewModel
    
    let authenticationViewModel: AuthenticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        VStack {
            Text("COMENTARIOS")
                .bold()
                .font(.system(size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
            
            //Panel para el texfiel de introducir comentarios
            HStack{
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.texfield.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                                .stroke(Color.black, lineWidth: 0.3) // Aplicamos el borde negro
                        )
                    
                    TextField("Introducir un comentario", text: $textoComentario)
                        .padding(.horizontal, 20)
                        .font(.system(size: 16))
                        
                }
                .frame(height: 35)
                
                //panel para el emoticono de enviar
                Button(action: {
                    if let userId = authenticationViewModel.user?.uid{ //obtenemos el id del usuarioActual
                        let nuevoComentario = Comentario(
                            id: nil,
                            mensaje: textoComentario,
                            fecha: Date.now,
                            usuarioID: userId //pasamos el idActual, que escribe el comentario
                        )
                        
                        //Llamamos al metodo para insertar el comentario
                        noticiasViewModel.agregarComentario(noticiaId: noticiaId, comentario: nuevoComentario)
                        
                        textoComentario = "" 
                            
                        
                    }
                }) {
                    ZStack {
                        Circle()
                            .opacity(0.1)
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 0.5)
                            )
                        Image(systemName: "paperplane")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20,height: 20)
                            .foregroundColor(.button)
                    }
                    .frame(width: 35, height: 35)
                }
            }
            
            //Si hay comentarios, los mostramos
            if let comentarios = comentarios {
                ForEach(comentarios, id: \.id) { comentario in
                    VStack {
                        
                        if let usuario = obtenerUsuarioPorId(id: comentario.usuarioID ?? " ") {
                            Text(usuario.nombre + " " + usuario.apellidos + ":")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .italic()
                                .padding(.top, 5)
                                .padding(.leading, 8)
                                //.padding(.bottom, 1)
                                .font(.system(size: 14))
                        }
                        
                        if let comentarioTexto = comentario.mensaje {
                            ComentarioTexto(texto: comentarioTexto)
                        }
                    }
                    
                    
                    if let fecha = comentario.fecha {
                        Text(fecha, style: .date)
                            .font(.system(size: 10))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
        }
    }
    func obtenerUsuarioPorId(id: String) -> Usuario? {
        return usuarioViewModel.usuario.first(where: { $0.id == id })
    }
}


//Texto del comentario
struct ComentarioTexto: View {
    var texto: String
    
    var body: some View {
        Text(texto)
            .font(.system(size: 14))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 18)
            .padding(.trailing, 6)
            .foregroundColor(.gray)
    }
}



