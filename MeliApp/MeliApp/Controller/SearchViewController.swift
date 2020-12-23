//
//  ViewController.swift
//  MeliApp
//
//  Created by Lean Caro on 21/12/2020.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var productManager = ProductManager()
    var products: ProductData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .black
        searchButton.isEnabled = false
        
        //Delegates
        searchTextField.delegate = self
        productManager.delegate = self
        
        //Use light mode
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .light
        }
        
        //Move keyboard up when its opened
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Dismiss keyboard when tap anywhere on the screen
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
   
        //Add done button to keyboard toolbar
        setupKeyboardButton()
    }
    
    //MARK: - Keyboard Methods

    func setupKeyboardButton() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        searchTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

//MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        //Dismiss keyboard when search button is pressed
        searchTextField.endEditing(true)
        
        if let product = searchTextField.text {
            
            let trimmedProduct = product.trimmingCharacters(in: .whitespacesAndNewlines) //Remove leading and trailing whitespaces
            let finalProduct = trimmedProduct.replacingOccurrences(of: " ", with: "%20") //Replace whitespaces between words
            
            if finalProduct.isEmpty {
                searchTextField.placeholder = "Ingrese producto..."
            } else {
                productManager.fetchProducts(productName: finalProduct)
            }
        }
    }
    
    //Execute when the keyboard's return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Dismiss keyboard
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchButton.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if searchTextField.text == "" {
            searchButton.isEnabled = false
        }
    }
}

//MARK: - ProductManagerDelegate

extension SearchViewController: ProductManagerDelegate {
    
    func didUpdateProducts(_ productManager: ProductManager, products: ProductData) {

        print("PRODUCTS: \(products)")

        self.products = products

        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToProducts", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Pass fetched products to next view controller (ProductsViewController)
        if let destinationVC = segue.destination as? ProductsViewController
        {
            destinationVC.products = self.products
        }
    }
    
    func didFailWithError(error: Error) {
        
        print(error)
        
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: "¡Oops! Error de conexión", message: "Revisa tu conexión para seguir buscando productos.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
