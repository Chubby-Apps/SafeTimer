//
//  ContentView.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 04/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct HomeView: View {
    // Core Data
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Temporizadores.entity(), sortDescriptors: [NSSortDescriptor(key: "duracionRestante", ascending: false)])
    var tMascarillas: FetchedResults<Temporizadores>
    // Ajustes
    @EnvironmentObject var ajustes: ajustesModel
    // Pantalla
    @State var showSheet = false
    @State var activeSheet: ActiveSheet = .ajustes
    enum ActiveSheet {
        case ajustes, consejos, nuevaMascarilla
    }
    
    private var alarma = AlarmaLogic()
    
    init() {
        UITableView.appearance().separatorStyle = .none // To remove all separators in list
    }
    
    var body: some View {
//        ZStack {
            NavigationView {
                List {
                    ForEach(self.tMascarillas, id: \.self) { (mascarilla) in
                        mascarillaRow(datos: mascarilla)
                    }.onDelete(perform:
                        self.deleteItem
                    )
                    nuevoTemporizadorRow(activeSheet: $activeSheet, showSheet: $showSheet)
                }.buttonStyle(BorderlessButtonStyle())
                    
                .navigationBarTitle("SafeTimer")
                .navigationBarItems(leading: Button(action: {self.activeSheet = .ajustes; self.showSheet.toggle()}) {Image(systemName: "gear").font(.system(size: 25)).accessibility(label: Text("ajustes"))}
                    ,trailing: EditButton())
                
                
            }
//            VStack(alignment: .trailing) {
//                Spacer()
//                HStack {
//                    Spacer()
//                    Button(action: {self.activeSheet = .nuevaMascarilla; self.showSheet.toggle()}) {
//                        Image(systemName: "plus.circle.fill")
//                            .font(.system(size: 50.0))
//                            .foregroundColor(Color.blue)
//                            .accessibility(label: Text("nuevoTempL"))
//                    }
//                    .padding()
//                    Spacer()
//                }
//            }
//
//        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("nuevaMascarilla"), object: nil, queue: .main) {_ in
                self.activeSheet = .nuevaMascarilla
                self.showSheet = true
            }
        }
            
        .sheet(isPresented: self.$showSheet) {
            if self.activeSheet == .ajustes {
                AjustesView(cerrar: self.$showSheet).environmentObject(self.ajustes)
            } else if self.activeSheet == .nuevaMascarilla {
                nuevaMascarillaView(cerrar: self.$showSheet).environmentObject(self.ajustes).environment(\.managedObjectContext, self.managedObjectContext)
            }
        }
    }
}

//MARK: - Funciones
extension HomeView {
    private func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = tMascarillas[index]
            self.alarma.pararAlarma(ID: item.id!)
            managedObjectContext.delete(item)
        }
    }
}

//MARK: - Preview
#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return HomeView().environment(\.managedObjectContext, context)
    }
}
#endif
