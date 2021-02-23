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
    @FetchRequest(entity: Temporizadores.entity(), sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)]) var tMascarillas: FetchedResults<Temporizadores>
    @ObservedObject private var tbm = TextBindingManager()
    @EnvironmentObject private var ajustes: ajustesModel
    @State private var duracionH: Int = 0
    @State private var duracionM: Int = 0
    private var horas: CountableRange = 0..<100
    private var minutos: CountableRange = 0..<61
    
    private var duraciontotal: Int {
        get {
            return duracionH + duracionM
        }
    }
    
    private var width = WKInterfaceDevice.current().screenBounds.size.width
    
    var body: some View {
        ScrollView {
            
            HStack {
                Text("nombre")
                    .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                    .bold()
                Spacer()
                TextField("utensilio", text: self.$tbm.tituloTemporizador)
                    .font(.system(size: 16, weight: Font.Weight.bold, design: Font.Design.rounded))
                    .multilineTextAlignment(.center)
                    .scaledToFill()
            }
                
            
            HStack() {
                Picker("horas", selection: $duracionH) {
                    ForEach(horas) { hora in
                        Text(String(hora))
                            .font(.system(size: self.width > 136.0 ? 30 : 25, weight: Font.Weight.bold, design: Font.Design.rounded))
                            .bold()
                    }
                }.accessibility(label: Text("horas"))
                Text(":")
                    .font(.system(size: 25, weight: Font.Weight.bold, design: Font.Design.rounded))
                    .bold()
                    .offset(x: 0, y: 7)
                Picker("minutos", selection: $duracionM) {
                    ForEach(minutos) { hora in
                        Text(String(hora))
                            .font(.system(size: self.width > 136.0 ? 30 : 25, weight: Font.Weight.bold, design: Font.Design.rounded))
                            .bold()
                    }
                }.accessibility(label: Text("minutos"))
            }.frame(height: 60)
            

            
            Button(action: {
                self.guardar()
                self.presentationMode.wrappedValue.dismiss()
            }) {
               bIniciarWatch()
            }.disabled(self.tbm.tituloTemporizador == "" || duraciontotal == 0)
            .navigationBarTitle("anadir")
        }
    }
}
// MARK: - Funciones
extension nTempWatch {
    func guardar() {
        let ID = UUID()
        let nuevoTemporizadorItem = Temporizadores(context: self.managedObjectContext)
        nuevoTemporizadorItem.id = ID
        nuevoTemporizadorItem.tipoMascarilla = tbm.tituloTemporizador
        nuevoTemporizadorItem.duracion = (Double(duracionH) * 3600) + Double(duracionM) * 60
        nuevoTemporizadorItem.duracionRestante = (Double(duracionH) * 3600) + Double(duracionM) * 60
        nuevoTemporizadorItem.enUso = true
        nuevoTemporizadorItem.horaInicio = Date()
        nuevoTemporizadorItem.order = (tMascarillas.last?.order ?? 0) + 1
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
        AlarmaLogic().nuevaAlarma(duracionS: (Double(self.duracionH) * 3600) + Double(self.duracionM) * 60, ID: ID)
        
    }
}

//MARK: - Preview
#if DEBUG
struct nTempWatch_Previews: PreviewProvider {
    static var previews: some View {
        nTempWatch()
    }
}
#endif
