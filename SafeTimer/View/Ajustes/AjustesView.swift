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
                
                Section(header: Text("temporizadores").font(.system(Font.TextStyle.footnote, design: Font.Design.rounded)), footer: Text("notificacionesInfo").font(.system(Font.TextStyle.caption, design: Font.Design.rounded))) {
                    
                    HStack {
                        iconoAjustes(icono: "textformat.123", colorFondo: Color(.systemTeal), offsetX: -0.2, tamanoIcono: 14)
                    
                    Spacer().frame(width: 15)

                    Toggle(isOn: $ajustes.numeroDeUsos) {
                        Text("contarUsos")
                        .foregroundColor(Color(.label))
                        .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                    }
                    }
                    HStack {
                        iconoAjustes(icono: "timer", colorFondo: Color(.systemRed),offsetX: 0.2, offsetY: -0.5, tamanoIcono: 20)

                        Spacer().frame(width: 15)

                        Toggle(isOn: $ajustes.notificacionRecordatorio) {
                            Text("notificacionesRecurrentes")
                            .foregroundColor(Color(.label))
                            .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                        }
                    }
                }
                
                Section(header: Text("ABOUT").font(.system(Font.TextStyle.footnote, design: Font.Design.rounded)), footer: Text("hechoConAmor").font(.system(Font.TextStyle.caption, design: Font.Design.rounded))) {
                    HStack {
                        iconoAjustes(icono: "star.fill", colorFondo: Color(.systemYellow), offsetY: -0.5)
                        Spacer().frame(width: 15)
                        Button(action: {
                            self.writeReview()
                        }) {
                            Text("valoraApp")
                                .foregroundColor(Color(.label))
                                .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(.systemGray3))
                            .font(.system(size: 13, weight: .semibold, design: Font.Design.rounded))
                            .accessibility(hidden: true)
                    }
                    HStack {
                        iconoAjustes(icono: "globe", colorFondo: Color(.systemGreen), tamanoIcono: 20)
                        Spacer().frame(width: 15)
                        Button(action: {
                            if let url = URL(string: "http://hortelanos.net") {UIApplication.shared.open(url)}
                        }) {
                            Text("visitaNuestraWeb")
                                .foregroundColor(Color(.label))
                                .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(.systemGray3))
                            .font(.system(size: 13, weight: .semibold, design: Font.Design.rounded))
                            .accessibility(hidden: true)
                    }
                    HStack {
                        NavigationLink(destination: creditos(cerrar: self.$cerrar)) {
                            HStack {
                                iconoAjustes(icono: "info", colorFondo: Color(.systemBlue),offsetY: -1, tamanoIcono: 19)
                                Spacer().frame(width: 15)
                                Text("creditos")
                                    .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                            }
                        }
                    }
                    
                    HStack {
                        iconoAjustes(icono: "doc.text.fill", colorFondo: Color(.systemGray), offsetX: 0.2, offsetY: -0.2)
                        Spacer().frame(width: 15)
                        Button(action: {
                            if let url = URL(string: "https://safetimer.app/privacypolicy/") {UIApplication.shared.open(url)}
                        }) {
                            Text("politicaPrivacidad")
                                .foregroundColor(Color(.label))
                                .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(.systemGray3))
                            .font(.system(size: 13, weight: .semibold, design: Font.Design.rounded))
                            .accessibility(hidden: true)
                    }
                    HStack {
                        iconoAjustes(icono: "envelope.fill", colorFondo: Color(.systemGray))
                        Spacer().frame(width: 15)
                        Button(action: {
                            if let url = URL(string: "mailto:asier@hortelanos.net?subject=Feedback%20SafeTimer") {UIApplication.shared.open(url)}
                        }) {
                            Text("enviarFeedback").foregroundColor(Color(.label))
                                .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(.systemGray3))
                            .font(.system(size: 13, weight: .semibold, design: Font.Design.rounded))
                            .accessibility(hidden: true)
                    }
                }
            }.listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
                
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
