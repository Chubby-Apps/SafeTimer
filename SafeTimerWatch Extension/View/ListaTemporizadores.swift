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
    @FetchRequest(entity: Temporizadores.entity(), sortDescriptors: [NSSortDescriptor(key: "duracionRestante", ascending: false)])
    var tMascarillas: FetchedResults<Temporizadores>
    private var alarma = AlarmaLogic()
    @State private var nTemp = false
    @State private var creditos = false
    
    private var width = WKInterfaceDevice.current().screenBounds.size.width
    
    
    var body: some View {
        List {
            ForEach(self.tMascarillas, id: \.self) { (mascarilla) in
                tempRowWatch(datos: mascarilla).environment(\.managedObjectContext, self.managedObjectContext)
            }.onDelete {self.deleteItem(at: $0)}
            .listRowPlatterColor(Color("nTempRowC"))
            
            NavigationLink(destination: nTempWatch().environment(\.managedObjectContext, managedObjectContext), isActive: $nTemp, label: {
                HStack {
                    VStack (alignment: .leading) {
                        if width > 136.0 {
                            Text("nuevoTempL")
                            .font(.body)
                            .bold()
                            .foregroundColor(.primary)
                        } else {
                            Text("nuevoTempS")
                            .font(.system(size: 12))
                            .bold()
                            .foregroundColor(.primary)
                        }
                    }
                    Spacer()
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .foregroundColor(.primary)
                        .offset(x: -5, y: 0)
                    .scaledToFill()
                }
            }).listRowPlatterColor(Color("nTempRowC")).frame(width: width-20, height: 70).scaledToFill()
            
                .listStyle(CarouselListStyle())
                .navigationBarTitle("SafeTimer")
        }
        .contextMenu(menuItems: {
            Button(action: {
                self.creditos = true
            }, label: {
                VStack{
                    Image(systemName: "info")
                        .font(.largeTitle)
                    Text("creditos")
                }
            })
        })
        .sheet(isPresented: $creditos, content: {
                creditosWatch()
            })
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("nuevaMascarilla"), object: nil, queue: .main) {_ in
                print("notifiación activada")
                self.nTemp = true
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
}

//MARK: - Preview
#if DEBUG
struct ListaTemporizadores_Previews: PreviewProvider {
    static var previews: some View {
        let context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
        return ListaTemporizadores().environment(\.managedObjectContext, context)
    }
}
#endif
