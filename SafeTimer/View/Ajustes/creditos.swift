//
//  creditos.swift
//  SafeTimer
//
//  Created by Asier G. Morato on 14/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI

struct creditos: View {
    @Binding var cerrar: Bool
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        Form {
            List {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110, height: 110)
                    .accessibility(label: Text("Logo SafeTimer"))
                Text("v\(appVersion ?? "")")
                    .font(.system(Font.TextStyle.headline, design: Font.Design.rounded))
                    .bold()
                    
                Spacer().frame(height: 20)
                HStack {
                    Text("tCredito")
                        .fontWeight(.regular)
                        .font(.system(Font.TextStyle.callout, design: Font.Design.rounded))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                Spacer().frame(height: 20)
                HStack {
                    Text("asier")
                        .fontWeight(.regular)
                        .font(.system(Font.TextStyle.callout, design: Font.Design.rounded))
                    Spacer()
                }
                Spacer().frame(height: 10)
                HStack {
                    Text("patricia")
                        .fontWeight(.regular)
                        .font(.system(Font.TextStyle.callout, design: Font.Design.rounded))
                    Spacer()
                }
                Spacer().frame(height: 10)
            }
                
        .navigationBarTitle("creditos")
            .navigationBarItems(trailing: Button(action: {self.cerrar = false}) {Image(systemName: "xmark.circle.fill").font(.system(size: 25)).foregroundColor(Color(.systemRed)).accessibility(label: Text("cerrar"))})
        }
    }
}
//MARK: - Preview
#if DEBUG
struct creditos_Previews: PreviewProvider {
    static var previews: some View {
        creditos(cerrar: .constant(false))
    }
}
#endif
