//
//  bIniciarWatch.swift
//  SafeTimer
//
//  Created by Asier G. Morato on 16/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI

struct bIniciarWatch: View {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    var body: some View {
        HStack {
            Spacer()
            Text("iniciar")
                .font(.system(Font.TextStyle.body, design: Font.Design.rounded))
                .bold()
                .foregroundColor(isEnabled ? Color.white : Color.gray)
            Spacer()
        }
    }
}

struct bIniciarWatch_Previews: PreviewProvider {
    static var previews: some View {
        bIniciarWatch().previewLayout(.sizeThatFits)
    }
}
