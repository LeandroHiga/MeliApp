//
//  ProductDetailViewController.swift
//  MeliApp
//
//  Created by Lean Caro on 22/12/2020.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var linkTextView: UITextView!
    
    var product: Results?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Use light mode
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .light
        }
        
        if let title = product?.title {
            titleLabel.text = "Título: \(title)"
        }
        
        if let price = product?.price {
            priceLabel.text = "Precio: \(String(price))"
        }
        
        if let currency = product?.currency_id {
            currencyLabel.text = "Moneda: \(currency)"
        }
        
        if let condition = product?.condition {
            conditionLabel.text = "Condición: \(condition)"
        }
        
        if let link = product?.permalink {
            linkTextView.text = "Publicación: \(link)"
        }
        
        if let imageLink = product?.thumbnail {
            
            let imageURL = imageLink.replacingOccurrences(of: "http:", with: "https:")
            let finalImageURL = URL(string: imageURL)
            print(finalImageURL!)
            
            self.imageView.downloadImage(from: finalImageURL!)
        }
        
        updateTextView(text: linkTextView.text)
        
    }
    
    //Add hyperlink
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

//MARK: - UIImageView

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
