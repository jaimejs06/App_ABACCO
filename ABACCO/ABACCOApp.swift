//
//  ABACCOApp.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 4/3/25.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    FirebaseApp.configure()
      
       //Prueba de conexión: imprime el App ID
        if let appID = FirebaseApp.app()?.options.googleAppID {
            print("Firebase inicializado correctamente: \(appID)")
        } else {
            print("Error: Firebase no se inicializó")
        }
    return true
  }
}

@main
struct ABACCOApp: App {
    
    //register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authenticationViewModel = AuthenticationViewModel()

    var body: some Scene {
        WindowGroup {
            //si el usuario esta logeado mostramos la ventana principal
            if let _ = authenticationViewModel.user{
                Principal(authenticationViewModel: authenticationViewModel)
            }else{
                //si no esta logeado mostramos la ventana de inicio de sesion
                InicioSesion(authenticationViewModel: authenticationViewModel)
            }
            
        }
    }
}
