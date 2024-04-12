//
//  ActionSheetViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 05/04/24.
//

import UIKit
import WebKit

class ActionSheetViewController: UIViewController {

    @IBOutlet weak var viewForWeb: UIView!
    
    var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.frame = viewForWeb.bounds
        viewForWeb.addSubview(webView)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(showActionSheet))
    }
    
    @objc func showActionSheet() {
        
        let avc = UIAlertController(title: "Open Website", message: nil, preferredStyle: .actionSheet)
        
        avc.addAction(UIAlertAction(title: "www.google.com", style: .default, handler: openWebPage))
        avc.addAction(UIAlertAction(title: "www.apple.com", style: .default, handler: openWebPage))
        
        avc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(avc, animated: true, completion: nil)
    }
    
    @objc func openWebPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }

}
