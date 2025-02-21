//
//  WebScrapingService.swift
//  WishOn
//
//  Created by Mari Budko on 21.02.2025.
//

import Foundation
import SwiftSoup
import Combine

class WebScrapingService: ObservableObject {
    static let shared = WebScrapingService()

    func fetchOpenGraphData(from url: String) -> AnyPublisher<(imageURL: String?, price: String?, title: String?), Error> {
        guard let url = URL(string: url) else {
            return Just((nil, nil, nil))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, _ in
                let document = try SwiftSoup.parse(String(data: data, encoding: .utf8)!)

                let imageURL = try? document.select("meta[property=og:image]").attr("content")
                let price = try? document.select("meta[property=og:price]").attr("content")
                let title = try? document.select("meta[property=og:title]").attr("content")

                return (imageURL, price, title)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
