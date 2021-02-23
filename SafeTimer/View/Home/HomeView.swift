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
    @FetchRequest(entity: Temporizadores.entity(), sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)]) var tMascarillas: FetchedResults<Temporizadores>
    // Ajustes
    @EnvironmentObject var ajustes: ajustesModel
    // Pantalla
    @State var abrirAjustes = false
    @State var anadir = false
    // Alarma
    private var alarma = AlarmaLogic()
    
    init() {
        UITableView.appearance().separatorStyle = .none // To remove all separators in list
        let fontSize: CGFloat = 24
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            let font = UIFont.init(descriptor: descriptor, size: 35)
            UINavigationBar.appearance().largeTitleTextAttributes = [.font : font]
        }
    }
        
    var body: some View {
        NavigationView {
            List {
                ForEach(self.tMascarillas, id: \.self) { (mascarilla) in
                    mascarillaRow(datos: mascarilla)
                }
                    .onDelete(perform: deleteItem)
                    .onMove(perform: moveItem)
                    .accessibility(hidden: anadir ? true : false)
                
                
                nuevoTemporizadorRow(anadir: $anadir)
                    .environment(\.managedObjectContext, self.managedObjectContext)
                    .animation(.spring())
                
            }
            .listStyle(PlainListStyle())
            .buttonStyle(BorderlessButtonStyle())
            .modifier(AdaptsToSoftwareKeyboard())
            
            .navigationTitle("SafeTimer")
            .navigationBarItems(leading:
                Button(action: {
                    self.abrirAjustes.toggle()
                }){
                    Image(systemName: "gear")
                        .font(.system(size: 25, weight: Font.Weight.medium, design: Font.Design.rounded))
                        .accessibility(label: Text("ajustes"))
                        .accessibility(hidden: anadir ? true : false)
                },trailing:
                    EditButton()
                        .font(.system(Font.TextStyle.headline, design: Font.Design.rounded))
                        .accessibility(hidden: anadir ? true : false)
            )
            
        }
            
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("nuevaMascarilla"), object: nil, queue: .main) {_ in
                self.anadir = true
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
            
        .sheet(isPresented: self.$abrirAjustes) {
            AjustesView(cerrar: self.$abrirAjustes).environmentObject(self.ajustes)
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
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return HomeView().environment(\.managedObjectContext, context)
    }
}
#endif
