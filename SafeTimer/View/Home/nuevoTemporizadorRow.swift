//
//  nuevoTemporizadorRow.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 11/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI

struct nuevoTemporizadorRow: View {
    
    @Binding var activeSheet: HomeView.ActiveSheet
    @Binding var showSheet: Bool
 
    var body: some View {
        Button(action: {
            self.activeSheet = .nuevaMascarilla
            self.showSheet = true
        }) {
            Group {
                HStack {
                    VStack (alignment: .leading) {
                        Text("nuevoTempL")
                            .font(.body)
                            .bold()
                            .foregroundColor(Color(.systemBlue))
                    }
                    .padding(.leading, 5).padding(.vertical, 12).frame(height: 90)
                    
                    Spacer()
                    
                    Image(systemName: "plus.circle")
                        .font(.system(size: 50))
                        .foregroundColor(Color(.systemBlue))
                    }.padding(.horizontal)
                    .background(Color("nTempRowC")).cornerRadius(20)
            }.frame(height: 90)
        }
    }
}

struct nuevoTemporizadorRow_Previews: PreviewProvider {
    static var previews: some View {
        nuevoTemporizadorRow(activeSheet: .constant(.nuevaMascarilla), showSheet: .constant(false))
    }
}
