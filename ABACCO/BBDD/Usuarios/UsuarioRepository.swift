//
//  UsuarioRepository.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 19/3/25.
//

import Foundation

final class UsuarioRepository{
    
    private let usuarioDataSource:UsuarioDataSource
    
    //constructor de la clase
    init(usuarioDataSource: UsuarioDataSource = UsuarioDataSource()) {
        self.usuarioDataSource = usuarioDataSource
    }
    
    func obtenerUsuarios ( completionblock: @escaping (Result<[Usuario], Error>) -> Void){
        
        usuarioDataSource.obtenerUsuarios (completionblock: completionblock)
    }
    
    func insertarUsuario(usuario: Usuario, userId: String, completionBlock: @escaping (Result<Void, Error>) -> Void){
        
        usuarioDataSource.insertarUsuario(usuario: usuario, userId: userId, completionBlock: completionBlock)
    }
    
    func actualizarAdmin(usuarioID: String, isAdmin: Bool) {
        usuarioDataSource.actualizarAdmin(usuarioID: usuarioID, isAdmin: isAdmin)
    }
    
    func actualizarImagen(nombre: String, userId: String) {
        usuarioDataSource.actualizarImagen(nombre: nombre, userId: userId)
    }
    
    func actualizarInstrumento(instrumento:String, userId:String) {
        usuarioDataSource.actualizarInstrumento(instrumento: instrumento, userId: userId)
    }
}
