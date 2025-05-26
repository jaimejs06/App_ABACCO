//
//  UsuarioDataSource.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 19/3/25.
//

import Foundation

import FirebaseFirestore
import FirebaseAuth

//Estructura que representa un usuario en la base de datos
struct Usuario: Codable, Identifiable{
    @DocumentID var id: String?
    var email:String
    var nombre:String
    var apellidos:String
    var pais:String
    var ciudad:String
    var telefono:String
    var fNacimiento:Date?
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
    //Función para actualizar el campo de admin de un usuario
    func actualizarAdmin(usuarioID: String, isAdmin: Bool) {
        
        let admin = database.document(usuarioID)
        
        admin.updateData(["isAdmin": isAdmin]) { error in
            if let error = error {
                print("Error al actualizar el rol: \(error.localizedDescription)")
            } else {
                print("Rol actualizado")
            }
        }
    }
    //función para actualiar la imagen de perfil
    func actualizarImagen(nombre: String, userId: String) {
        database.document(userId).updateData(["imagenName": nombre]) { error in
            if let error = error {
                print("Error al actualizar el la imagen de perfil: \(error.localizedDescription)")
            } else {
                print("Imagen del perfil actualizada")
            }
        }
    }
    //función para actualizar el isntrumento
    func actualizarInstrumento(instrumento:String, userId:String) {
        database.document(userId).updateData(["instrumento": instrumento]) { error in
            if let error = error {
                print("Error al actualizar el instrumento: \(error.localizedDescription)")
            } else {
                print("Instrumento actualizado")
            }
        }
    }
    //Función para actualizar el nombre y apellido de un usuario
    func actualizarNombre(userId: String, nuevoNombre: String, nuevoApellido: String) {
        
        database.document(userId).updateData(["nombre": nuevoNombre, "apellidos": nuevoApellido]) { error in
            if let error = error {
                print("Error al actualizar el nombre: \(error.localizedDescription)")
            } else {
                print("Nombre actualizado")
            }
        }
    }
    //Función para actualiar el email
    func actualizarEmail(userId: String, nuevoEmail: String) {
        database.document(userId).updateData(["email": nuevoEmail]) { error in
            if let error = error {
                print("Error al actualizar el email: \(error.localizedDescription)")
            } else {
                print("Email actualizado")
            }
        }
    }
    
    func actualizarFechaNacimiento(userID: String, fechaNacimiento: Date) {
        database.document(userID).updateData(["fNacimiento": fechaNacimiento]) { error in
            if let error = error {
                print("Error al actualizar la fecha de nacimiento: \(error.localizedDescription)")
            } else {
                print("Fecha de nacimiento actualizada")
            }
        }
    }
    
    func actualizarCiudad(userID: String, ciudad: String) {
        database.document(userID).updateData(["ciudad": ciudad]) { error in
            if let error = error {
                print("Error al actualizar la ciudad: \(error.localizedDescription)")
            } else {
                print("Ciudad actualizada")
            }
        }
    }
    
}
