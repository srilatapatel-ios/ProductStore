//
//  OfflineBanner.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 28/09/26.
//

import SwiftUI

struct OfflineBanner: View {

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "wifi.slash")
            VStack(
                alignment: .leading,
                spacing: 2
            ) {
                Text("You're offline")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("Changes will sync when you're connected.")
                    .font(.caption)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.orange.opacity(0.15))
    }
}
