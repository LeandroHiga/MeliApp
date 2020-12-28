//
//  ProductDetailViewController.swift
//  MeliApp
//
//  Created by Lean Caro on 22/12/2020.
//

import UIKit

class ProductDetailViewController: UIViewController {

    
//    @IBOutlet weak var descriptionTextView: UITextView!
//    @IBOutlet weak var priceTextView: UITextView!
//    @IBOutlet weak var currencyTextView: UITextView!
//    @IBOutlet weak var conditionTextView: UITextView!
//    @IBOutlet weak var availableQuantityTextView: UITextView!
//    @IBOutlet weak var stateTextView: UITextView!
//    @IBOutlet weak var cityTextView: UITextView!


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var availableQuantityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
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
            descriptionLabel.text = "\(title)"
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
        
        if let quantity = product?.available_quantity {
            availableQuantityLabel.text = "Cantidad disponible: \(quantity)"
        }
        
        if let state = product?.address?.state_name {
            stateLabel.text = "Provincia: \(state)"
        }
        
        if let city = product?.address?.city_name {
            cityLabel.text = "Ciudad: \(city)"
        }

        publicationTextView.sizeToFit()
        sellerTextView.sizeToFit()
        
        if let imageLink = product?.thumbnail {
            
            //Use https to secure connection
            let imageURL = imageLink.replacingOccurrences(of: "http:", with: "https:")
            let finalImageURL = URL(string: imageURL)
            
            self.imageView.downloadImage(from: finalImageURL!)
        }
        
        updateTextView(publication: publicationTextView.text, seller: sellerTextView.text)
        publicationTextView.textAlignment = .center
        sellerTextView.textAlignment = .center
    }
    
    //Add hyperlink -> redirect to publication
    func updateTextView(publication: String, seller: String) {
        
        if let safeSeller = product?.seller?.permalink, let safePublication = product?.permalink {
            
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
