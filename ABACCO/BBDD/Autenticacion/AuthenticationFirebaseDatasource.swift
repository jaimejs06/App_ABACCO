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
    var email: String
    
}

final class AuthenticationFirebaseDatasource{
    
    //Obtener usuario actual
    func getCurrentUser() -> User? {
        
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        return .init(uid: user.uid, email: user.email ?? "No tiene email")
    }
    
    //Función para reautenticarse y poder cambiar el email
    func reautenticacion(emailActual: String, contrasenaActual: String, completionBlock: @escaping (Result<Void, Error>) -> Void) {
        //guardamos el usuario actual
        guard let user = Auth.auth().currentUser else {
            completionBlock(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Usuario no autenticado"])))
            return
        }
        //obtenemos las credenciales del email y contraseña
        let credenciales = EmailAuthProvider.credential(withEmail: emailActual, password: contrasenaActual)
        //llamamos al metodo de firebase de reautenticacion
        user.reauthenticate(with: credenciales) { _, error in
            
            if let error = error {
                completionBlock(.failure(error))
            } else {
                completionBlock(.success(()))
            }
        }
        
    }
    
    //función que envia un email para verificacion al usuario
    func enviarEmail(to nuevoEmail: String, completionBlock: @escaping (Result<Void, Error>) -> Void){
        guard let user = Auth.auth().currentUser else {
            completionBlock(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Usuario no autenticado."])))
            return
        }
        //enviamos el enlace de verificación al correo nuevo
        user.sendEmailVerification(beforeUpdatingEmail: nuevoEmail) { error in
            
            if let error = error {
                completionBlock(.failure(error))
            } else {
                completionBlock(.success(()))
            }
        }
    }

    //Función que combina la reautenticacion y y envia un email de confirmación para cambiar el correo
    func cambiarCorreoUsuario(emailActual: String, contrasenaActual: String, nuevoCorreo: String, completionBlock: @escaping (Result<Void, Error>) -> Void) {
        
        reautenticacion(emailActual: emailActual, contrasenaActual: contrasenaActual) { result in
            switch result {
            case .success():
                //enviamos el enlace de verificacion
                self.enviarEmail(to: nuevoCorreo) { result in
                    switch result {
                    case .success():
                        print("Se ha enviado un mensaje al nuevo correo para verificar el cambio.")
                        completionBlock(.success(()))  // Aquí solo notificamos que se envió el email
                    case .failure(let error):
                        print("Error enviando el enlace de verificación: \(error.localizedDescription)")
                        completionBlock(.failure(error))
                    }
                }
            case .failure(let error):
                print("Error de reautenticación: \(error.localizedDescription)")
                completionBlock(.failure(error))
            }
        }
    }
    
    //Funcion para actualizar la contraseña
    func actualizarContrasena(to nuevaContrasena: String, completionBlock: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completionBlock(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Usuario no autenticado"])))
            return
        }
        
        //Actualizamos la contraseña
        user.updatePassword(to: nuevaContrasena) { error in
            if let error = error {
                completionBlock(.failure(error))
            } else {
                completionBlock(.success(()))
            }
        }
    }
    
    //funcion para autenticar y cambiar la contraseña del usuario
    func cambiarContrasenaUsuario(emailActual: String, contrasenaActual: String, nuevaContrasena: String, completionBlock: @escaping (Result<Void, Error>) -> Void) {
        
        // Reautenticación del usuario
        reautenticacion(emailActual: emailActual, contrasenaActual: contrasenaActual) { result in
            switch result {
            case .success():
                //LLamamos al metodo para actualizar la contraseña cuando se ha autenticado
                self.actualizarContrasena(to: nuevaContrasena) { result in
                    switch result {
                    case .success():
                        print("Contraseña actualizada correctamente.")
                        completionBlock(.success(()))
                    case .failure(let error):
                        print("Error al actualizar la contraseña: \(error.localizedDescription)")
                        completionBlock(.failure(error))
                    }
                }
            case .failure(let error):
                print("Error de reautenticación: \(error.localizedDescription)")
                completionBlock(.failure(error))
            }
        }
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



