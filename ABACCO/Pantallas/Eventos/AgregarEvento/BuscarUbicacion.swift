//
//  BuscarUbicacion.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 13/5/25.
//

import SwiftUI
import MapKit

struct BuscarUbicacion: View {
    
    @Binding var ubiTemp: CLLocationCoordinate2D
    @Binding var ubicacion: MapCameraPosition
    @State private var textoBusqueda = ""
    @State private var resultadosBusqueda: [MKMapItem] = []
    
    var body: some View {
        //Panel para el buscador
        VStack(spacing: 0) {
            // TextField de búsqueda
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(.systemGray6).opacity(0.90))
                    .frame(height: 50)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                TextField("Buscar ubicación...", text: $textoBusqueda)
                    .onChange(of: textoBusqueda) {
                        buscarLugar()
                    }
                    .padding(.horizontal, 20)
            }
            .padding(.horizontal, 15)
            .padding(.top, 10)
            
            //Lista de los resultados
            if !resultadosBusqueda.isEmpty { //si el array de los resultados no estan vacios
                ScrollView { //vista de scroll
                    VStack(spacing: 0) {
                        ForEach(resultadosBusqueda, id: \.self) { item in //Creamos un botón por cada resultado
                            Button(action: {
                                //guardamos las coordenadas del lugar seleccionado
                                if let coordinate = item.placemark.location?.coordinate {
                                    ubiTemp = coordinate
                                    
                                    //actualizamos la región del mapa para moverlo a la nueva ubicación
                                    let nuevaRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                                    ubicacion = MapCameraPosition.region(nuevaRegion)
                                }
                                //formateamos las variables
                                resultadosBusqueda = []
                                textoBusqueda = ""
                            }) {
                                //nombre del lugar
                                Text(item.name ?? "Sin nombre")
                                    .padding()
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 15)
                            }
                        }
                    }
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(12)
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                }
                .frame(maxHeight: 150)
            }
        }
        .animation(.easeInOut, value: resultadosBusqueda.count) //animacion cuandose muestra/oculta los resultados de la busqueda
    }
    
    //Función para buscar la ubicación en el mapa
    private func buscarLugar() {
        //Si no se escribe nada no se busca
        guard !textoBusqueda.isEmpty else { //guard: verifica la condición, si no se cumple termina
            resultadosBusqueda = []
            return
        }
        
        //buscamos lugares relacionados con el textoBusqueda
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = textoBusqueda
        
        //creamos una instancia de MKLocalSearch pasando la request para buscar en el mapa
        let buscador = MKLocalSearch(request: request)
        buscador.start { response, _ in
            //si coinciden elementos, se actualiza el array
            if let response = response {
                resultadosBusqueda = response.mapItems
            }
        }
    }
}
