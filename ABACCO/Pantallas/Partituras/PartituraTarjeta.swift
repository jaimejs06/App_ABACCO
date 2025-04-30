//
//  TarjetaPartitura.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 29/4/25.
//

import SwiftUI

struct PartituraTarjeta: View {
    
    let partitura: Partitura
    
    @State var anchura:Int
    @State var altura:Int
    
    var body: some View {
        VStack {
            //Hacemos que las tarjetas sean de tipo link, para que nos dirija hacia la URL
            Link(destination: URL(string: partitura.url)!, label: {
                
                VStack{
                    //Título de la partitura
                    Text(partitura.titulo.uppercased())
                        .bold()
                        .font(.system(size: 22))
                        .padding(.bottom, 3)
                        .lineLimit(2)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(partitura.autor?.capitalized ?? "")
                        .font(.system(size: 12))
                        .padding(.bottom, 6)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(.black)
                    
                    //Linea separadora
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 2)
                        .opacity(0.3)
                    
                    //Hacemos que quede pegado arriba
                    Spacer()
                }
            })
        }
        .padding()
        .frame(width: CGFloat(anchura), height: CGFloat(altura)) //tamaño de la tarjeta 220 190
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


