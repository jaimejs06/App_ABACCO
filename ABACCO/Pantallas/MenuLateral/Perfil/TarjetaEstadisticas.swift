//
//  TarjetaEstadisticas.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 20/5/25.
//

import SwiftUI

struct TarjetaEstadisticas:View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var eventosViewModel: EventosViewModel
    
    var body: some View {
        HStack {
            TarjetaEstadisticasEnsayos(authenticationViewModel: authenticationViewModel, eventosViewModel: eventosViewModel)
            
            Spacer()
            
            TarjetaEstadisticasActuaciones(authenticationViewModel: authenticationViewModel, eventosViewModel: eventosViewModel)
        }
        .padding()
    }
}
//Tarjeta para mostrar las estadisticas de los ensayos
struct TarjetaEstadisticasEnsayos: View {
    
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var eventosViewModel: EventosViewModel
    
    var body: some View {
        
        let userId = authenticationViewModel.user?.uid ?? ""
        let resumen = eventosViewModel.obtenerResumenAsistencia(userId: userId)
        let porcentajeEnsayo = calcularPorcentaje(asistidos: resumen.asistidosEnsayo, total: resumen.totalEnsayos)
       
        
        VStack {
            Text("Ensayos")
                .bold()
                .padding(.bottom, 10)
            
            HStack {
                Text("\(porcentajeEnsayo)% asistencia")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .lineLimit(1)
                   
                
                Spacer()
                
                Text("\(resumen.asistidosEnsayo) / \(resumen.totalEnsayos)")
                    .bold()
            }
        }
        .padding()
        .frame(width: 160, height: 90)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.button).opacity(0.3)
        )
    }
    
    func calcularPorcentaje(asistidos: Int, total: Int) -> Int {
        guard total > 0 else { return 0 }
        return Int((Double(asistidos) / Double(total)) * 100)
    }

}

//Tarjeta para mostrar las estadisticas de las Actuaciones
struct TarjetaEstadisticasActuaciones: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var eventosViewModel: EventosViewModel
    
    var body: some View {
        
        let userId = authenticationViewModel.user?.uid ?? ""
        let resumen = eventosViewModel.obtenerResumenAsistencia(userId: userId)
        let porcentajeActuaciones = calcularPorcentaje(asistidos: resumen.asistidosActuacion, total: resumen.totalActuaciones)
        
        VStack {
            Text("Actuaciones")
                .bold()
                .padding(.bottom, 10)
            
            HStack {
                Text("\(porcentajeActuaciones)% asistencia")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .lineLimit(1)
                
                Spacer()
                
                Text("\(resumen.asistidosActuacion) / \(resumen.totalActuaciones)")
                    .bold()
            }
        }
        .padding()
        .frame(width: 160, height: 90)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.button).opacity(0.3)
        )
    }
    
    func calcularPorcentaje(asistidos: Int, total: Int) -> Int {
        guard total > 0 else { return 0 }
        return Int((Double(asistidos) / Double(total)) * 100)
    }
    
}

struct ResumenAsistencia {
    var totalEnsayos: Int = 0
    var asistidosEnsayo: Int = 0
    var totalActuaciones: Int = 0
    var asistidosActuacion: Int = 0
}


