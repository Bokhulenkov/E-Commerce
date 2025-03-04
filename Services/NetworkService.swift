//
//  NetworkService.swift
//  E-Commerce
//
//  Created by Anna Melekhina on 04.03.2025.
//

import UIKit

let url = "https://fakestoreapi.com/products"

protocol NetworkServiceDelegate {
    func didUpdateData(products: [ProductModel])
    func didFailWithError(error: Error)
}

struct NetworkService {
    
    var delegate: NetworkServiceDelegate?
    
    func performRequest() {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Ошибка запроса: \(error.localizedDescription)")
                    return
                }
                
                if let safeData = data {
                    if let productModel = self.parseJSON(safeData) {
                        DispatchQueue.main.async {
                            self.delegate?.didUpdateData(products: productModel)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ productData: Data) -> [ProductModel]? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ProductData.self, from: productData)
            
            let productModels = decodedData.products.map { product in
                ProductModel(
                    id: product.id,
                    title: product.title,
                    price: product.price,
                    description: product.description,
                    category: product.category,
                    image: product.image
                )
            }
            return productModels
        } catch {
            print("Ошибка декодирования: \(error)")
            return nil
        }
    }
}

