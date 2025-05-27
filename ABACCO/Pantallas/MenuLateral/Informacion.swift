//
//  Informacion.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 30/4/25.
//

import SwiftUI
import MapKit

struct Informacion: View {
    @Environment(\.dismiss) var dismiss
    
    //variable para mostrar o no el texto de la historia
    @State var mostrarTexto:Bool = false
    
    //Variable para situar el mapa
    @State private var region: MapCameraPosition = .region(.init(center: .init(latitude: 37.23364246770224, longitude: -5.0979836557080205), latitudinalMeters: 150, longitudinalMeters: 150))
    
    var body: some View {


            ScrollView(showsIndicators: false) {
                VStack{
                    //Imagen
                    VStack {
                        Image("bmvo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                        
                        Text("Banda de Música Villa de Osuna")
                            .bold()
                            .font(.system(size: 18))
                        
                        Text("Osuna, Sevilla")
                            .bold()
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .padding(.top, 8)
                    //Historia
                    VStack{
                        Text("Historia")
                            .bold()
                            .font(.system(size: 22))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            Text("La Villa Ducal de Osuna mantiene una relación con la música desde tiempos inmemoriales. El relieve ibérico «La Flautista de Osuna» del siglo III a.C., o haber sido cuna de nombres tan importantes en la música de España como Alonso Lobo, Manuel Infante Buera o Pepe Romero, así lo atestiguan.\nLa Banda Municipal de Música de Osuna tiene sus orígenes en el siglo XIX, producto de la unión de diferentes sociedades musicales, siendo conocida en el siglo XX como «Banda del Maestro Cuevas» hasta su disolución en 1976.\nLa refundación de la Banda Municipal de Osuna se produce en noviembre de 1991, cuando el Ilustre Ayuntamiento de Osuna le confía la tarea al maestro carmonense D. Manuel Fernández Manzanar, quien comienza a trabajar con treinta y cinco educandos de edades comprendidas entre los 9 y los 15 años, enseñándoles solfeo elemental e instrumentos, quedando así configurada para intervenir en público varios meses después.\nLa presentación tuvo lugar el 10 de Enero de 1993. Desde entonces ha ido interviniendo de manera brillante en cientos de actos populares, culturales y religiosos tanto de Osuna como de otras poblaciones de la provincia de Sevilla y de Andalucía.\nEntre sus muchas actuaciones cabe destacar su participación en el Circuito de Música por la Provincia de la Diputación Provincial de Sevilla, el Programa de la Fundación Cajasol, el Curso de Temas Sevillanos del Ateneo Hispalense, certámenes en todo el territorio andaluz y procesiones de Semana Santa y Gloria en lugares tan destacados como Sevilla, Málaga, Córdoba, Almería, San Fernando, Torredonjimeno, Ronda, Algeciras, Camas, Gibraleón, Osuna, y un largo etcétera. La plantilla actual está formada por 80 músicos de ambos sexos y de todas las edades que, con tremenda ilusión y entrega, compaginan otros estudios con los musicales que realizan en la propia Escuela de Música de la banda, así como en distintos conservatorios profesionales de la provincia o los superiores de Andalucía.\nDesde el año 2012 ostenta la dirección D. Isidro Pérez Jiménez, natural de Osuna y profesor de clarinete del cuerpo de profesores de música y artes escénicas. En esta misma fecha, la Banda Municipal de Osuna pasó a denominarse Asociación Cultural Banda de Música Villa de Osuna, nombre que recibe en la actualidad.")
                                .font(.system(size: 14))
                                .lineLimit(mostrarTexto ? nil : 7)
                                .animation(.easeInOut, value: mostrarTexto)
                            
                            //Botón para ver más o menos
                            Button(action: {
                                mostrarTexto.toggle()
                            }) {
                                Text(mostrarTexto ? "Ver menos" : "Ver más")
                                    .foregroundColor(.button)
                                    .font(.system(size: 12))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(8)
                    }
                    .padding(.horizontal, 20)
                    
                    //Lugar de ensayo
                    VStack {
                        Text("Local de ensayo")
                            .bold()
                            .font(.system(size: 22))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        //Ubicación de ensayo
                        VStack {
                            Map(initialPosition: region) {
                                Marker("Local ensayo", coordinate: CLLocationCoordinate2D(latitude: 37.23364246770224, longitude:  -5.0979836557080205))
                            }
                            .mapStyle(.hybrid)
                            .frame(height: 240)
                            .cornerRadius(15)
                            .padding(.bottom, 8)
                            
                            //Como llegar
                            HStack {
                                Text("Estación de autobuses, Osuna, Sevilla")
                                    .font(.system(size: 18))
                                Spacer()
                                Button(action: abrirMapa) {
                                    HStack {
                                        Image(systemName: "location.fill")
                                        Text("Cómo llegar")
                                    }
                                    .foregroundColor(.button)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding(8)
                    }
                    .padding(.horizontal, 20)
                    
                    //Redes sociales
                    VStack {
                        Text("Redes sociales")
                            .bold()
                            .font(.system(size: 22))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            //Instagram
                            Link(destination: URL(string: "https://www.instagram.com/bmvilladeosuna/")!) {
                                Image("instagram")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(.trailing, 4)
                                    .foregroundColor(.black)
                                    .background(Color.pink)
                                    .clipShape(Circle())
                                Text("Instagram")
                                    .font(.system(size: 18))
                            }
                            
                            //Facebook
                            Link(destination: URL(string: "https://www.facebook.com/BMVilladeOsuna")!) {
                                Image("facebook")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.black)
                                    .padding(.trailing, 4)
                                    .clipShape(Circle())
                                Text("Facebook")
                                    .font(.system(size: 18))
                            }
                            
                            //YouTube
                            Link(destination: URL(string: "https://www.youtube.com/channel/UCW3SKs4Qq3TjUo-jUwPsLYg")!) {
                                Image("youtube")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.black)
                                    .padding(.trailing, 4)
                                    .clipShape(Circle())
                                Text("Youtube")
                                    .font(.system(size: 18))
                            }
                        }
                        .padding(8)
                    }
                    .padding(.horizontal, 20)

                                        
                }

        }
        .background(.backgroundApp)
        .navigationBarBackButtonHidden(true) //ocultamos flecha atrás por defecto
        .toolbar { //Flecha hacia atrás personalizada
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss() //volver atrás
                } label: {
                    Image(systemName: "chevron.left")
                        .bold()
                        .foregroundColor(.button)
                        .padding(.bottom, 1)
                }
            }
        }
    }
    //Abre la aplicacion del mapa en las coordenadas especificadas
    func abrirMapa() {
        let latitude = 37.23364246770224
        let longitude = -5.0979836557080205
        let url = URL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)")!
        UIApplication.shared.open(url)
    }
}


#Preview {
    Informacion()
}
