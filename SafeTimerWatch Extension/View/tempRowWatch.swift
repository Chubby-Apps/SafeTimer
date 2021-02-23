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
    @EnvironmentObject private var ajustes: ajustesModel
    @ObservedObject var datos: Temporizadores
    var alarma = AlarmaLogic()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var porcentajeProgresoEnMarcha: CGFloat = 0
    var porcentajeProgresoParado: CGFloat {
        return CGFloat(self.datos.duracionRestante / self.datos.duracion)
    }
    @State var tiempoRestante: TimeInterval = 0
    
    var tiempoRestanteString: String {
        return format(tiempoRestante)
    }
    
    var width = WKInterfaceDevice.current().screenBounds.size.width
    
    var body: some View {
        
        HStack {
            VStack (alignment: .leading) {
                Text(self.datos.tipoMascarilla ?? "untensilio")
                    .font(.system(size: 13, weight: .medium, design: Font.Design.rounded))
					.lineLimit(2)
					.frame(minWidth: 60, maxWidth: 80, alignment: .leading)
                    .scaledToFill()
                Text(self.tiempoRestanteString)
                    .font(.system(size: width > 136.0 ? 26 : 19, weight: .bold, design: Font.Design.rounded))
                    .bold()
                    .foregroundColor(self.tiempoRestante >= 0 ? .primary : Color(.red))
                    .scaledToFill()
                    .accessibility(label: self.tiempoRestante >= 0 ? Text("usoRestante")+Text(self.tiempoRestanteString) : Text("usoRestante")+Text("menos")+Text(self.tiempoRestanteString))
                if self.ajustes.numeroDeUsos {
                    HStack {
                        Text("nUsos")
                        Text("\(self.datos.nUsos)")
                    }.font(.system(size: 13, weight: .medium, design: Font.Design.rounded))
                } else {
                    EmptyView()
                }
            }
         
            Spacer()
            
            ZStack {
                if self.datos.enUso {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color(self.porcentajeProgresoEnMarcha > 0.25 ? .green : .red).opacity(0.15), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 45, height: 45)
                    Circle()
                        .trim(from: 1 - (self.porcentajeProgresoEnMarcha), to: 1)
                        .stroke(Color(self.porcentajeProgresoEnMarcha > 0.25 ? .green : .red), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 45, height: 45)
                        .rotationEffect(.init(degrees: -90))
                } else {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color(self.porcentajeProgresoParado > 0.25 ? .green : .red).opacity(0.15), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 45, height: 45)
                    Circle()
                        .trim(from: 1 - (self.porcentajeProgresoParado), to: 1)
                        .stroke(Color(self.porcentajeProgresoParado > 0.25 ? .green : .red), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 45, height: 45)
                        .rotationEffect(.init(degrees: -90))
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
                            .font(.system(size: 24, weight: Font.Weight.bold, design: Font.Design.rounded))
                            .foregroundColor(Color(.white))
                            .accessibility(label: self.datos.enUso ? Text("Pause") : Text("Play"))
                    }.scaledToFill()
                }.buttonStyle(PlainButtonStyle())
            }.frame(height: 70).frame(width: width-20)
        
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
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("foreground"))) { _ in
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
extension tempRowWatch {
    func guardar() {
        do {
            try self.managedObjectContext.save()
            print("Cambios guardados.")
            
        } catch {
            print(error.localizedDescription)
        }
    }
    // Función para convertir el INT de duración restante en un string con formato HH:MM:SS
    func format(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        
        if duration < 3600 && duration >= 0 {
            formatter.allowedUnits = [.minute, .second]
        } else if duration < 0 && duration >= -3599 {
            formatter.allowedUnits = [.minute, .second]
        } else if duration <= -3600 {
            formatter.allowedUnits = [.hour, .minute]
        } else {
            formatter.allowedUnits = [.hour, .minute]
        }
        
        return formatter.string(from: duration)!
    }
}

//MARK: - Preview
#if DEBUG
struct tempRowWatch_Previews: PreviewProvider {
    static var previews: some View {
        let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
        
        let newMascarillaItem = Temporizadores.init(context: context)
        
        newMascarillaItem.id = UUID()
        newMascarillaItem.tipoMascarilla = "Mascarilla FFP2 Mascarilla FFP2 Mascarilla FFP2"
        newMascarillaItem.duracion = 3600
        newMascarillaItem.duracionRestante = 3059
        newMascarillaItem.horaInicio = Date()
        newMascarillaItem.enUso = true
        
		return tempRowWatch(datos: newMascarillaItem)
			.previewDevice("Apple Watch Series 3 - 38mm")
			.environment(\.managedObjectContext, context)
			.environmentObject(ajustesModel())
    }
}
#endif
