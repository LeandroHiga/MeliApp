//
//  ProductDetailViewController.swift
//  MeliApp
//
//  Created by Lean Caro on 22/12/2020.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceTextView: UITextView!
    @IBOutlet weak var currencyTextView: UITextView!
    @IBOutlet weak var conditionTextView: UITextView!
    @IBOutlet weak var availableQuantityTextView: UITextView!
    @IBOutlet weak var stateTextView: UITextView!
    @IBOutlet weak var cityTextView: UITextView!
//    @IBOutlet weak var sellerTextView: UITextView!
//    @IBOutlet weak var publicationTextView: UITextView!
    @IBOutlet weak var publicationTextView: UITextView!
    @IBOutlet weak var sellerTextView: UITextView!
    
    //Product selected from previous screen
    var product: Results?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Use light mode
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .light
        }
        
        if let title = product?.title {
            descriptionTextView.text = "\(title)"
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
        
        if let quantity = product?.available_quantity {
            availableQuantityTextView.text = "Cantidad disponible: \(quantity)"
        }
        
        if let state = product?.address.state_name {
            stateTextView.text = "Provincia: \(state)"
        }
        
        if let city = product?.address.city_name {
            cityTextView.text = "Ciudad: \(city)"
        }
        
//        if let seller = product?.seller.permalink {
//            sellerTextView.text = "Vendedor: \(seller)"
//        }
//        
//        if let publication = product?.permalink {
//            publicationTextView.text = "Publicación: \(publication)"
//        }
        
        if let imageLink = product?.thumbnail {
            
            //Use https to secure connection
            let imageURL = imageLink.replacingOccurrences(of: "http:", with: "https:")
            let finalImageURL = URL(string: imageURL)
            
            self.imageView.downloadImage(from: finalImageURL!)
        }
        
        updateTextView(publication: publicationTextView.text, seller: sellerTextView.text)
    }
    
    //Add hyperlink -> redirect to publication
    func updateTextView(publication: String, seller: String) {
        
//        if let url = product?.permalink {
//
//            let productURL = URL(string: url)!
//            let attributedString = NSMutableAttributedString(string: text)
//
//            attributedString.setAttributes([.link: productURL], range: NSMakeRange(13, (text as NSString).length - 13))
//
//            self.publicationTextView.attributedText = attributedString
//            self.publicationTextView.isUserInteractionEnabled = true
//            self.publicationTextView.isEditable = false
//        }
        
        if let safeSeller = product?.seller.permalink, let safePublication = product?.permalink {
            
            let publicationAttributedString = NSMutableAttributedString(string: publication)
            let sellerAttributedString = NSMutableAttributedString(string: seller)
            
            publicationAttributedString.setAttributes([.link: safePublication], range: NSMakeRange(0, (publication as NSString).length))
            sellerAttributedString.setAttributes([.link: safeSeller], range: NSMakeRange(0, (seller as NSString).length))
            
            self.publicationTextView.attributedText = publicationAttributedString
            self.publicationTextView.isUserInteractionEnabled = true
            self.publicationTextView.isEditable = false
            
            self.sellerTextView.attributedText = sellerAttributedString
            self.sellerTextView.isUserInteractionEnabled = true
            self.sellerTextView.isEditable = false
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
