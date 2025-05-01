//
//  Eventos.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 30/4/25.
//

import SwiftUI

struct Eventos: View {
    var body: some View {
        
        TarjetaEvento(evento: Evento(titulo: "Prueba", fecha: Date.now, categoria: "Actuacion", lugar: "Parada de autobús"))
    }
}

#Preview {
    Eventos()
}
