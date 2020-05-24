//
//  nTempWatch.swift
//  SafeTimerWatch Extension
//
//  Created by Asier G. Morato on 16/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI

struct nTempWatch: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var managedObjectContext
    @ObservedObject private var tbm = TextBindingManager()
    private var ID = UUID()
    @State private var duracion: Int = 4
    private var horas: CountableRange = 1..<100
    
    private var width = WKInterfaceDevice.current().screenBounds.size.width
    
    var body: some View {
        List {
            HStack(alignment:.center) {
                Text("nombre")
                    .bold()
                    .scaledToFill()
                Spacer()
                TextField("utensilio", text: self.$tbm.tituloTemporizador)
                    .offset(x: 0, y: 1)
                    .multilineTextAlignment(.center)
            }.listRowPlatterColor(Color("nTempRowC")).frame(width: width-20).scaledToFill()
            
            HStack(alignment: .center) {
                Text("duracion")
                    .bold()
                    .scaledToFill()
                Spacer()
                Picker("", selection: $duracion) {
                    ForEach(horas) { hora in
                        Text(String(hora))
                    }
                }.frame(width: 40, height: 50).offset(x: 0, y: -7)
                Text("h").offset(x: -3, y: 0)
            }.listRowPlatterColor(Color("nTempRowC")).frame(width: width-20).scaledToFill()
            
            Button(action: {
                self.guardar()
                AlarmaLogic().nuevaAlarma(duracionS: Double(self.duracion+1) * 3600, ID: self.ID)
                self.presentationMode.wrappedValue.dismiss()
            }) {
               bIniciarWatch()
            }.disabled(self.tbm.tituloTemporizador == "").listRowPlatterColor(Color("nTempRowC"))
            .navigationBarTitle("anadir")
        }
    }
}

extension nTempWatch {
    func guardar() {
        let nuevoTemporizadorItem = Temporizadores(context: self.managedObjectContext)
        nuevoTemporizadorItem.id = ID
        nuevoTemporizadorItem.tipoMascarilla = tbm.tituloTemporizador
        nuevoTemporizadorItem.duracion = Double(duracion+1) * 3600
        nuevoTemporizadorItem.duracionRestante = Double(duracion+1) * 3600
        nuevoTemporizadorItem.enUso = true
        nuevoTemporizadorItem.horaInicio = Date()
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct nTempWatch_Previews: PreviewProvider {
    static var previews: some View {
        nTempWatch()
    }
}
