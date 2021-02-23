//
//  mascarillaRow.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 07/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

struct mascarillaRow: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var datos: Temporizadores
    @EnvironmentObject var ajustes: ajustesModel
    var alarma = AlarmaLogic()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var alertaEliminar = false
    
    @State var porcentajeProgresoEnMarcha: CGFloat = 0
    var porcentajeProgresoParado: CGFloat {
        return CGFloat(self.datos.duracionRestante / self.datos.duracion)
    }
    @State var tiempoRestante: TimeInterval = 0
    var tiempoRestanteString: String {
        if tiempoRestante < 3600 && tiempoRestante >= 60 {
            let tr: TimeInterval =  tiempoRestante
            return "\(tr.format(using: [.minute, .second])!)"
        } else if tiempoRestante >= 0 && tiempoRestante <= 59 {
            let tr: TimeInterval =  tiempoRestante
            return "\(tr.format(using: [.second])!)"
        } else if tiempoRestante < 0 && tiempoRestante >= -59 {
            let tr: TimeInterval =  tiempoRestante
            return "\(tr.format(using: [.second])!)"
        } else if tiempoRestante < -60 && tiempoRestante >= -3599 {
            let tr: TimeInterval =  tiempoRestante
            return "\(tr.format(using: [.minute, .second])!)"
        } else if tiempoRestante <= -3600 {
            let tr: TimeInterval =  tiempoRestante
            return "\(tr.format(using: [.hour, .minute])!)"
        } else {
            let tr: TimeInterval =  tiempoRestante
            return "\(tr.format(using: [.hour, .minute])!)"
        }
    }
    
    var body: some View {
        Group {
            HStack {
                ZStack {
                    if self.datos.enUso {
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(Color(self.porcentajeProgresoEnMarcha > 0.25 ? .systemGreen : .systemRed).opacity(0.15), style: StrokeStyle(lineWidth: 11, lineCap: .round))
                            .frame(width: 45, height: 45)
                        Circle()
                            .trim(from: 1 - (self.porcentajeProgresoEnMarcha), to: 1)
                            .stroke(Color(self.porcentajeProgresoEnMarcha > 0.25 ? .systemGreen : .systemRed), style: StrokeStyle(lineWidth: 11, lineCap: .round))
                            .frame(width: 45, height: 45)
                            .rotationEffect(.init(degrees: -90))
                    } else {
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(Color(self.porcentajeProgresoParado > 0.25 ? .systemGreen : .systemRed).opacity(0.15), style: StrokeStyle(lineWidth: 11, lineCap: .round))
                            .frame(width: 45, height: 45)
                        Circle()
                            .trim(from: 1 - (self.porcentajeProgresoParado), to: 1)
                            .stroke(Color(self.porcentajeProgresoParado > 0.25 ? .systemGreen : .systemRed), style: StrokeStyle(lineWidth: 11, lineCap: .round))
                            .frame(width: 45, height: 45)
                            .rotationEffect(.init(degrees: -90))
                    }
                    
                    if self.ajustes.numeroDeUsos {
                        Text("\(self.datos.nUsos)")
                            .font(.system(Font.TextStyle.callout, design: Font.Design.rounded))
                            .bold()
                    } else {
                        EmptyView()
                    }
                }.padding(.vertical, 9).padding(.trailing, 5)
                
                VStack (alignment: .leading) {
                    Text(self.datos.tipoMascarilla ?? "Utensilio")
                        .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                        .accessibility(label: self.ajustes.numeroDeUsos ? Text(self.datos.tipoMascarilla ?? "Utensilio")+Text("nUsos")+Text("\(self.datos.nUsos)") : Text(self.datos.tipoMascarilla ?? "Utensilio"))
                    
                    Text(self.tiempoRestanteString)
                        .font(.system(Font.TextStyle.largeTitle, design: Font.Design.rounded))
                        .bold()
                        .foregroundColor(self.tiempoRestante >= 0 ? Color(.label) : Color(.systemRed))
                        .accessibility(label: self.tiempoRestante >= 0 ? Text("usoRestante")+Text(self.tiempoRestanteString) : Text("usoRestante")+Text("menos")+Text(self.tiempoRestanteString))
                        .lineLimit(1)
                }.padding(.leading, 5).padding(.vertical, 10)
            
            Spacer()
            
            Button(action: {
                if self.datos.enUso { // True - Pulsas Pause
                    self.alarma.pararAlarma(ID: self.datos.id!)
                    // Meter duración restante
                    
                    let horaActual = Date()
                    let difference = Calendar.current.dateComponents([.second], from: self.datos.horaInicio!, to: horaActual)
                    self.datos.duracionRestante = self.datos.duracionRestante - Double(difference.second!)
                    
                    self.datos.enUso.toggle()
                    self.guardar()
                } else { // False - Pulsas Play
                    if self.datos.duracionRestante > 1 {
                        self.alarma.nuevaAlarma(duracionS: self.datos.duracionRestante, ID: self.datos.id!)
                    }
                    
                    self.tiempoRestante = self.datos.duracionRestante
                    self.datos.horaInicio = Date()
                    
                    self.datos.enUso.toggle()
                    self.guardar()
                }
            }) {
                Image(systemName: self.datos.enUso ? "pause.circle" : "play.circle")
                    .font(.system(size: 40, weight: Font.Weight.bold, design: Font.Design.rounded))
                    .foregroundColor(self.datos.enUso ? Color(.systemOrange) : Color(.systemBlue))
                    .accessibility(label: self.datos.enUso ? Text("pause") : Text("play"))
            }
        }.padding(.horizontal)
    }.background(Color("nTempRowC")).cornerRadius(20)
    .contextMenu {
        withAnimation {
            Button(action: {
                self.datos.enUso = false
                self.alarma.pararAlarma(ID: self.datos.id!)
                self.datos.duracionRestante = self.datos.duracion
                self.datos.nUsos += 1
                self.guardar()
                self.tiempoRestante = self.datos.duracionRestante
            }) {
                Text("reiniciar")
                Image(systemName: "arrow.counterclockwise")
            }
        }
        withAnimation {
            Button(action: {
                self.duplicar()
            }) {
                Text("duplicar")
                Image(systemName: "doc.on.doc")
            }
        }
        withAnimation {
            Button(action: {self.alertaEliminar = true}) {
                Text("borrar")
                Image(systemName: "trash")
            }.foregroundColor(.red)
        }
    }
            
    .alert(isPresented: $alertaEliminar) {
        Alert(title: Text("borrar"), message: Text("seguroBorrar"), primaryButton: .destructive(Text("borrar")) {
            self.borrar()
            }, secondaryButton: .cancel(Text("Cancelar")))
    }
            // Cuando aparece se rellenan datos
        .onAppear(perform: {
                if self.datos.enUso {
                    let horaActual = Date()
                    let difference = Calendar.current.dateComponents([.second], from: self.datos.horaInicio!, to: horaActual)
                    self.tiempoRestante = self.datos.duracionRestante - Double(difference.second!)
                    self.porcentajeProgresoEnMarcha = CGFloat(self.tiempoRestante / self.datos.duracion)
                } else {
                    self.tiempoRestante = self.datos.duracionRestante
                    self.porcentajeProgresoEnMarcha = CGFloat(self.tiempoRestante / self.datos.duracion)
                }
        })
            
        // Cada segundo se actualizan datos
        .onReceive(self.timer) { (_) in
                if self.datos.enUso { // Contando
                    self.tiempoRestante -= 1
                    self.porcentajeProgresoEnMarcha = CGFloat(self.tiempoRestante / self.datos.duracion)
                }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if self.datos.enUso {
                let horaActual = Date()
                let difference = Calendar.current.dateComponents([.second], from: self.datos.horaInicio!, to: horaActual)
                self.tiempoRestante = self.datos.duracionRestante - Double(difference.second!)
                self.porcentajeProgresoEnMarcha = CGFloat(self.tiempoRestante / self.datos.duracion)
            } else {
                self.tiempoRestante = self.datos.duracionRestante
                self.porcentajeProgresoEnMarcha = CGFloat(self.tiempoRestante / self.datos.duracion)
            }
        }
}
}

//MARK: - Funciones
extension mascarillaRow {
    func guardar() {
        do {
            try self.managedObjectContext.save()
            print("Cambios guardados.")
            
        } catch {
            print(error.localizedDescription)
        }
    }
    func duplicar() {
        let nuevoTemporizadorItem = Temporizadores(context: self.managedObjectContext)
        nuevoTemporizadorItem.id = UUID()
        nuevoTemporizadorItem.tipoMascarilla = self.datos.tipoMascarilla
        nuevoTemporizadorItem.duracion = self.datos.duracion
        nuevoTemporizadorItem.duracionRestante = self.datos.duracion
        nuevoTemporizadorItem.enUso = false
        nuevoTemporizadorItem.horaInicio = Date()
        nuevoTemporizadorItem.order = self.datos.order + 1
        nuevoTemporizadorItem.nUsos = 1
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    func borrar() {
        self.managedObjectContext.delete(self.datos)
        do {
            try self.managedObjectContext.save()
        } catch{
            print(error.localizedDescription)
        }
    }
}

//MARK: - Extensión Formato de TimeInterval
extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: self)
    }
}

//MARK: - Preview
#if DEBUG
struct mascarillaRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let newMascarillaItem = Temporizadores.init(context: context)
        
        newMascarillaItem.id = UUID()
        newMascarillaItem.tipoMascarilla = "Mascarilla FFP2"
        newMascarillaItem.duracion = 3600
        newMascarillaItem.duracionRestante = 3000
        newMascarillaItem.horaInicio = Date()
        newMascarillaItem.enUso = true
        newMascarillaItem.nUsos = 10
        
       return ForEach(ColorScheme.allCases, id: \.self) { color in
                mascarillaRow(datos: newMascarillaItem)
                    .environment(\.managedObjectContext, context)
                    .previewLayout(.sizeThatFits)
                    .previewDisplayName("\(color)")
                    .environment(\.colorScheme, color)
                    .environmentObject(ajustesModel())
        }
        
    }
}
#endif
