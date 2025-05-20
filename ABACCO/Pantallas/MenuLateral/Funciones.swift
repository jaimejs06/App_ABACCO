//
//  Funciones.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 20/5/25.
//

import UIKit

//función que guarda la imagen localmente
func guardarImagen(_ imagen: UIImage, userId: String) -> String? {
    //convertimos la imagen a jpeg
    guard let data = imagen.jpegData(compressionQuality: 0.8) else { return nil }
    
    //le otorgamos el nombre del usuario
    let nombreFoto = "\(userId).jpg"
    let url = obtenerURLImagen(nombre: nombreFoto)
    
    do {
        //escribimos los datos en la ruta
        try data.write(to: url)
        print("Imagen de perfil guardada")
        return nombreFoto
        
    } catch {
        print("Error al guardar la imagen de perfil")
        return nil
    }
}

//si existe el nombre de la imagen obtenemos la ruta
func cargarImagenDesdeArchivo(nombre: String) -> UIImage? {
    let url = obtenerURLImagen(nombre: nombre)
    return UIImage(contentsOfFile: url.path)
}

//obtenemos la ruta localmente añadiendo el nombre al final
func obtenerURLImagen(nombre: String) -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0].appendingPathComponent(nombre)
}
