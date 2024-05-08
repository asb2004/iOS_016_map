//
//  LanguageViewController.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 15/04/24.
//

import UIKit

var language: String = "en"

class LanguageViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var languageText: UITextField!
    
    var languagePicker: UIPickerView!
    var languages = ["English", "Hindi", "Spenish", "Japanese", "Gujarati", "French"]
    var languagesTag = ["en", "hi", "es", "ja", "gu", "fr"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languagePicker = UIPickerView()

        languageText.inputView = languagePicker
        languagePicker.delegate = self
        languagePicker.dataSource = self
        
        languageText.text = languages[languagesTag.firstIndex(of: language)!]
        textLabel.text = "As the name suggests, the picker view allows the user to pick an item from the set of multiple items. PickerView can display one or multiple sets where each set is known as a component. Each component displays a series of indexed rows representing the selectable items. The user can select the items by rotating the wheels.".localized(lang: language)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Setting", style: .plain, target: self, action: #selector(openSettings))
    }
    
    @objc func openSettings() {
        print(Locale.current.languageCode!)
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
        UIApplication.shared.open(settingsURL, options: [:])
    }

}

extension LanguageViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.languageText.text = languages[row]
        self.languageText.resignFirstResponder()
        language = languagesTag[row]
        UserDefaults.standard.set(language, forKey: "myLanguage")
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        
        self.viewDidLoad()
    }
}

extension String {
    func localized(lang: String) -> String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: "Localizable", bundle: bundle!, value: self, comment: self)
    }
}
