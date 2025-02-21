//
//  ImageLoader.swift
//  WishOn
//
//  Created by Mari Budko on 21.02.2025.
//

import Foundation
import Combine
import UIKit

class ImageLoaderService: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var errorMessage: String? = nil  
    private var cancellable: AnyCancellable?
    
    func loadImage(from url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response in
                UIImage(data: data)
            }
            .catch { error -> Just<UIImage?> in
                self.errorMessage = "Failed to load image: \(error.localizedDescription)"
                return Just(nil)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

