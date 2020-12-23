//
//  ProductDetailViewController.swift
//  MeliApp
//
//  Created by Lean Caro on 22/12/2020.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var priceTextView: UITextView!
    @IBOutlet weak var currencyTextView: UITextView!
    @IBOutlet weak var conditionTextView: UITextView!
    @IBOutlet weak var linkTextView: UITextView!
    
    //Product selected from previous screen
    var product: Results?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Use light mode
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .light
        }
        
        if let title = product?.title {
            titleTextView.text = "\(title)"
        }
        
        if let price = product?.price {
            priceTextView.text = "Precio: \(String(price))"
        }
        
        if let currency = product?.currency_id {
            currencyTextView.text = "Moneda: \(currency)"
        }
        
        if let condition = product?.condition {
            conditionTextView.text = "Condición: \(condition)"
        }
        
        if let link = product?.permalink {
            linkTextView.text = "Publicación: \(link)"
        }
        
        if let imageLink = product?.thumbnail {
            
            //Use https to secure connection
            let imageURL = imageLink.replacingOccurrences(of: "http:", with: "https:")
            let finalImageURL = URL(string: imageURL)
            
            self.imageView.downloadImage(from: finalImageURL!)
        }
        
        updateTextView(text: linkTextView.text)
    }
    
    //Add hyperlink -> redirect to publication
    func updateTextView(text: String) {
        
        if let url = product?.permalink {
            
            let productURL = URL(string: url)!
            let attributedString = NSMutableAttributedString(string: text)
            
            attributedString.setAttributes([.link: productURL], range: NSMakeRange(13, (text as NSString).length - 13))
            
            self.linkTextView.attributedText = attributedString
            self.linkTextView.isUserInteractionEnabled = true
            self.linkTextView.isEditable = false
        }
    }
}

//MARK: - UIImageView - Fetch image

extension UIImageView {

   func downloadImage(from url: URL) {
      getData(from: url) { data, response, error in
         guard let data = data, error == nil else {
            return
         }
         DispatchQueue.main.async() {
            self.image = UIImage(data: data)
         }
      }
   }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
       URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
