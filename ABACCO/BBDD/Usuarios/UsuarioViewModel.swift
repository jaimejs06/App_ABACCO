//
//  UsuarioViewModel.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 19/3/25.
//

import Foundation


final class UsuarioViewModel: ObservableObject{
    
    //almacenar los usuarios
    @Published var usuario:[Usuario] = []
    //alamecenar los errores
    @Published var messageError: String?

    
    //instancia de usuarioRepository
    private let usuarioRepository: UsuarioRepository
    
    init(usuarioRepository: UsuarioRepository = UsuarioRepository()) {
        self.usuarioRepository = usuarioRepository
    }
    
    func obtenerUsuario(){
        usuarioRepository.obtenerUsuarios { [weak self] result in
            //obtenemos dos resultados
            switch result{
                //cuando es correcto el array de usuarios
            case .success(let usuarios):
                self?.usuario = usuarios // asignamos el array que devuelve el success
                
            case .failure(let error): //caso del error
                self?.messageError = error.localizedDescription
                
            }
        }
    }
    
    func insertarUsuario(usuario: Usuario, userId: String) {
        
        usuarioRepository.insertarUsuario(usuario: usuario, userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                
                switch result{
                case .success:
                    self?.obtenerUsuario() //refrescamos la lista de usuarios
                case .failure(let error):
                    self?.messageError = error.localizedDescription
                    
                }
                
            }
        }
    }
    
    func actualizarAdmin(usuarioID: String, isAdmin: Bool) {
        usuarioRepository.actualizarAdmin(usuarioID: usuarioID, isAdmin: isAdmin)
    }
    
    func actualizarImagen(nombre: String, userId: String) {
        usuarioRepository.actualizarImagen(nombre: nombre, userId: userId)
    }
    
    func actualizarInstrumento(instrumento:String, userId:String) {
        usuarioRepository.actualizarInstrumento(instrumento: instrumento, userId: userId)
    }
}

