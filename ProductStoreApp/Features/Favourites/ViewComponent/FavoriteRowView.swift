//
//  FavouriteRowView.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import SwiftUI

struct FavouriteRowView: View {
    
    let product: ProductViewEntity
    let onRemove: () -> Void
    let imageLoader: ImageLoader
    
    var body: some View {
        HStack(spacing: 12) {
            ProductImageView(
                localImageData: product.localImageData,
                imageURL: product.imageURL,
                imageLoader: imageLoader
            )
            .frame(width: 80, height: 80)
            .clipped()
            .cornerRadius(8)
            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(product.priceText)
                Text(product.ratingText)
                    .font(.caption)
                Text(product.stockText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(syncStatusText)
                    .font(.caption)
                    .foregroundStyle(syncStatusColor)
            }
            Spacer()
            Button {
                onRemove()
            } label: {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.red)
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 4)
    }
    
    private var syncStatusText: String {
        
        switch product.syncStatus {
        case .pending:
            return "⏳ Not Synced"
        case .syncing:
            return "↻ Syncing..."
        case .synced:
            return "✓ Synced"
        case .failed:
            return "⚠ Sync Failed"
        }
    }
    
    private var syncStatusColor: Color {
        
        switch product.syncStatus {
        case .pending:
            return .orange
        case .syncing:
            return .blue
        case .synced:
            return .green
        case .failed:
            return .red
        }
    }
}
