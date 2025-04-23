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
    
    private let authenticacionRepository: AuthenticationRepository
    
    
    init(authenticacionRepository: AuthenticationRepository = AuthenticationRepository()) {
        self.authenticacionRepository = authenticacionRepository
        //si hay un usuario logeado abre su sesión
        getCurrentUser()
    }
    
    func getCurrentUser() {
        self.user = authenticacionRepository.getCurrentUser()
    }
    
    func createNewUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void){
        
        //creamos el usuario y almacenamos la respuesta en el result
        authenticacionRepository.createNewUser(email: email, password: password) { [weak self] result in
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
        authenticacionRepository.login(email: email, password: password) { [weak self] result in
            
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
            try authenticacionRepository.logout()
            self.user = nil
            self.messageError = "" // Reinicia los mensajes
        }catch{
            print("Error logout")
        }
    }

}
