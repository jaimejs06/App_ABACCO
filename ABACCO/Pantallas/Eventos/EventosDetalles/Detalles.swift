//
//  Detalles2.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 9/5/25.
//

import SwiftUI
import MapKit

struct Detalles: View {
    
    var evento:Evento
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var eventosViewModel: EventosViewModel
    
    var body: some View {
        
        //region a mostrar
        let region: MapCameraPosition = .region(.init(center: .init(latitude: evento.ubicacion?.latitude ?? 37.2372656, longitude: evento.ubicacion?.longitude ?? -5.1047332), latitudinalMeters: 200, longitudinalMeters: 200))
        ScrollView(showsIndicators: false) {
            VStack{
                
                //Fecha del evento
                HStack{
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text(formatearFecha(evento.fecha))
                        .font(.system(size: 18))
                        .foregroundColor(.button)
                        .lineLimit(1)
                        .padding(.leading, 8)
                    Spacer()
                }
                
                Divider()
                
                //Hora del evento
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text(horaFecha(evento: evento))
                        .font(.system(size: 18))
                        .foregroundColor(.button)
                        .lineLimit(1)
                        .padding(.leading, 8)
                    Spacer()
                }
                
                Divider()
                
                //Panel para la ubicación
                VStack {
                    //lugar
                    HStack{
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                        Text(evento.lugar ?? "")
                            .font(.system(size: 18))
                            .lineLimit(1)
                            .foregroundColor(.button)
                            .padding(.leading, 8)
                        Spacer()
                    }
                }
                .padding(.bottom, 12)
                
                //Mapa
                VStack {
                    Map(initialPosition: region) {
                        Marker(evento.titulo, coordinate: CLLocationCoordinate2D(latitude: evento.ubicacion?.latitude ?? 0.0, longitude: evento.ubicacion?.longitude ?? 0.0))
                    }
                    .mapStyle(.hybrid)
                    .frame(height: 220)
                    .cornerRadius(15)
                    .padding(.bottom, 8)
                    
                    Button(action: abrirMapa) {
                        HStack {
                            Image(systemName: "location.fill")
                            Text("Cómo llegar")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.button)
                        //.frame(maxWidth: .infinity)
                        .cornerRadius(15)
                    }
                }
                
                //Descripcion del evento
                VStack {
                    Text("Descripción")
                        .bold()
                        .foregroundColor(.button.opacity(0.9))
                        .font(.system(size: 18))
                        .padding(.bottom, 4)
                    Text(evento.descripcion ?? "No existe descripción")
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                .padding(.top, 10)
                
                
                Spacer()
            }
        }
        .padding()
        .background(.backgroundApp)
        .cornerRadius(15)
        .frame(height: 450)
        
        PanelInferior(evento: evento, authenticationViewModel: authenticationViewModel, eventosViewModel: eventosViewModel)
    }
    
    //Función para cambiar la forma de la fecha
    func formatearFecha(_ date: Date) -> String {
        let nuevaFecha = DateFormatter()
        
        nuevaFecha.locale = Locale(identifier: "es_ES") //Cambiamos idioma a español
        nuevaFecha.dateStyle = .full //Cambiamos el formato a largo
        
        return nuevaFecha.string(from: date).capitalized
    }
    //función que devuelve la hora de la fecha
    func horaFecha(evento:Evento) -> String {
        let fecha = evento.fecha
        let hora = DateFormatter()
        hora.dateFormat = "HH:mm"
        return hora.string(from: fecha)
    }
    //Abre la aplicacion del mapa en las coordenadas especificadas
    func abrirMapa() {
        let latitude = evento.ubicacion?.latitude ?? 37.23364246770224
        let longitude = evento.ubicacion?.longitude ?? -5.0979836557080205
        let url = URL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)")!
        UIApplication.shared.open(url)
    }
}


struct PanelInferior: View {
    
    var evento:Evento
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var eventosViewModel: EventosViewModel
    @State private var estadoAsistencia: EstadoAsistencia = .ninguna
    
    var body: some View {
        
        VStack{
            HStack{
  
                switch estadoAsistencia {
                case .ninguna:
                    Text("Esperando respuesta...")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                case .asiste:
                    Text("Asistiré")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                case .noAsiste:
                    Text("No asistiré")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Botones(evento: evento, authenticationViewModel: authenticationViewModel, eventosViewModel: eventosViewModel)
                
            }
            .padding()
        }
        .background(.backgroundApp)
        .frame(width: 340, alignment: .bottom)
        .cornerRadius(15)
        .task{
            comprobarEstado()
        }
    }
    //funcion que comprueba en que estado se encuentra el usuario en el evento(asiste, no...)
    func comprobarEstado() {
        let userID = authenticationViewModel.user?.uid ?? ""
        
        eventosViewModel.comprobarAsistencia(eventoID: evento.id ?? "", userID: userID) { estado in //estado que se devuelve
            DispatchQueue.main.async { // hace que se ejecute en el hilo principal
                self.estadoAsistencia = estado
            }
        }
    }
}
