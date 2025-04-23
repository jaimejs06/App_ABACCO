//
//  Noticias2.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 22/4/25.
//

import SwiftUI

//Estructura central donde llamamos a la vista de Scroll de Noticias
struct Noticias4: View {
    
    @StateObject var noticiasViewModel: NoticiasViewModel = NoticiasViewModel()
    @StateObject var usuarioViewModel: UsuarioViewModel
    
    var body: some View {
        
        ScrollNoticias2(noticiasViewModel: noticiasViewModel, usuarioViewModel: usuarioViewModel)

    }
}


