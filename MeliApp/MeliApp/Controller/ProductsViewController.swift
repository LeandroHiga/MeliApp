//
//  ProductsViewController.swift
//  MeliApp
//
//  Created by Lean Caro on 21/12/2020.
//

import UIKit

class ProductsViewController: UITableViewController {

    var products: ProductData?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Volver"

        //Use light mode
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .light
        }
    }

    // MARK: - Table View Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            if products?.results.count == 0 {
                return 1
            } else {
                return (products?.results.count)!
            }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        
        if products?.results.count == 0 {
            cell.textLabel?.text = "No se encontraron resultados"
            cell.accessoryType = .none
        } else {
            
            if let result = products?.results[indexPath.row] {
                cell.textLabel?.text = result.title
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if products?.results.count != 0 {
            performSegue(withIdentifier: "goToProductDetail", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Pass data of the selected product (row) to next view controller (ProductDetailViewController)
        if let destinationVC = segue.destination as? ProductDetailViewController
        {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.product = self.products?.results[indexPath.row]
                
            }
        }
    }
}

