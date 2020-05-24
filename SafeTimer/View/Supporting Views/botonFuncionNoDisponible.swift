//
//  botonFuncionNoDisponible.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 05/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI

struct botonFuncionNoDisponible: View {
    
    var nombre: LocalizedStringKey
    @Binding var alertaFuncionNoDisponible: Bool
    
    var body: some View {
        Button(action: {self.alertaFuncionNoDisponible = true
        }) {Text(nombre).foregroundColor(Color(.label)).lineLimit(1)}
            .alert(isPresented: $alertaFuncionNoDisponible) {
                Alert(title: Text("fNoDisponible"), message: Text("fNoDisponibleExplicacion"), dismissButton: .default(Text("aceptar")))
        }
    }
}


struct botonFuncionNoDisponible_Previews: PreviewProvider {
    static var previews: some View {
        botonFuncionNoDisponible(nombre: "Título", alertaFuncionNoDisponible: .constant(false))
    }
}
