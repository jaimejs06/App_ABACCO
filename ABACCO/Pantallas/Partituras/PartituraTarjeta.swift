//
//  TarjetaPartitura.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 29/4/25.
//

import SwiftUI

struct PartituraTarjeta: View {
    
    let partitura: Partitura
    
    var body: some View {
        VStack {
            //Título de la noticia
            Text(partitura.titulo.uppercased())
                .bold()
                .font(.system(size: 22))
                .padding(.bottom, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
            //Rectangulo separador
            Rectangle()
                .fill(Color.black)
                .frame(height: 2)
                .opacity(0.3)
            
            //Hacemos que quede pegado arriba
            Spacer()
        }
        .padding()
        .frame(width: 220, height: 190) //tamaño de la tarjeta
        .background(cambiarColor())
        .cornerRadius(12)
        .shadow(radius: 3)
        
    }
    
    //Función para obtener un color aleatorio cada vez que se llama a la tarjeta
    func cambiarColor() -> Color {
        return Color(
            red: Double.random(in: 0.4...1),
            green: Double.random(in: 0.4...1),
            blue: Double.random(in: 0.4...1)
        )
    }
}

#Preview {
    PartituraTarjeta(partitura: Partitura(id: "lknlkankd", url: "jskldl", titulo: "Concierto Oscar Navarro"))
}
