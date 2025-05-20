//
//  ListaParticipantes.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 8/5/25.
//

import SwiftUI

struct ListaParticipantes: View {
    
    @Environment(\.dismiss) var dismiss
    var evento:Evento
    @ObservedObject var eventosViewModel: EventosViewModel
    @ObservedObject var usuarioViewModel: UsuarioViewModel
    
    var body: some View {
        //lista de asistentes
        List(obtenerAsistentes()) { usuario in
            HStack {
                
                //obtenemos el string de la imagen
                if let imagenName = usuario.imagenName, let uiImage = cargarImagenDesdeArchivo(nombre: imagenName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .padding(.trailing, 8)
                } else { // si no existe, mostramos la imagen por defecto
                    Image("defaultProfile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .padding(.trailing, 8)
                }
                
                Text(usuario.nombre + " " + usuario.apellidos)
                    .font(.system(size: 18))
                
            }
        }
                
    }
    //funcion que obtiene los usuarios por el id guardado en el array de asistentes
    func obtenerAsistentes() -> [Usuario] {
        let asistentesIDs = evento.asistentes
        let asistentes = usuarioViewModel.usuario.filter{ asistentesIDs?.contains($0.id ?? "") ?? false}
        return asistentes
    }
}


