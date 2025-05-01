//
//  Eventos.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 30/4/25.
//

import SwiftUI

//Esta vista es para mostrar las tarjetas de eventos en el menú principal, ya que
//Como ya contiene un ScrollView No podemos utilizar la vista de ScrollMenuTarjetas
struct Eventos: View {
    
    @ObservedObject var eventosViewModel: EventosViewModel
    
    var body: some View {
        VStack{
            ForEach(eventosViewModel.eventos) { evento in
                TarjetaEvento(evento: evento, eventosViewModel: eventosViewModel)
            }
        }
    }
}

#Preview {
    Eventos(eventosViewModel: EventosViewModel())
}
