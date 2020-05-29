//
//  nuevaMascarillaView.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 04/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct nuevaMascarillaView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject private var ajustes: ajustesModel
    @ObservedObject private var tbm = TextBindingManager()
    @Binding var cerrar: Bool
    var ID = UUID()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                Group {
                    Spacer().frame(height: 20)
                    VStack{

                        HStack(alignment:.center) {
                            Text("nombre").bold()
                            Spacer()
                            TextField("utensilio", text: self.$tbm.tituloTemporizador)
                                .offset(x: 0, y: 1)
                                .multilineTextAlignment(.trailing)
                        }.padding([.horizontal, .top])
                        
                        Divider().foregroundColor(Color(.secondarySystemFill)).padding(.horizontal)
                        
                        
                        HStack {
                            Text("duracion").bold()
                            Spacer()
                            TextField("8", text: self.$tbm.duracionString)
                                .offset(x: 0, y: 1)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                            Text("horas")
                        }.padding([.horizontal, .bottom])
                        
                        
                        
                    }.background(Color("nTempRowC")).cornerRadius(20).padding(.horizontal, 5)
                    
//                    HStack {
//                        Text("Puedes cambiar la duración predeterminada de las mascarillas en ajustes.")
//                            .font(.footnote)
//                            .foregroundColor(Color(.systemGray))
//                    }.padding(.horizontal)
                    
                    Spacer().frame(height: 20)
                    
                    Button(action: {
                        self.guardar()
                        AlarmaLogic().nuevaAlarma(duracionS: Double(Int(self.tbm.duracionString)!*3600), ID: self.ID)
                        self.presentationMode.wrappedValue.dismiss()
                        AppStoreReviewManager.requestReviewIfAppropriate()
                    }) {
                        botonIniciar(LocalizedKey: "iniciar")
                    }.disabled(self.tbm.duracionString == "" || self.tbm.tituloTemporizador == "")
                    
                    Spacer()
                }
                .navigationBarItems(trailing: EmptyView())
                .navigationBarTitle("anadir", displayMode: .large)
                .navigationBarItems(trailing: Button(action: {self.cerrar = false}) {Image(systemName: "xmark.circle.fill").font(.system(size: 25)).foregroundColor(Color(.systemRed)).accessibility(label: Text("cerrar"))})
                .modifier(AdaptsToSoftwareKeyboard())
            }
        }
    }
}

//MARK: - Función Guardar
extension nuevaMascarillaView {
    func guardar() {
        let nuevoTemporizadorItem = Temporizadores(context: self.managedObjectContext)
        nuevoTemporizadorItem.id = ID
        nuevoTemporizadorItem.tipoMascarilla = tbm.tituloTemporizador
        nuevoTemporizadorItem.duracion = Double(Int(self.tbm.duracionString)! * 3600)
        nuevoTemporizadorItem.duracionRestante = Double(Int(self.tbm.duracionString)!*3600)
        nuevoTemporizadorItem.enUso = true
        nuevoTemporizadorItem.horaInicio = Date()
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - Preview
struct nuevaMascarillaView_Previews: PreviewProvider {
    static var previews: some View {
        nuevaMascarillaView(cerrar: .constant(false)).environmentObject(ajustesModel())
    }
}

//Group {
//    Image("logo")
//        .resizable()
//        .aspectRatio(contentMode: .fit)
//        .frame(height: geometry.size.height / 2.5)
//        .padding(.horizontal)
//
//    VStack{
//
//        HStack {
//            Spacer()
//            Text("Duración")
//                .font(.headline)
//            if self.duracionMascarilla == 1 {
//                Text("\(String(format: "%.0f", self.duracionMascarilla)) hora")
//            } else {
//                Text("\(String(format: "%.0f", self.duracionMascarilla)) horas")
//            }
//            Spacer()
//        }.padding([.horizontal, .top])
//
//        HStack {
//            Picker("Tipo de Mascarilla", selection: self.$tipoMascarilla) {
//                Text("Quirúrgica").tag("Mascarilla Quirúrgica")
//                Text("FFP2").tag("Mascarilla FFP2")
//                Text("FFP3").tag("Mascarilla FFP3")
//                Text("Otro").tag("Otro")
//            }.onAppear {
//                self.duracionMascarilla = Float(self.ajustes.ffp2)
//            }.onReceive([self.tipoMascarilla].publisher.first()) { (value) in
//                if value == "Mascarilla FFP2" {
//                    self.duracionMascarilla = Float(self.ajustes.ffp2)
//                } else if value == "Mascarilla Quirúrgica" {
//                    self.duracionMascarilla = Float(self.ajustes.quirurgica)
//                } else if value == "Mascarilla FFP3" {
//                    self.duracionMascarilla = Float(self.ajustes.ffp3)
//                } else if value == "Otro" {
//                    self.duracionMascarilla = Float(self.ajustes.otro)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//        }.padding([.horizontal, .bottom])
//        // Cambiar duración cuando creas una mascarilla. Comentado por que no funciona.
//        //                        HStack {
//        //                            Text("Duración")
//        //                                .font(.headline)
//        //
//        //                            Spacer()
//        //
//        //                            Stepper(value: self.$duracionMascarilla, in: 1...99, step: 1) {
//        //                                if self.duracionMascarilla == 1 {
//        //                                    Text("\(String(format: "%.0f", self.duracionMascarilla)) hora").frame(width: 70)
//        //                                } else {
//        //                                    Text("\(String(format: "%.0f", self.duracionMascarilla)) horas").frame(width: 70)
//        //                                }
//        //                            }.frame(width: 170)
//        //                        }.padding([.horizontal, .bottom])
//
//    }.background(Color(.quaternarySystemFill)).cornerRadius(20).padding(.horizontal, 5)
//
//    HStack {
//        Text("Puedes cambiar la duración predeterminada de las mascarillas en ajustes.")
//            .font(.footnote)
//            .foregroundColor(Color(.systemGray))
//    }.padding(.horizontal)
//
//    Spacer().frame(height: 20)
//
//    Button(action: {
//        self.guardar()
//        AlarmaLogic().nuevaAlarma(duracionS: Double(self.duracionMascarilla*3600), ID: self.ID)
//        self.presentationMode.wrappedValue.dismiss()
//
//    }) {
//        Text("Iniciar")
//            .font(.body)
//            .bold()
//            .foregroundColor(Color.white)
//            .padding(.horizontal, 20).padding(.vertical, 10)
//            .background(Color(.systemBlue))
//            .cornerRadius(10)
//    }
//
//    Spacer()
//}
