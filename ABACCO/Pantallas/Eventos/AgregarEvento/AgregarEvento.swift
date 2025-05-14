//
//  AgregarEvento.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 30/4/25.
//

import SwiftUI
import FirebaseFirestore
import MapKit

//Estructura que muestra todos los componentes para añadir un evento
struct AgregarEvento: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var eventosViewModel: EventosViewModel
    
    @State var titulo: String = ""
    @State var fecha: Date = Date()
    @State var categoria:String = ""
    @State var descripcion:String = ""
    @State var lugar:String = ""
    
    @State var ubiTemp = CLLocationCoordinate2D() //Coordenadas temporales de la vista mapa
    @State var ubicacion:GeoPoint = GeoPoint(latitude: 0, longitude: 0) //coordenadas a guardar en BBDD
    
    @State var mostrarMensaje:Bool = false //mensaje de errores
    @State var mensajeExito:Bool = false // mensaje exito
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                //Cabecera
                VStack {
                    Text("Añadir Evento")
                        .font(.system(size: 30))
                        .bold()
                        .padding(.bottom, 2)
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .background(Color("Button").opacity(0.4))
                .cornerRadius(40)
                .padding(8)
                
                
                //Panel para el Título
                TituloEvento(titulo: $titulo)
                
                //Panel para la fecha
                FechaEvento(fecha: $fecha)
                
                //Panel para la categoria
                Categoria(categoria: $categoria)
                
                //Panel para la descripcion
                DescripcionEvento(descripcion: $descripcion)
                
                //Vista para el lugar
                LugarEvento(lugar: $lugar)
                
                //Vista para el mapa
                Mapa(ubiTemp: $ubiTemp, titulo: $titulo)
                
                if mostrarMensaje {
                    Text("Te falta agregar algún dato")
                        .bold()
                        .foregroundColor(.red)
                        .padding(.top, 8)
                }
                
                //Boton para guardar el evento
                Button {
                    guardar()
                } label: {
                    Text("Guardar")
                        .font(.system(size: 20))
                }
                .tint(.button).opacity(0.8)
                .controlSize(.regular)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                
                //mensaje de exito si se inserta la noticia
                if mensajeExito {
                    Text("Evento agregado")
                        .bold()
                        .foregroundColor(.green)
                        .padding(.top, 8)
                        .font(.system(size: 22))
                        .padding(20)
                }
                
                Spacer()
                
            }
        }
        //.background(.backgroundApp)
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
    
    //Función para guardar el evento
    func guardar() {
        
        //Convertimos las coordenadas a tipo GeoPoint
        ubicacion = GeoPoint(latitude: ubiTemp.latitude, longitude: ubiTemp.longitude)
        
        //comprobamos los campos
        if titulo.isEmpty || categoria.isEmpty || lugar.isEmpty || ubicacion == GeoPoint(latitude: 0, longitude: 0)  {
            mostrarMensaje = true
            
        } else {
            //insertamos en la BBDD
            eventosViewModel.insertarEvento(evento: Evento(titulo: titulo, fecha: fecha, categoria: categoria, lugar: lugar, descripcion: descripcion, ubicacion: ubicacion))
            
            //aparece el mensaje de exito
            withAnimation {
                mensajeExito = true
            }
            
            //Hacemos que desaparezca cuando pasen 2 segundos
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    mensajeExito = false
                }
            }
            
            //Formateamos los valores una vez insertado
            titulo = ""
            fecha = Date()
            categoria = ""
            descripcion = ""
            lugar = ""
            ubicacion = GeoPoint(latitude: 0, longitude: 0)
        }
    }
}

struct Mapa: View {
    
    //Osuna por defecto
    @State var ubicacion = MapCameraPosition.region(
        MKCoordinateRegion(center: .init(latitude: 37.2372656, longitude:  -5.1047332), latitudinalMeters: 1000, longitudinalMeters: 1000))
    
    //Ubicacion que se almacena temporalmente
    @Binding var ubiTemp:CLLocationCoordinate2D
    @Binding var titulo:String //titulo para el marker
    
    var body: some View {
        ZStack {
            MapReader { proxy in //el proxy contiene lo que devuelve el mapReader
                Map(position: $ubicacion) {
                    Marker(titulo, coordinate: ubiTemp)
                }
                .mapStyle(.hybrid)
                .onTapGesture { posicion in
                    //obtenemos las coordenadas del elemento MapReader
                    if let coordenadas = proxy.convert(posicion, from: .local) {
                        ubiTemp = coordenadas
                    }
                }
            }
            
            VStack {
                //Vista para la busqueda
                BuscarUbicacion(ubiTemp: $ubiTemp, ubicacion: $ubicacion)
                Spacer()
            }
            
        }
        .cornerRadius(15)
        .frame(height: 350)
        .padding(.horizontal, 15)
    }
}

struct LugarEvento:View {
    
    @Binding var lugar:String
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.texfield)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                            .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                    )
                
                TextField("Lugar", text: $lugar)
                    .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 8)
    }
}

struct Categoria: View {
    
    @Binding var categoria:String //Para insertar en BBDD
    @State var textoCategoria:String = "Categoría" //Texto que se muestra
    
    var body: some View {
        
        VStack {
            //menu desplegable
            Menu {
                Button("Ensayo") {
                    categoria = "ensayo"
                    textoCategoria = "Ensayo"
                }
                Button("Actuación") {
                    categoria = "actuacion"
                    textoCategoria = "Actuación"
                }
            } label: {
                HStack {
                    Text(textoCategoria)
                        .padding(.leading, 20)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color("Button"))
                        .padding(.trailing, 16)
                }
                .frame(height: 50)
                .background(.texfield)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("Button"), lineWidth: 0.5)
                )
            }
        }
        .padding(.horizontal, 15)
    }
}

struct FechaEvento:View {
    @Binding var fecha: Date
    var body: some View {
        VStack{
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.texfield)
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("Button"), lineWidth: 0.5)
                    )
                
                //hacemos que solo se pueda seleccionar desde hoy
                DatePicker("Fecha del evento", selection: $fecha, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    .accentColor(Color("Button").opacity(0.4)) //color del selector
                    .padding(.horizontal, 20)
                    .environment(\.locale, Locale(identifier: "es")) //Forzamos que aparezca en español
            }
        }
        .padding(.horizontal, 15)
    }
}

struct DescripcionEvento:View {
    @Binding var descripcion:String
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.texfield)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                            .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                    )
                
                TextField("Descripción...", text: $descripcion)
                    .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 15)
    }
}

struct TituloEvento:View {
    
    @Binding var titulo:String
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.texfield)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20) // Otro RoundedRectangle para el borde
                            .stroke(.button, lineWidth: 0.5) // Aplicamos el borde
                    )
                
                TextField("Introduce el título", text: $titulo)
                    .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 15)
    }
}
