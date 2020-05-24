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
     Text(LocalizedKey)
        .font(.body)
        .bold()
        .foregroundColor(isEnabled ? Color.white : Color(UIColor.systemGray2))
        .padding(.horizontal, 25).padding(.vertical, 12)
        .background(isEnabled ? Color(.systemBlue) : Color(.systemGray5))
        .cornerRadius(15)
    }
}
