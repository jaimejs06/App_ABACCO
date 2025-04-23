//
//  NoticiaTarjeta.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 22/4/25.
//

import SwiftUI

//Estructura de diseño para mostrar en la pantalla principal pequeñas tarjetas pertenecientes a las noticias
struct NoticiaTarjeta1: View {
    
    var noticia: Noticia
    var autor: Usuario?
    
    var body: some View {
        VStack {
            //Título de la noticia
            Text(noticia.titulo.uppercased())
                .bold()
                .font(.system(size: 26))
                .padding(.bottom, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
            
            //panel para el nombre e imagen del autor
            HStack {
                Image(autor?.imagenName ?? "defaultProfile" )
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                    .padding(.leading, 2)
                
                if let autor = autor {
                    Text(autor.nombre + " " + autor.apellidos)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.bottom, 2)
            
            //fecha de la publicacion de la noticia
            Text(noticia.fecha, style: .date)
                .font(.system(size: 8))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 6)
            
            //descripcion de la noticia
            Text(noticia.descripcion)
                .font(.system(size: 20))
                .lineLimit(3)
            
        }
        .padding()
        .frame(width: 320) //tamaño de la tarjeta
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
        
    }
}


