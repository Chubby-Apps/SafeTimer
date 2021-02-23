//
//  creditosWatch.swift
//  SafeTimer
//
//  Created by Asier G. Morato on 17/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI

struct creditosWatch: View {

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        ScrollView {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 90)
            Text("v\(appVersion ?? "")")
                .font(.system(Font.TextStyle.headline, design: Font.Design.rounded))
                .bold()
            Spacer().frame(height: 20)
            HStack {
                Text("tCredito")
                    .fontWeight(.regular)
                    .font(.system(Font.TextStyle.callout, design: Font.Design.rounded))
                    
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
        }
        .navigationBarTitle("creditos")
    }
}
//MARK: - Preview
#if DEBUG
struct creditosWatch_Previews: PreviewProvider {
    static var previews: some View {
        creditosWatch()
    }
}
#endif
