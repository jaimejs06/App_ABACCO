//
//  NoticiasDataSource.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 10/4/25.
//

import Foundation

import FirebaseFirestore

//Estructura que representa una notica en la BBDD
struct Noticia: Codable, Identifiable{
    @DocumentID var id: String?
    var titulo:String
    var descripcion:String
    var fecha:Date
    var escritorID:String //Es el Id del Usuario administrador que escribe la noticia
    var comentarios:[Comentario]? //Se añaden luego
    
}

//Estructura para almacenar los comentarios dentro de noticias
struct Comentario : Codable, Identifiable {
    @DocumentID var id: String?
    var mensaje: String?
    var fecha: Date?
    var usuarioID: String? // Aquí guardamos el ID del usuario que escribe el comentario
}

final class NoticiasDataSource {
    
    private let database = Firestore.firestore().collection("noticias") //conexion de la BBDD y la coleccion
    private let database2 = Firestore.firestore()
    private let coleccion = "noticias"
    
    
    //método para obtener las noticias
    func obtenerNoticias(completionblock: @escaping (Result<[Noticia], Error>) -> Void){
        //llamamos a la coleccion noticias
        
        database
            .order(by: "fecha", descending: false) //ordenar por fecha, la más reciente es la más antigua ya que coge el valor de la fecha de la publicación
            .addSnapshotListener { query, error in //actualiza en tiempo real
            if let error = error{
                print("Error al obtener las noticias \(error.localizedDescription)")
                completionblock(.failure(error))
                return
            }
            //si no hay error, obtenemos el documento si existen
            guard let documentos = query?.documents.compactMap({ $0 }) else {
                completionblock(.success([])) //si no existen devolvemos una lista vacía
                return
            }
            
            //Mapeamos la informacion que obtenemos de Firebase a la estructura de Usuario
            let noticia = documentos.map { try? $0.data(as: Noticia.self)}
                                   .compactMap { $0 } //evitamos que haya nil
            
            //--------
            //obtenemos los comentarios para cada noticia
            var noticiaConComentarios: [Noticia] = []
            let dispatchGroup = DispatchGroup() // lo utilizamos para esperar a recolectar todos los comentarios
            
            for var noticia in noticia {
                dispatchGroup.enter() //iniciamos para esperar a la consulta de los comentarios
                self.obtenerComentarios(noticiaId: noticia.id!) { comentarios in
                    noticia.comentarios = comentarios
                    noticiaConComentarios.append(noticia)
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main){
                completionblock(.success(noticiaConComentarios))
            }
            //completionblock(.success(noticia)) //pasamos las noticias a la siguiente capa
    
        }
    }
    //funcion para obtener los comentarios de la coleccion Noticias
    func obtenerComentarios (noticiaId: String, completionBlock: @escaping ([Comentario]) -> Void) {
        
        let comentarioREF = database.document(noticiaId).collection("comentarios") //Referencia de la sucolección comentarios, por su NoticiaId
            .order(by: "fecha", descending: true)
        
        comentarioREF.getDocuments() { querySnapshot, error in
            if let error = error { //si no encuentra comentarios se devuelve una lista vacia
                print("Error al obtener los comentarios \(error.localizedDescription)")
                completionBlock([])
                return
            }
            let comentarios = querySnapshot?.documents.compactMap { document in
                try? document.data(as: Comentario.self)
            } ?? []
            
            completionBlock(comentarios)
        }
    }
    
    //Función para insertar un comentario en la noticia
    func agregarComentario(noticiaId: String, comentario: Comentario, completionBlock: @escaping (Result<Void, Error>) -> Void) {
        
        let comentarioREF = database.document(noticiaId).collection("comentarios") //Referencia a la subcolección comentarios, por su noticiaID
        
        do {
            _ = try comentarioREF.addDocument(from: comentario) { error in //Convertimos el comentario en un documento de Firebase
                if let error = error {
                    print("Error al insertar el comentario: \(error.localizedDescription)")
                    completionBlock(.failure(error))
                } else {
                    print("Comentario agregado con éxito")
                    completionBlock(.success(()))
                }
            }
        } catch {
            print("Error al codificar el comentario: \(error.localizedDescription)")
            completionBlock(.failure(error))
        }
    }
    
    func insertarNoticia(noticia:Noticia, completionBlock: @escaping (Result<Void, Error>) -> Void) {
        do {
            let _ = try database.addDocument(from: noticia) { error in
                if let error = error {
                    print("Error al agregar la noticia")
                    completionBlock(.failure(error))
                } else {
                    print("Noticia agregada correctamente")
                    completionBlock(.success(()))
                }
                
            }
        } catch {
            print("No se ha podido agregar la noticia \(error.localizedDescription)")
            completionBlock(.failure(error))
        }
        
    }
    
    //función para borrar una noticia
    func borrarNoticia(noticia:Noticia){
        
        guard let documentId = noticia.id else {
            return
        }
        database2.collection(coleccion).document(documentId).delete()

    }


}

