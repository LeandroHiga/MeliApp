//
//  ProductManager.swift
//  MeliApp
//
//  Created by Lean Caro on 21/12/2020.
//

import Foundation
import SVProgressHUD

protocol ProductManagerDelegate {
    func didUpdateProducts(_ productManager: ProductManager, products: ProductData)
    func didFailWithError(error: Error)
}

struct ProductManager {

    let productURL = "https://api.mercadolibre.com/sites/MLA/search?"
    var delegate: ProductManagerDelegate?
    
    //Fetch products based on entered product name
    func fetchProducts(productName: String) {
        
        let urlString = "\(productURL)q=\(productName)"
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create URL Session
            let session = URLSession(configuration: .default)
            
            //3.Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                //Check if there is an error
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    //If there is an error, exit out of the function
                    return
                }
                //Check if data is nil
                if let safeData = data {
                    if let products = self.parseJSON(safeData) {
                        self.delegate?.didUpdateProducts(self, products: products)
                    }
                }
            }
            
            SVProgressHUD.dismiss()
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ productData: Data) -> ProductData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ProductData.self, from: productData)

            let products = ProductData(results: decodedData.results)
            
            return products
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
