//
//  AuthenticationViewModel.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 5/3/25.
//

import Foundation

final class AuthenticationViewModel: ObservableObject{
    
    @Published var user: User?
    @Published var messageError: String?
    
    private let authenticationRepository: AuthenticationRepository
    
    
    init(authenticationRepository: AuthenticationRepository = AuthenticationRepository()) {
        self.authenticationRepository = authenticationRepository
        //si hay un usuario logeado abre su sesión
        getCurrentUser()
    }
    
    func cambiarCorreoUsuario(emailActual: String, contrasenaActual: String, nuevoCorreo: String, completionBlock: @escaping (Result<Void, Error>) -> Void) {
        authenticationRepository.cambiarCorreoUsuario(emailActual: emailActual, contrasenaActual: contrasenaActual, nuevoCorreo: nuevoCorreo, completionblock: completionBlock)
    }
    
    func cambiarContrasenaUsuario(emailActual: String, contrasenaActual: String, nuevaContrasena: String, completionBlock: @escaping (Result<Void, Error>) -> Void) {
        authenticationRepository.cambiarContrasenaUsuario(emailActual: emailActual, contrasenaActual: contrasenaActual, nuevaContrasena: nuevaContrasena, completionBlock: completionBlock)
    }
    
    func getCurrentUser() {
        self.user = authenticationRepository.getCurrentUser()
    }
    
    func createNewUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void){
        
        //creamos el usuario y almacenamos la respuesta en el result
        authenticationRepository.createNewUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                    completion(.success(user))
                case .failure(let error):
                    self?.messageError = error.localizedDescription
                    completion(.failure(error))
                
                }
            }
        }
    }

    
    func login(email: String, password: String){
        
        //creamos el usuario y almacenamos la respuesta en el result
        authenticationRepository.login(email: email, password: password) { [weak self] result in
            
            //? hace que sea opcional
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                self?.messageError = error.localizedDescription
            }
            
        }
    }
    
    func logout(){
        do{
            try authenticationRepository.logout()
            self.user = nil
            self.messageError = "" // Reinicia los mensajes
        }catch{
            print("Error logout")
        }
    }

}
