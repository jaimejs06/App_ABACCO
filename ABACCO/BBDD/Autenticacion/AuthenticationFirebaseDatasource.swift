//
//  AuthenticationFirebaseDatasource.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 5/3/25.
//

import Foundation
import FirebaseAuth

//Clase que define la logica para poder registrarse

//Estructura que contiene los atributos de un usuario
struct User {
    let uid: String
    let email: String

}

final class AuthenticationFirebaseDatasource{
    

    //Obtener usuario actual
    func getCurrentUser() -> User? {
        
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        return .init(uid: user.uid, email: user.email ?? "No tiene email")
    }
    
    
    //Funcion para crear un nuevo usuario
    func createNewUser(email:String, password:String, completionBlock: @escaping (Result<User, Error>) -> Void) { //completionBlock notifica a las capas superiores si el usuario reistrado si ha ido correctamente o error si no se ha completado el registro
        
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                print("Error creando al nuevo usuario \(error.localizedDescription)")
                completionBlock(.failure(error))
                return
            }
            guard let user = authDataResult?.user else {
                    
                completionBlock(.failure(NSError(domain: "AuthenticationFirebaseDatasource", code: -1, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener UID o email"])))
                return
            }
            let nuevoUsuario = User(uid: user.uid, email: user.email ?? "Sin email")
            print("Nuevo usuario creado con la informacion: Email: \(nuevoUsuario.email) y UID: \(nuevoUsuario.uid)")
            //Devolvemos el usuario correctamente
            completionBlock(.success(nuevoUsuario))
        }
    }
    
    //Funcion para iniciar sesión
    func login(email:String, password:String, completionBlock: @escaping (Result<User, Error>) -> Void) { //completionBlock notifica a las capas superiores si el usuario reistrado si ha ido correctamente o error si no se ha completado el registro
        
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                print("Error al iniciar sesión \(error.localizedDescription)")
                completionBlock(.failure(error))
                return
            }
            guard let user = authDataResult?.user else {
                    completionBlock(.failure(NSError(domain: "AuthenticationFirebaseDatasource", code: -1, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener UID o email"])))
                        return
            }
            let usuarioAutenticado = User(uid: user.uid, email: user.email ?? "Sin email")
            print("Inicio de sesión exitoso: UID: \(usuarioAutenticado.uid), Email: \(usuarioAutenticado.email)")
            //Se devuelve un User con UID y email
            completionBlock(.success(usuarioAutenticado))
            
        }
    }
    
    //Funcion para cerrar la sesión
    func logout() throws {
        try Auth.auth().signOut()
    }
    

    
    
}


