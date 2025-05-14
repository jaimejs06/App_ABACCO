//
//  MenuSuperior.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 13/5/25.
//

import SwiftUI

//Botón para deslizar el menú lateral
struct MenuSuperior: View {
    
    @Binding var showMenu: Bool
    
    var body: some View {
            VStack {
                Button {
                    withAnimation {
                        showMenu.toggle()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 15, height: 15)
                        .bold()
                        .foregroundColor(.button)
                        .padding(.leading, 20)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            VStack {
                Image("ABACCO")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 25)
            }
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
