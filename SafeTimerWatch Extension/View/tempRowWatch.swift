//
//  tempRowWatch.swift
//  SafeTimer
//
//  Created by Asier G. Morato on 16/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI
import CoreData
import CloudKit
import Combine

struct tempRowWatch: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var datos: Temporizadores
    var alarma = AlarmaLogic()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var porcentajeProgresoEnMarcha: CGFloat = 0
    var porcentajeProgresoParado: CGFloat {
        return CGFloat(self.datos.duracionRestante / self.datos.duracion)
    }
    @State var tiempoRestante: TimeInterval = 0
    var tiempoRestanteString: String {
        if tiempoRestante < 3600 && tiempoRestante > 60 {
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
    
    var width = WKInterfaceDevice.current().screenBounds.size.width
    
    var body: some View {
        
        HStack {
            if width > 136.0 {
            VStack (alignment: .leading) {
                Text(self.datos.tipoMascarilla ?? "untensilio")
                    .font(.system(size: 12)).scaledToFill()
                if self.tiempoRestante >= 0 {
                    Text(self.tiempoRestanteString)
                        .font(.system(size: 25))
                        .bold().scaledToFill()
                        
                } else {
                    Text(self.tiempoRestanteString)
                        .font(.system(size: 25))
                        .bold()
                        .foregroundColor(Color(.red)).scaledToFill()
                }
                Text("usoRestante")
                    .font(.system(size: 10)).scaledToFill()
            }
            } else {
                VStack (alignment: .leading) {
                    Text(self.datos.tipoMascarilla ?? "untensilio")
                        .font(.system(size: 12)).scaledToFill()
                    if self.tiempoRestante >= 0 {
                        Text(self.tiempoRestanteString)
                            .font(.system(size: 18))
                            .bold().scaledToFill()
                        
                    } else {
                        Text(self.tiempoRestanteString)
                            .font(.system(size: 18))
                            .bold()
                            .foregroundColor(Color(.red)).scaledToFill()
                    }
                    Text("usoRestante")
                        .font(.system(size: 12)).scaledToFill()
                }
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color(.gray), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .frame(width: 45, height: 45).scaledToFill()
                
                if self.datos.enUso {
                    if self.porcentajeProgresoEnMarcha > 0.25 {
                        Circle()
                            .trim(from: 1 - (self.porcentajeProgresoEnMarcha), to: 1)
                            .stroke(Color(.green), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                            .frame(width: 45, height: 45)
                            .rotationEffect(.init(degrees: -90)).scaledToFill()
                    } else {
                        Circle()
                            .trim(from: 1 - (self.porcentajeProgresoEnMarcha), to: 1)
                            .stroke(Color(.red), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                            .frame(width: 45, height: 45)
                            .rotationEffect(.init(degrees: -90)).scaledToFill()
                    }
                } else {
                    if self.porcentajeProgresoParado > 0.25 {
                        Circle()
                            .trim(from: 1 - (self.porcentajeProgresoParado), to: 1)
                            .stroke(Color(.green), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                            .frame(width: 45, height: 45)
                            .rotationEffect(.init(degrees: -90)).scaledToFill()
                    } else {
                        Circle()
                            .trim(from: 1 - (self.porcentajeProgresoParado), to: 1)
                            .stroke(Color(.red), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                            .frame(width: 45, height: 45)
                            .rotationEffect(.init(degrees: -90)).scaledToFill()
                    }
                }
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
                        Image(systemName: self.datos.enUso ? "pause.fill" : "play.fill")
                            .font(.system(size: 25))
                            .foregroundColor(Color(.white))
                            .accessibility(label: self.datos.enUso ? Text("Pause") : Text("Play"))
                    }.scaledToFill()
                }.buttonStyle(PlainButtonStyle())
            }.frame(height: 80).frame(width: width-20)
        
        // Cuando aparece se rellenan datos
        .onAppear(perform: {
            if self.datos.enUso {
                let horaActual = Date()
                let difference = Calendar.current.dateComponents([.second], from: self.datos.horaInicio!, to: horaActual)
                self.tiempoRestante = self.datos.duracionRestante - Double(difference.second!)
                
                self.porcentajeProgresoEnMarcha = CGFloat(self.tiempoRestante / self.datos.duracion)
                
                
            } else {
                self.tiempoRestante = self.datos.duracionRestante
            }
            
        })
        
        // Cada segundo se actualizan datos
        .onReceive(self.timer) { (_) in
            if self.datos.enUso { // Contando
                self.tiempoRestante -= 1
                self.porcentajeProgresoEnMarcha = CGFloat(self.tiempoRestante / self.datos.duracion)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("foreground"))) { _ in
     
            if self.datos.enUso {
                let horaActual = Date()
                let difference = Calendar.current.dateComponents([.second], from: self.datos.horaInicio!, to: horaActual)
                self.tiempoRestante = self.datos.duracionRestante - Double(difference.second!)
                
                self.porcentajeProgresoEnMarcha = CGFloat(self.tiempoRestante / self.datos.duracion)
                
            } else {
                self.tiempoRestante = self.datos.duracionRestante
            }
        }
        
    }
    
    
    
}

//MARK: - Funciones
extension tempRowWatch {
    func guardar() {
        do {
            try self.managedObjectContext.save()
            print("Cambios guardados.")
            
        } catch {
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
struct tempRowWatch_Previews: PreviewProvider {
    static var previews: some View {
        let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
        
        let newMascarillaItem = Temporizadores.init(context: context)
        
        newMascarillaItem.id = UUID()
        newMascarillaItem.tipoMascarilla = "Mascarilla FFP2"
        newMascarillaItem.duracion = 3600
        newMascarillaItem.duracionRestante = 3059
        newMascarillaItem.horaInicio = Date()
        newMascarillaItem.enUso = true
        
        return tempRowWatch(datos: newMascarillaItem).environment(\.managedObjectContext, context)
    }
}
#endif
