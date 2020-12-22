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
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension

        //Use light mode
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .light
        }
    }

    // MARK: - Table view data source
    
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
            cell.textLabel?.text = products?.results[indexPath.row].title
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
