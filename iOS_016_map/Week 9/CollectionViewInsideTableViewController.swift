//
//  CollectionViewInsideTableViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 23/04/24.
//

import UIKit
import Stripe

struct ColorCategory {
    var title: String
    var index: IndexPath
    var position: CGPoint
    var colorData: [ColorData]
}

struct ColorData {
    var name: String
    var color: UIColor
}

class CollectionViewInsideTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var colorCategories = [ColorCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorCategories = [
            ColorCategory(title: "Row 1", index: IndexPath(item: 0, section: 0), position: CGPoint(x: 1000.0, y: 0.0), colorData: [
                ColorData(name: "Item 1", color: .darkGray),
                ColorData(name: "Item 2", color: .darkGray),
                ColorData(name: "Item 3", color: .darkGray),
                ColorData(name: "Item 4", color: .darkGray),
                ColorData(name: "Item 5", color: .darkGray),
                ColorData(name: "Item 6", color: .darkGray),
                ColorData(name: "Item 7", color: .darkGray),
                ColorData(name: "Item 8", color: .darkGray),
                ColorData(name: "Item 9", color: .darkGray),
                ColorData(name: "Item 10", color: .darkGray)
            ]),
            ColorCategory(title: "Row 2", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .systemGray4),
                ColorData(name: "Item 2", color: .systemGray4),
                ColorData(name: "Item 3", color: .systemGray4),
                ColorData(name: "Item 4", color: .systemGray4),
                ColorData(name: "Item 5", color: .systemGray4),
                ColorData(name: "Item 6", color: .systemGray4),
                ColorData(name: "Item 7", color: .systemGray4),
                ColorData(name: "Item 8", color: .systemGray4),
                ColorData(name: "Item 9", color: .systemGray4),
                ColorData(name: "Item 10", color: .systemGray4)
            ]),
            ColorCategory(title: "Row 3", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .systemGray2),
                ColorData(name: "Item 2", color: .systemGray2),
                ColorData(name: "Item 3", color: .systemGray2),
                ColorData(name: "Item 4", color: .systemGray2),
                ColorData(name: "Item 5", color: .systemGray2),
                ColorData(name: "Item 6", color: .systemGray2),
                ColorData(name: "Item 7", color: .systemGray2),
                ColorData(name: "Item 8", color: .systemGray2),
                ColorData(name: "Item 9", color: .systemGray2),
                ColorData(name: "Item 10", color: .systemGray2)
            ]),
            ColorCategory(title: "Row 4", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .systemGray5),
                ColorData(name: "Item 2", color: .systemGray5),
                ColorData(name: "Item 3", color: .systemGray5),
                ColorData(name: "Item 4", color: .systemGray5),
                ColorData(name: "Item 5", color: .systemGray5),
                ColorData(name: "Item 6", color: .systemGray5),
                ColorData(name: "Item 7", color: .systemGray5),
                ColorData(name: "Item 8", color: .systemGray5),
                ColorData(name: "Item 9", color: .systemGray5),
                ColorData(name: "Item 10", color: .systemGray5)
            ]),
            ColorCategory(title: "Row 5", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .systemGray3),
                ColorData(name: "Item 2", color: .systemGray3),
                ColorData(name: "Item 3", color: .systemGray3),
                ColorData(name: "Item 4", color: .systemGray3),
                ColorData(name: "Item 5", color: .systemGray3),
                ColorData(name: "Item 6", color: .systemGray3),
                ColorData(name: "Item 7", color: .systemGray3),
                ColorData(name: "Item 8", color: .systemGray3),
                ColorData(name: "Item 9", color: .systemGray3),
                ColorData(name: "Item 10", color: .systemGray3)
            ]),
            ColorCategory(title: "Row 6", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .green),
                ColorData(name: "Item 2", color: .green),
                ColorData(name: "Item 3", color: .green),
                ColorData(name: "Item 4", color: .green),
                ColorData(name: "Item 5", color: .green),
                ColorData(name: "Item 6", color: .green),
                ColorData(name: "Item 7", color: .green),
                ColorData(name: "Item 8", color: .green),
                ColorData(name: "Item 9", color: .green),
                ColorData(name: "Item 10", color: .green)
            ]),
            ColorCategory(title: "Row 7", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .magenta),
                ColorData(name: "Item 2", color: .magenta),
                ColorData(name: "Item 3", color: .magenta),
                ColorData(name: "Item 4", color: .magenta),
                ColorData(name: "Item 5", color: .magenta),
                ColorData(name: "Item 6", color: .magenta),
                ColorData(name: "Item 7", color: .magenta),
                ColorData(name: "Item 8", color: .magenta),
                ColorData(name: "Item 9", color: .magenta),
                ColorData(name: "Item 10", color: .magenta)
            ]),
            ColorCategory(title: "Row 8", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .gray),
                ColorData(name: "Item 2", color: .gray),
                ColorData(name: "Item 3", color: .gray),
                ColorData(name: "Item 4", color: .gray),
                ColorData(name: "Item 5", color: .gray),
                ColorData(name: "Item 6", color: .gray),
                ColorData(name: "Item 7", color: .gray),
                ColorData(name: "Item 8", color: .gray),
                ColorData(name: "Item 9", color: .gray),
                ColorData(name: "Item 10", color: .gray)
            ]),
            ColorCategory(title: "Row 9", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .red),
                ColorData(name: "Item 2", color: .red),
                ColorData(name: "Item 3", color: .red),
                ColorData(name: "Item 4", color: .red),
                ColorData(name: "Item 5", color: .red),
                ColorData(name: "Item 6", color: .red),
                ColorData(name: "Item 7", color: .red),
                ColorData(name: "Item 8", color: .red),
                ColorData(name: "Item 9", color: .red),
                ColorData(name: "Item 10", color: .red)
            ]),
            ColorCategory(title: "Row 10", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .purple),
                ColorData(name: "Item 2", color: .purple),
                ColorData(name: "Item 3", color: .purple),
                ColorData(name: "Item 4", color: .purple),
                ColorData(name: "Item 5", color: .purple),
                ColorData(name: "Item 6", color: .purple),
                ColorData(name: "Item 7", color: .purple),
                ColorData(name: "Item 8", color: .purple),
                ColorData(name: "Item 9", color: .purple),
                ColorData(name: "Item 10", color: .purple)
            ]),
            ColorCategory(title: "Row 11", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .orange),
                ColorData(name: "Item 2", color: .orange),
                ColorData(name: "Item 3", color: .orange),
                ColorData(name: "Item 4", color: .orange),
                ColorData(name: "Item 5", color: .orange),
                ColorData(name: "Item 6", color: .orange),
                ColorData(name: "Item 7", color: .orange),
                ColorData(name: "Item 8", color: .orange),
                ColorData(name: "Item 9", color: .orange),
                ColorData(name: "Item 10", color: .orange)
            ]),
            ColorCategory(title: "Row 12", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .blue),
                ColorData(name: "Item 2", color: .blue),
                ColorData(name: "Item 3", color: .blue),
                ColorData(name: "Item 4", color: .blue),
                ColorData(name: "Item 5", color: .blue),
                ColorData(name: "Item 6", color: .blue),
                ColorData(name: "Item 7", color: .blue),
                ColorData(name: "Item 8", color: .blue),
                ColorData(name: "Item 9", color: .blue),
                ColorData(name: "Item 10", color: .blue)
            ]),
            ColorCategory(title: "Row 13", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .brown),
                ColorData(name: "Item 2", color: .brown),
                ColorData(name: "Item 3", color: .brown),
                ColorData(name: "Item 4", color: .brown),
                ColorData(name: "Item 5", color: .brown),
                ColorData(name: "Item 6", color: .brown),
                ColorData(name: "Item 7", color: .brown),
                ColorData(name: "Item 8", color: .brown),
                ColorData(name: "Item 9", color: .brown),
                ColorData(name: "Item 10", color: .brown)
            ]),
            ColorCategory(title: "Row 14", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .systemTeal),
                ColorData(name: "Item 2", color: .systemTeal),
                ColorData(name: "Item 3", color: .systemTeal),
                ColorData(name: "Item 4", color: .systemTeal),
                ColorData(name: "Item 5", color: .systemTeal),
                ColorData(name: "Item 6", color: .systemTeal),
                ColorData(name: "Item 7", color: .systemTeal),
                ColorData(name: "Item 8", color: .systemTeal),
                ColorData(name: "Item 9", color: .systemTeal),
                ColorData(name: "Item 10", color: .systemTeal)
            ]),
            ColorCategory(title: "Row 16", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .black),
                ColorData(name: "Item 2", color: .black),
                ColorData(name: "Item 3", color: .black),
                ColorData(name: "Item 4", color: .black),
                ColorData(name: "Item 5", color: .black),
                ColorData(name: "Item 6", color: .black),
                ColorData(name: "Item 7", color: .black),
                ColorData(name: "Item 8", color: .black),
                ColorData(name: "Item 9", color: .black),
                ColorData(name: "Item 10", color: .black)
            ]),
            ColorCategory(title: "Row 17", index: IndexPath(item: 0, section: 0), position: .zero, colorData: [
                ColorData(name: "Item 1", color: .systemYellow),
                ColorData(name: "Item 2", color: .systemYellow),
                ColorData(name: "Item 3", color: .systemYellow),
                ColorData(name: "Item 4", color: .systemYellow),
                ColorData(name: "Item 5", color: .systemYellow),
                ColorData(name: "Item 6", color: .systemYellow),
                ColorData(name: "Item 7", color: .systemYellow),
                ColorData(name: "Item 8", color: .systemYellow),
                ColorData(name: "Item 9", color: .systemYellow),
                ColorData(name: "Item 10", color: .systemYellow)
            ])
        ]
    }

}

extension CollectionViewInsideTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionViewCell") as! TableViewCellForCollectionVIew
        cell.rowTitle.text = colorCategories[indexPath.row].title
        cell.savedContentOffset = colorCategories[indexPath.row].position
        cell.colorData = colorCategories[indexPath.row].colorData
        
        cell.setPosition = { (position) in
            self.colorCategories[indexPath.row].position = position
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
