//
//  mascarillaRow.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 07/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI
import CoreData

struct mascarillaRow: View {
    
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
    
    var body: some View {
            Group {
                HStack {
                    ZStack {
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(Color(.systemGray4), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                            .frame(width: 65, height: 65)
                        
                        if self.datos.enUso {
                            if self.porcentajeProgresoEnMarcha > 0.25 {
                                Circle()
                                    .trim(from: 1 - (self.porcentajeProgresoEnMarcha), to: 1)
                                    .stroke(Color(.systemGreen), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                    .frame(width: 65, height: 65)
                                    .rotationEffect(.init(degrees: -90))
                                Image(systemName: "timer")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(Color(.systemGreen))
                                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                    .accessibility(hidden: true)
                            } else {
                                Circle()
                                    .trim(from: 1 - (self.porcentajeProgresoEnMarcha), to: 1)
                                    .stroke(Color(.systemRed), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                    .frame(width: 65, height: 65)
                                    .rotationEffect(.init(degrees: -90))
                                Image(systemName: "timer")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(Color(.systemRed))
                                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                    .accessibility(hidden: true)
                            }
                            
                        } else {
                            if self.porcentajeProgresoParado > 0.25 {
                                Circle()
                                    .trim(from: 1 - (self.porcentajeProgresoParado), to: 1)
                                    .stroke(Color(.systemGreen), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                    .frame(width: 65, height: 65)
                                    .rotationEffect(.init(degrees: -90))
                                Image(systemName: "timer")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(Color(.systemGreen))
                                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                    .accessibility(hidden: true)
                            } else {
                                Circle()
                                    .trim(from: 1 - (self.porcentajeProgresoParado), to: 1)
                                    .stroke(Color(.systemRed), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                    .frame(width: 65, height: 65)
                                    .rotationEffect(.init(degrees: -90))
                                Image(systemName: "timer")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(Color(.systemRed))
                                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                    .accessibility(hidden: true)
                            }
                        }
                    }.padding(.vertical, 9).padding(.trailing, 5)
                    
                    VStack (alignment: .leading) {
                        Text(self.datos.tipoMascarilla ?? "Utensilio")
                            .font(.caption)
                        if self.tiempoRestante >= 0 {
                            Text(self.tiempoRestanteString)
                                .font(.largeTitle)
                                .bold()
                            .accessibility(label: Text("usoRestante")+Text(self.tiempoRestanteString))
                        } else {
                            Text(self.tiempoRestanteString)
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(Color(.systemRed))
                                .accessibility(label: Text("usoRestante")+Text(self.tiempoRestanteString))
                        }
                        Text("usoRestante")
                            .font(.caption)
                            .foregroundColor(Color(.systemGray))
                            .accessibility(hidden: true)
                    }
                    .padding(.leading, 5).padding(.vertical, 12)
                    
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
                            .font(.system(size: 50))
                            .foregroundColor(self.datos.enUso ? Color(.systemOrange) : Color(.systemBlue))
                            .accessibility(label: self.datos.enUso ? Text("pause") : Text("play"))
                    }
                }.padding(.horizontal)
            }.background(Color("nTempRowC")).cornerRadius(20).frame(height: 90)
        
            
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
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
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
extension mascarillaRow {
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
        
        return mascarillaRow(datos: newMascarillaItem).environment(\.managedObjectContext, context)
    }
}
#endif
