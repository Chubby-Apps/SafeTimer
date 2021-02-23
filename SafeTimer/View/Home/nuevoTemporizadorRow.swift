//
//  nuevoTemporizadorRow.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 11/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

struct nuevoTemporizadorRow: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(entity: Temporizadores.entity(), sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)])
    var tMascarillas: FetchedResults<Temporizadores>
    @ObservedObject private var tbm = TextBindingManager()
    
    @Binding var anadir: Bool
    
    var body: some View {
        VStack {
            if self.anadir == true {
                VStack {
                    HStack {
                        VStack (alignment: .leading) {
                            Text("nuevoTempL")
                                .font(.system(Font.TextStyle.headline, design: Font.Design.rounded))
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemBlue))
                                .accessibility(hidden: true)
                        }
                        Spacer()
                        Button(action: {
                            self.anadir = false
                            self.tbm.duracionHoraString = ""
                            self.tbm.duracionMinutoString = ""
                            self.tbm.tituloTemporizador = ""
                        }) {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 40, weight: Font.Weight.bold, design: Font.Design.rounded))
                                .foregroundColor(Color(.systemRed))
                                .accessibility(label: Text("cerrar"))
                                 .accessibility(sortPriority: 4)
                        }
                    }.padding(.top, 20)
                    
                    TextField("utensilio", text: self.$tbm.tituloTemporizador)
                        .font(.system(size: 30, weight: Font.Weight.bold, design: Font.Design.rounded))
                        .multilineTextAlignment(.leading)
                        .accessibility(label: Text("nombre"))
                        .accessibility(sortPriority: 3)
                    
                    HStack(alignment: .bottom) {
                        TextField("00", text: self.$tbm.duracionHoraString)
                            .font(.system(size: 50, weight: Font.Weight.bold, design: Font.Design.rounded))
                            .offset(x: 0, y: 3)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .frame(width: 67)
                            .accessibility(label: Text("horas"))
                            .accessibility(sortPriority: 2)
                        Text("h")
                            .font(.system(.title, design: Font.Design.rounded))
                            .bold()
                            .offset(x: 0, y: -4)
                            .accessibility(hidden: true)
                        TextField("00", text: self.$tbm.duracionMinutoString)
                            .font(.system(size: 50, weight: Font.Weight.bold, design: Font.Design.rounded))
                            .offset(x: 0, y: 3)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .frame(width: 67)
                            .accessibility(label: Text("minutos"))
                            .accessibility(sortPriority: 1)
                        Text("m")
                            .font(.system(.title, design: Font.Design.rounded))
                            .bold()
                            .offset(x: 0, y: -4)
                            .accessibility(hidden: true)
                        Spacer()
                        withAnimation {
                        Button(action: {
                            self.guardar()
                            self.anadir = false
                            AppStoreReviewManager.requestReviewIfAppropriate()
                        }) {
                            botonIniciar(LocalizedKey: "iniciar").accessibility(sortPriority: 0)
                        }.disabled(self.tbm.tituloTemporizador == "" || self.tbm.duracionTotal == 0)
                    }
                    }
                }.padding([.bottom, .horizontal]).accessibilityElement(children: .contain)
            } else {
                Group{
                    HStack {
                        VStack (alignment: .leading) {
                            Text("nuevoTempL")
                                .font(.system(Font.TextStyle.headline, design: Font.Design.rounded))
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemBlue))
                                .accessibility(hidden: true)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.anadir = true
                            }
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 40, weight: Font.Weight.bold, design: Font.Design.rounded))
                                .foregroundColor(Color(.systemBlue))
                                .accessibility(label: Text("nuevoTempL"))
                        }
                    }.padding(.horizontal)
                }.padding(.top, 20).padding(.bottom, 20)
            }
        }.background(Color("nTempRowC")).cornerRadius(20)
    }
}

//MARK: - Funciones
extension nuevoTemporizadorRow {
    func guardar() {
        let nID = UUID()
        let nuevoTemporizadorItem = Temporizadores(context: self.managedObjectContext)
        nuevoTemporizadorItem.id = nID
        nuevoTemporizadorItem.tipoMascarilla = tbm.tituloTemporizador
        nuevoTemporizadorItem.duracion = Double(self.tbm.duracionHora + self.tbm.duracionMinuto)
        nuevoTemporizadorItem.duracionRestante = Double(self.tbm.duracionHora + self.tbm.duracionMinuto)
        nuevoTemporizadorItem.enUso = true
        nuevoTemporizadorItem.horaInicio = Date()
        nuevoTemporizadorItem.order = (tMascarillas.last?.order ?? 0) + 1
        nuevoTemporizadorItem.nUsos = 1
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
        AlarmaLogic().nuevaAlarma(duracionS: Double(self.tbm.duracionTotal), ID: nID)
        
    }
    
}

//MARK: - Preview
#if DEBUG
struct nuevoTemporizadorRow_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { color in
            Group {
                nuevoTemporizadorRow(anadir: .constant(false))
                    .previewLayout(.sizeThatFits)
                    .previewDisplayName("\(color) - Add: False")
                    .environment(\.locale, Locale(identifier: "es_ES"))
                    .environment(\.colorScheme, color)
                nuevoTemporizadorRow(anadir: .constant(true))
                    .previewLayout(.sizeThatFits)
                    .previewDisplayName("\(color) - Add: True")
                    .environment(\.locale, Locale(identifier: "es_ES"))
                    .environment(\.colorScheme, color)
            }
        }
    }
}
#endif
