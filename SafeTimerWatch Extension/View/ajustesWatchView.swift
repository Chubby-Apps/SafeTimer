//
//  ajustesWatchView.swift
//  SafeTimerWatch Extension
//
//  Created by Asier on 26/06/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI

struct ajustesWatchView: View {
    @EnvironmentObject var ajustes: ajustesModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("temporizadores").font(.system(Font.TextStyle.footnote, design: Font.Design.rounded)), footer: Text("notificacionesInfo").font(.system(Font.TextStyle.caption, design: Font.Design.rounded))) {
                
                Toggle(isOn: $ajustes.numeroDeUsos) {
                    Text("contarUsos")
                        .foregroundColor(Color.primary)
                        .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                }
                
                Toggle(isOn: $ajustes.notificacionRecordatorio) {
                    Text("notificacionesRecurrentes")
                        .foregroundColor(Color.primary)
                        .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                }
                
            }
            
            Section(header: Text("ABOUT").font(.system(Font.TextStyle.footnote, design: Font.Design.rounded)), footer: Text("hechoConAmor").font(.system(Font.TextStyle.caption, design: Font.Design.rounded))) {
                NavigationLink(destination: creditosWatch()) {
                    Text("creditos")
                        .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                }
                
//                Button(action: {
//                    if let url = URL(string: "https://github.com/Hortelanos/SafeTimer/blob/master/Pol%C3%ADtica%20de%20Privacidad.md") {WKExtension.shared().openSystemURL(url)}
//                }) {
//                    Text("politicaPrivacidad")
//                        .foregroundColor(Color.primary)
//                        .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
//                }
//
//                Button(action: {
//                    if let url = URL(string: "mailto:asier@hortelanos.net?subject=Feedback%20SafeTimer") {WKExtension.shared().openSystemURL(url)}
//                }) {
//                    Text("enviarFeedback").foregroundColor(Color.primary)
//                        .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
//                }
                
            }
        }
        .navigationBarTitle("ajustes")
    }
}

//MARK: - Preview
#if DEBUG
struct ajustesWatchView_Previews: PreviewProvider {
    static var previews: some View {
        ajustesWatchView()
    }
}
#endif
