//
//  NoticiasRepository.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 10/4/25.
//

import Foundation

final class NoticiasRepository {
    
    private let noticiasDataSource:NoticiasDataSource
    
    init(noticiasDataSource: NoticiasDataSource = NoticiasDataSource()){
        self.noticiasDataSource = noticiasDataSource
    }
    
    func obtenerNoticias (completionblock: @escaping (Result<[Noticia], Error>) -> Void){
        
        noticiasDataSource.obtenerNoticias(completionblock: completionblock)
    }
    
    //Función para insertar un comentario en la noticia
    func agregarComentario(noticiaId: String, comentario: Comentario, completionBlock: @escaping (Result<Void, Error>) -> Void) {
        noticiasDataSource.agregarComentario(noticiaId: noticiaId, comentario: comentario, completionBlock: completionBlock)
    }
    
    func insertarNoticia(noticia:Noticia, completionBlock: @escaping (Result<Void, Error>) -> Void) {
        noticiasDataSource.insertarNoticia(noticia: noticia, completionBlock: completionBlock)
    }
    //función para borrar una noticia
    func borrarNoticia(noticia:Noticia){
        noticiasDataSource.borrarNoticia(noticia: noticia)
    }
    
}
