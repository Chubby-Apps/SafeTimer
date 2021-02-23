//
//  ListaTemporizadores.swift
//  SafeTimer
//
//  Created by Asier G. Morato on 16/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI
import CoreData
import CloudKit

struct ListaTemporizadores: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Temporizadores.entity(), sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)]) var tMascarillas: FetchedResults<Temporizadores>
    private var alarma = AlarmaLogic()
    @EnvironmentObject private var ajustes: ajustesModel
    @State private var nTemp = false
    @State private var creditos = false
    
    private var width = WKInterfaceDevice.current().screenBounds.size.width
    
    var body: some View {
        List {
            
            // Temporizadores
            ForEach(self.tMascarillas, id: \.self) { (mascarilla) in
				tempRowWatch(datos: mascarilla)
					.accessibilityAction(.init(named: Text("borrar")), {
						self.alarma.pararAlarma(ID: mascarilla.id!)
						managedObjectContext.delete(mascarilla)
					})
			}.onDelete(perform: deleteItem)
			
			
//            .onMove(perform: moveItem)
            .listRowPlatterColor(Color("nTempRowC"))
            
            // Añadir temporizador
            NavigationLink(destination: nTempWatch().environment(\.managedObjectContext, managedObjectContext), isActive: $nTemp, label: {
                HStack {
                    VStack (alignment: .leading) {
                        Text(width > 136.0 ? "nuevoTempL" : "nuevoTempS")
                            .font(width > 136.0 ? .system(Font.TextStyle.body, design: Font.Design.rounded) : .system(size: 13, weight: .medium, design: Font.Design.rounded))
                            .bold()
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    Image(systemName: "plus.circle")
                        .font(.system(size: 30, weight: Font.Weight.bold, design: Font.Design.rounded))
                        .foregroundColor(.primary)
                        .offset(x: -5, y: 0)
                    .scaledToFill()
                }
            }).padding(.vertical, 15).listRowPlatterColor(Color("nTempRowC")).frame(width: width-20).scaledToFill()
            
            // Ajustes
            NavigationLink(destination: ajustesWatchView().environmentObject(self.ajustes), isActive: $creditos, label: {
                HStack {
                    Spacer()
                    Image(systemName: "gear")
                        .font(.system(size: 15, weight: Font.Weight.bold, design: Font.Design.rounded))
                        .foregroundColor(.primary)
                    Text("ajustes")
                        .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                        .bold()
                        .foregroundColor(.primary)
                    
                    Spacer()
                }.padding(.horizontal)
            })
                
                .listStyle(CarouselListStyle())
            
        }.navigationTitle("SafeTimer")
        
        
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("nuevaMascarilla"), object: nil, queue: .main) {_ in
                print("notifiación activada")
                self.nTemp = true
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("pararDesdeNotificacion"), object: nil, queue: .main) {notification in
                guard let id = notification.userInfo?["id"] as? String else { return }
                
                let fetchRequest = NSFetchRequest<Temporizadores>(entityName: "Temporizadores")

                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                
                do {
                    let tempEnUso = try self.managedObjectContext.fetch(fetchRequest)
                    tempEnUso[0].enUso = false
                    
                    let horaActual = Date()
                    let difference = Calendar.current.dateComponents([.second], from: tempEnUso[0].horaInicio!, to: horaActual)
                    tempEnUso[0].duracionRestante = tempEnUso[0].duracionRestante - Double(difference.second!)
                } catch let error as NSError {
                    print ("Could not fetch. \(error), \(error.userInfo)")
                }
            }
        }
        
        
    }
}
//MARK: - Funciones Lista
extension ListaTemporizadores {
    private func deleteItem(at indices: IndexSet) {
         indices.forEach {
            let item = tMascarillas[$0]
            self.alarma.pararAlarma(ID: item.id!)
            managedObjectContext.delete(item)
        }
    }
    func moveItem(indexSet: IndexSet, destination: Int) {
        let source = indexSet.first!
        
        if source < destination {
            var startIndex = source + 1
            let endIndex = destination - 1
            var startOrder = tMascarillas[source].order
            while startIndex <= endIndex {
                tMascarillas[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            
            tMascarillas[source].order = startOrder
            
        } else if destination < source {
            var startIndex = destination
            let endIndex = source - 1
            var startOrder = tMascarillas[destination].order + 1
            let newOrder = tMascarillas[destination].order
            while startIndex <= endIndex {
                tMascarillas[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            tMascarillas[source].order = newOrder
        }
        
        saveItems()
    }
    func saveItems() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}

//MARK: - Preview
#if DEBUG
struct ListaTemporizadores_Previews: PreviewProvider {
    static var previews: some View {
        let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
        return ListaTemporizadores()
			.environment(\.managedObjectContext, context)
			.environmentObject(ajustesModel())
    }
}
#endif
