//
//  iconoAjustes.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 05/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI

struct iconoAjustes: View {
    var icono: String
    var colorFondo: Color
    var offsetX: CGFloat?
    var offsetY: CGFloat?
    var tamanoIcono: CGFloat?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(colorFondo)
            Image(systemName: icono)
                .font(.system(size: tamanoIcono ?? 20))
                .foregroundColor(Color.white)
                .offset(x: offsetX ?? 0, y: offsetY ?? 0)
                .accessibility(hidden: true)
        }.frame(width: 35, height: 35, alignment: .center)
    }
}
#if DEBUG
struct iconoAjustes_Previews: PreviewProvider {
    static var previews: some View {
        iconoAjustes(icono: "tortoise.fill", colorFondo: .red)
    }
}
#endif
