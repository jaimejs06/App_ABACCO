//
//  UsuarioDataSource.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 19/3/25.
//

import Foundation

import FirebaseFirestore

//Estructura que representa un usuario en la base de datos
struct Usuario: Codable, Identifiable{
    @DocumentID var id: String?
    var email:String
    var nombre:String
    var apellidos:String
    var pais:String
    var ciudad:String
    var telefono:String
    var instrumento:String? //hacemos que el valor de instrumento sea opcional
    var imagenName:String?
    var isAdmin:Bool?
}

final class UsuarioDataSource{
    
    private let database = Firestore.firestore().collection("usuarios") //conexion de la BBDD y la coleccion
    
    //metodo para obtener los usuarios
    func obtenerUsuarios(completionblock: @escaping (Result<[Usuario], Error>) -> Void){
        //llamamos a la coleccion usuarios
        database.addSnapshotListener { query, error in
                if let error = error{
                    print("Error al obtener los usuarios \(error.localizedDescription)")
                    completionblock(.failure(error))
                    return
                }
                //si no hay error, obtenemos el documento si existen
                guard let documento = query?.documents.compactMap({ $0 }) else {
                    completionblock(.success([])) //si no existen devolvemos una lista vacía
                    return
                }
                //Mapeamos la informacion que obtenemos de Firebase a la estructura de Usuario
                let usuario = documento.map { try? $0.data(as: Usuario.self)}
                                       .compactMap { $0 } //evitamos que haya nil
                
                completionblock(.success(usuario)) //pasamos los usuarios a la siguiente capa
                
            }
    }
    
    //metodo para insertar un usuario en Firestore, pasando el usuario por parametro
    func insertarUsuario(usuario: Usuario, userId: String,  completionBlock: @escaping (Result<Void, Error>) -> Void){
        do{
            //convertimos usuario en un diccionario para firebase
            let usuarioData = try Firestore.Encoder().encode(usuario)
            
            //agregamos el usuario a la colección usuarios
            database.document(userId).setData(usuarioData) { error in
                if let error = error {
                    print("Error al guardar usuario en Firebase \(error.localizedDescription)")
                    completionBlock(.failure(error))
                }else{
                    print("Usuario añadido correctamente")
                    completionBlock(.success(()))
                }
            }
        } catch {
            print("Error al codificar el formato de usuario \(error.localizedDescription)")
            completionBlock(.failure(error))
        }
        
    }
    
}
