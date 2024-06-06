//
//  ShareProductViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/05/24.
//

import UIKit
import FirebaseDynamicLinks

class ShareProductViewController: UIViewController {

    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    
    var product: ProductModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productImage.layer.cornerRadius = productImage.layer.bounds.width / 2
     
        loadProduct()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
    }
    
    func loadProduct() {
        
        if let product = product {
            self.productName.text = product.name
            self.productImage.sd_setImage(with: URL(string: product.productImage), placeholderImage: UIImage(systemName: "bag"))
            self.productDesc.text = product.desc
        }
        
    }
    
    @objc func shareButtonTapped() {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.example.com"
        components.path = "/product"
        
        guard let prd = product else { return }
        let productIDQueryItem = URLQueryItem(name: "pid", value: prd.pid)
        components.queryItems = [productIDQueryItem]
        
        guard let linkParameter = components.url else { return }
        
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://medlegaldemo.page.link") else { return }
        
        if let myBundleID = Bundle.main.bundleIdentifier {
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleID)
        }
        
        shareLink.iOSParameters?.appStoreID = "962194608"
        
        shareLink.androidParameters = DynamicLinkAndroidParameters(packageName: "com.example.medlegalconnect.com")
        
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "\(prd.name) from the Demo Application"
        shareLink.socialMetaTagParameters?.descriptionText = "\(prd.desc)"
        shareLink.socialMetaTagParameters?.imageURL = URL(string: prd.productImage)
        
        guard let longURL = shareLink.url else { return }
        
        shareLink.shorten { url, warnings, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            if let warnings = warnings {
                for warning in warnings {
                    print(warning)
                }
            }
            
            guard let url = url else {
                return
            }

            print("Long URL : \(longURL)")
            print("Short URL : \(url)")
            
            self.shareLink(with: url)
        }
    }
    
    func shareLink(with url: URL) {
        
        let str = "Chaeckout \(product!.name)"
        let avc = UIActivityViewController(activityItems: [str, url], applicationActivities: nil)
        present(avc, animated: true, completion: nil)
        
    }

}
