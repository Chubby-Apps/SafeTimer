//
//  botonIniciar.swift
//  SafeTimer
//
//  Created by Asier G. Morato on 15/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI

struct botonIniciar: View {
 @Environment(\.isEnabled) private var isEnabled: Bool
 var LocalizedKey: LocalizedStringKey
 
    var body: some View {
    Image(systemName: "arrow.right.circle")
        .font(.system(size: 40, weight: Font.Weight.bold, design: Font.Design.rounded))
        .foregroundColor(isEnabled ? Color(.systemBlue) : Color(.placeholderText))
        .offset(x: 0, y: -12)
        .accessibility(label: Text(LocalizedKey))
    }
}
