//
//  ShareProductListViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/05/24.
//

import UIKit

struct ProductModel {
    var pid: String
    var name: String
    var productImage: String
    var desc: String
}

class ShareProductListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var productList = [
        ProductModel(pid: "p1",
                     name: "Watch",
                     productImage: "https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fHByb2R1Y3R8ZW58MHx8MHx8fDA%3D",
                     desc: "This is an Sample Product"),
        ProductModel(pid: "p2",
                     name: "Car",
                     productImage: "https://images.unsplash.com/photo-1581235720704-06d3acfcb36f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHByb2R1Y3R8ZW58MHx8MHx8fDA%3D",
                     desc: "This is an Sample Product"),
        ProductModel(pid: "p3",
                     name: "Headphones",
                     productImage: "https://images.unsplash.com/photo-1583394838336-acd977736f90?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fHByb2R1Y3R8ZW58MHx8MHx8fDA%3D",
                     desc: "This is an Sample Product"),
        ProductModel(pid: "p4",
                     name: "Water Bottel",
                     productImage: "https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fHByb2R1Y3R8ZW58MHx8MHx8fDA%3D",
                     desc: "This is an Sample Product"),
        ProductModel(pid: "p5",
                     name: "Shoes",
                     productImage: "https://images.unsplash.com/photo-1560343090-f0409e92791a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D",
                     desc: "This is an Sample Product"),
        ProductModel(pid: "p6",
                     name: "Sunglasses",
                     productImage: "https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D",
                     desc: "This is an Sample Product"),
        
    ]
    
    var initialPid: String?
    
    var pid: String! {
        didSet {
            if let product = productList.first(where: { $0.pid == pid }) {
                let vc = week11Storyboard.instantiateViewController(withIdentifier: "ShareProductViewController") as! ShareProductViewController
                vc.product = product
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let initialPid = initialPid {
            self.pid = initialPid
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Products"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }

}

extension ShareProductListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareProductCell") as! ShareProductCell
        cell.productName.text = productList[indexPath.row].name
        cell.productImage.sd_setImage(with: URL(string: productList[indexPath.row].productImage), placeholderImage: UIImage(systemName: "bag"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pid = productList[indexPath.row].pid
    }
    
}
