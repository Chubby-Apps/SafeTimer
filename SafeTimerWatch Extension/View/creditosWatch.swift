//
//  creditosWatch.swift
//  SafeTimer
//
//  Created by Asier G. Morato on 17/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI

struct creditosWatch: View {
    var body: some View {
        ScrollView {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 90)
            Text("v1.0.1")
                .font(.headline)
                .bold()
            Spacer().frame(height: 20)
            HStack {
                Text("tCredito")
                    .fontWeight(.regular)
                    .font(.callout)
                    
                Spacer()
            }
            Spacer().frame(height: 20)
            HStack {
                Text("asier")
                    .fontWeight(.regular)
                    .font(.callout)
                Spacer()
            }
            Spacer().frame(height: 10)
            HStack {
                Text("patricia")
                    .fontWeight(.regular)
                    .font(.callout)
                Spacer()
            }
        }
    }
}

struct creditosWatch_Previews: PreviewProvider {
    static var previews: some View {
        creditosWatch()
    }
}
