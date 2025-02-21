//
//  NewItemView.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import SwiftUI
import PhotosUI

struct AddNewItemView: View {
    
    @Binding var isShown: Bool
    @State private var name = ""
    @State private var wishLink = ""
    @State private var imageLink = ""
    @State private var price = ""
    @State private var currency = "UAH"
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    @Binding var wishes: [Wish]
    let currencies = Locale.commonISOCurrencyCodes.sorted()
    
    var body: some View {
        ZStack{
            Color.white.opacity(0.1)
                .ignoresSafeArea()
            VStack {
                HStack{
                    Button{
                        isShown = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(Color(Asset.primaryColor.color))
                    }
                    .frame(width: 24, height: 24)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                ZStack{
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .clipShape(.circle)
                    } else {
                        Image(systemName: "gift.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .foregroundColor(Color(Asset.primaryColor.color).opacity(0.8))
                            .clipShape(.circle)
                    }
                    
                    PhotosPicker(selection: $pickerItem, matching: .images, preferredItemEncoding: .current) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 24, height: 24)
                    .padding(.top, 110)
                    .padding(.leading, 80)
                    .onChange(of: pickerItem) {
                        Task {
                            if let pickerItem,
                               let data = try await pickerItem.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                selectedImage = fixOrientation(uiImage)
                            }
                        }
                    }
                }
                
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                TextField("Link", text: $wishLink)
                    .textFieldStyle(.roundedBorder)
                
                HStack{
                    TextField("Price", text: $price)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: .infinity)
                    Picker("", selection: $currency){
                        ForEach(currencies, id: \.self) {
                            Text($0)
                        }
                    }.accentColor(Color(Asset.primaryColor.color))
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                
                Button {
                    let wish = Wish(name: name, image: imageLink, currency: currency, link: wishLink)
                    wishes.append(wish)
                    isShown = false
                } label: {
                    Text("Create")
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color(Asset.greenButtonTextColor.color))
                }
                .padding()
                .background(Color(Asset.primaryColor.color))
                .cornerRadius(30)
                .padding(.top, 20)
                
            }
            .padding(20)
            .cornerRadius(8)
            .background(Color(Asset.backgroundColor.color))
            .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
            .padding(.horizontal, 16)
        }
    }
    
    func fixOrientation(_ image: UIImage) -> UIImage {
        if image.imageOrientation == .up {
            return image
        }

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return normalizedImage
    }
}

#Preview {
    AddNewItemView(isShown: .constant(true), wishes: .constant([]))
}
