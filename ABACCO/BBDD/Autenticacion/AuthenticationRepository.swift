//
//  AuthenticationRepository.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 5/3/25.
//

import Foundation

final class AuthenticationRepository{
    
    private let authenticacionFirebaseDatasourse:AuthenticationFirebaseDatasource
    
    init(authenticacionFirebaseDatasourse: AuthenticationFirebaseDatasource = AuthenticationFirebaseDatasource()) {
        self.authenticacionFirebaseDatasourse = authenticacionFirebaseDatasourse
    }
    
    //Obtenemos el usuario actual
    func getCurrentUser() -> User? {
        authenticacionFirebaseDatasourse.getCurrentUser()
    }
    
    //Creamos un nuevo usuario
    func createNewUser(email:String, password:String, completionBlock: @escaping (Result<User, Error>) -> Void) {
        
        authenticacionFirebaseDatasourse.createNewUser(email: email, password: password, completionBlock: completionBlock )
    }
    
    //Hacemos login con usuario existente
    func login(email:String, password:String, completionBlock: @escaping (Result<User, Error>) -> Void) {
        
        authenticacionFirebaseDatasourse.login(email: email, password: password, completionBlock: completionBlock )
    }
    
    //Cerramos sesion
    func logout() throws{
        try authenticacionFirebaseDatasourse.logout()
    }
}
