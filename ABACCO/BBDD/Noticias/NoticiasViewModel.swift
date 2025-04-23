//
//  NoticiasViewModel.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 10/4/25.
//

import Foundation

final class NoticiasViewModel: ObservableObject {
    //almacenar las noticias
    @Published var noticias:[Noticia] = []
    //alamecenar los errores
    @Published var messageError: String?
    
    //instaciamos el repository
    private var noticiasRepository:NoticiasRepository
    
    init(noticiasRepository:NoticiasRepository = NoticiasRepository()) {
        self.noticiasRepository = noticiasRepository
    }
    
    func obtenerNoticias(){
        noticiasRepository.obtenerNoticias { [weak self] result in
            //obtenemos dos resultados
            switch result{
                //cuando es correcto el array de noticias
            case .success(let noticias):
                self?.noticias = noticias // asignamos el array que devuelve el success
                
            case .failure(let error): //caso del error
                self?.messageError = error.localizedDescription
                
            }
        }
    }
    func agregarComentario(noticiaId: String, comentario: Comentario){
        noticiasRepository.agregarComentario(noticiaId: noticiaId, comentario: comentario) { [weak self] result in
            switch result {
            case .success:
                self?.obtenerNoticias() //refrescamos la noticia para que salgan los nuevos comentarios
            case .failure(let error):
                self?.messageError = error.localizedDescription
            }
            
        }
    }
}
