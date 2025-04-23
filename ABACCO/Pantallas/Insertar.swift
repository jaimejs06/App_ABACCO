//
//  Añadir.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 29/4/25.
//

import SwiftUI

struct Insertar: View {
    
    var destino: AnyView // variable que se pasa al navegationLink
    
    var body: some View {
        
        NavigationLink(destination: destino){
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(.green)
                .bold()
                .padding()
            
        }
    }
}
