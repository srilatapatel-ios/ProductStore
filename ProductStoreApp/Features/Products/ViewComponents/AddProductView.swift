//
//  AddProductView.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhoto: PhotosPickerItem?
    
    @State private var viewModel: AddProductViewModel
    
    init(repository: ProductRepository) {
        _viewModel = State(
            initialValue: AddProductViewModel(repository: repository)
        )
    }
    
    var body: some View {
        Form {
            Section("Product Information") {
                TextField("Title", text: $viewModel.title)
                TextField("Description", text: $viewModel.description, axis: .vertical)
                    .lineLimit(3...6)
                TextField("Price", text: $viewModel.price)
                    .keyboardType(.decimalPad)
                TextField("Category", text: $viewModel.category)
            }
            Section("Product Image") {
                if let data = viewModel.selectedImageData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(12)
                }
                
                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .images
                ) {
                    Label("Select Image", systemImage: "photo")
                }
                .onChange(of: selectedPhoto) { _, newItem in
                    guard let newItem else {
                        return
                    }
                    Task {
                        do {
                            if let data = try await newItem.loadTransferable(type: Data.self) {
                                if let image = UIImage(data: data),
                                   let compressedData = image.jpegData(
                                    compressionQuality: 0.7
                                   ) {
                                    viewModel.selectedImageData = compressedData
                                }
                            }
                        } catch {
                            print("Failed to load image: \(error)")
                        }
                    }
                }
            }
            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
            Section {
                Button {
                    if viewModel.saveProduct() {
                        dismiss()
                    }
                } label: {
                    Text("Add Product")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Add Product")
        .navigationBarTitleDisplayMode(.inline)
    }
}
