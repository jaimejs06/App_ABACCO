//
//  ScrollPartituras.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 29/4/25.
//

import SwiftUI

struct ScrollPartituras: View {
    
    @ObservedObject var partituraViewModel: PartituraViewModel
    
    var body: some View {
        VStack{
            //Scroll Horizontal
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    //Creamos una tarjeta por cada partitura que exista
                    ForEach(partituraViewModel.partituras) { partitura in
                        PartituraTarjeta(partitura: partitura, anchura: 220, altura: 190)
                    }
                }
                .padding(2) //separacion de todos los bordes
                .padding(.horizontal, 30) //separacion lateral
            }
        }
        .task {
            partituraViewModel.obtenerPartituras()
        }
    }
}

#Preview {
    ScrollPartituras(partituraViewModel: PartituraViewModel())
}
