//
//  AjustesView.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 04/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI
import Combine

struct AjustesView: View {
    @EnvironmentObject var ajustes: ajustesModel
    @Environment(\.presentationMode) var presentationMode
    @State var alertaFuncionNoDisponible = false
    @Binding var cerrar: Bool
    
    private let productURL = URL(string: "https://itunes.apple.com/app/id1512032981")!
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("ABOUT"), footer: Text("hechoConAmor").font(.caption)) {
                    HStack {
                        iconoAjustes(icono: "star.fill", colorFondo: Color(.systemYellow))
                        Spacer().frame(width: 15)
                        Button(action: {
                            self.writeReview()
                        }) {
                            Text("valoraApp").foregroundColor(Color(.label))
                        }
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(Color(.systemGray3))
                            .accessibility(hidden: true)
                    }
                    HStack {
                        iconoAjustes(icono: "globe", colorFondo: Color(.systemGreen))
                        Spacer().frame(width: 15)
                        Button(action: {
                            if let url = URL(string: "http://hortelanos.net") {UIApplication.shared.open(url)}
                        }) {
                            Text("visitaNuestraWeb").foregroundColor(Color(.label))
                        }
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(Color(.systemGray3))
                            .accessibility(hidden: true)
                    }
                    HStack {
                        NavigationLink(destination: creditos(cerrar: self.$cerrar)) {
                            HStack {
                                iconoAjustes(icono: "info.circle", colorFondo: Color(.systemBlue))
                                Spacer().frame(width: 15)
                                Text("creditos")
                            }
                        }
                    }
                    
                    HStack {
                        iconoAjustes(icono: "doc.text.fill", colorFondo: Color(.systemGray))
                        Spacer().frame(width: 15)
                        Button(action: {
                            if let url = URL(string: "https://github.com/Hortelanos/SafeTimer/blob/master/Pol%C3%ADtica%20de%20Privacidad.md") {UIApplication.shared.open(url)}
                        }) {
                            Text("politicaPrivacidad").foregroundColor(Color(.label))
                        }
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(Color(.systemGray3))
                            .accessibility(hidden: true)
                    }
                    HStack {
                        iconoAjustes(icono: "envelope.fill", colorFondo: Color(.systemGray))
                        Spacer().frame(width: 15)
                        Button(action: {
                            if let url = URL(string: "mailto:asier@hortelanos.net?subject=Feedback%20SafeTimer") {UIApplication.shared.open(url)}
                        }) {
                            Text("enviarFeedback").foregroundColor(Color(.label))
                        }
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(Color(.systemGray3))
                            .accessibility(hidden: true)
                    }
                }
            }
                
            .navigationBarTitle("ajustes")
            .navigationBarItems(trailing: Button(action: {self.cerrar = false}) {Image(systemName: "xmark.circle.fill").font(.system(size: 25)).foregroundColor(Color(.systemRed)).accessibility(label: Text("cerrar"))})
        }
    }
}
//MARK: - Funciones Review
extension AjustesView {
    

    private func writeReview() {
      var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
      components?.queryItems = [
        URLQueryItem(name: "action", value: "write-review")
      ]

      guard let writeReviewURL = components?.url else {
        return
      }

      UIApplication.shared.open(writeReviewURL)
    }
}


//MARK: - Preview
#if DEBUG
struct AjustesView_Previews: PreviewProvider {
    static var previews: some View {
        AjustesView(cerrar: .constant(false)).environmentObject(ajustesModel())
    }
}
#endif
//                NavigationLink(destination: ConsejosView()) {
//                    HStack {
//                        iconoAjustes(icono: "info.circle", colorFondo: Color(.systemBlue))
//                        Spacer().frame(width: 15)
//                        Text("Consejos")
//                    }
//                }
//
//                Section (header: Text("MASCARILLAS")){
//                    HStack {
//                        Text("Quirúrgica")
//                        Spacer()
//
//                        Stepper(value: $ajustes.quirurgica, in: 1...99, step: 1) {
//                            if ajustes.quirurgica == 1 {
//                                Text("\(String(ajustes.quirurgica)) hora")
//                            } else {
//                                Text("\(String(ajustes.quirurgica)) horas")
//                            }
//                        }.frame(width: 171)
//                    }
//                    HStack {
//                        Text("FFP2")
//                        Spacer()
//
//                        Stepper(value: $ajustes.ffp2, in: 1...99, step: 1) {
//                            if ajustes.ffp2 == 1 {
//                                Text("\(String(ajustes.ffp2)) hora")
//                            } else {
//                                Text("\(String(ajustes.ffp2)) horas")
//                            }
//                        }.frame(width: 171)
//                    }
//                    HStack {
//                        Text("FFP3")
//                        Spacer()
//
//                        Stepper(value: $ajustes.ffp3, in: 1...99, step: 1) {
//                            if ajustes.ffp3 == 1 {
//                                Text("\(String(ajustes.ffp3)) hora")
//                            } else {
//                                Text("\(String(ajustes.ffp3)) horas")
//                            }
//                        }.frame(width: 171)
//                    }
//                    HStack {
//                        Text("Otro")
//                        Spacer()
//
//                        Stepper(value: $ajustes.otro, in: 1...99, step: 1) {
//                            if ajustes.otro == 1 {
//                                Text("\(String(ajustes.otro)) hora")
//                            } else {
//                                Text("\(String(ajustes.otro)) horas")
//                            }
//                        }.frame(width: 171)
//                    }
//                }
