
//
//  Created by sina on 13.10.2024.
//

import SwiftUI

struct HeaderView: View {

    var body: some View {
        ZStack {
            Image("App")
                .resizable()
                .frame(width: 100, height: 100) // Sabit değerler kullanıldı
            Text("Alpha")
                .font(.system(size: 50))
                .fontWeight(.bold)
                .padding(.top, 30)
        }
    }
}

#Preview {
    HeaderView()
}
