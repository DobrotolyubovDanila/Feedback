//
//  NewFeedback.swift
//  Feedback
//
//  Created by Данила on 07.06.2020.
//  Copyright © 2020 Данила. All rights reserved.
//

import UIKit
import CoreData

class NewFeedback: UITableViewController {
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var middleNameField: UITextField!
    @IBOutlet weak var regionField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var currentFeedback: Feedback?
    
    let regionNames = ["Краснодарский край", "Ростовская область", "Ставропольский край"]
    var cityNames: [String:[String]] = ["Краснодарский край":["Краснодар", "Кропоткин", "Славянск"],
                                        "Ростовская область":["Шахты", "Батайск", "Ростов-на-дону"],
                                        "Ставропольский край":["Ставрополь", "Пятигорск", "Кисловодск"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .interactive
        tableView.allowsSelection = false
        
        saveButton.isEnabled = false
        nameField.addTarget(self, action: #selector(mainFieldsChanged), for: .editingChanged)
        surnameField.addTarget(self, action: #selector(mainFieldsChanged), for: .editingChanged)
        
        regionField.addTarget(self, action: #selector(regionWasSet), for: .allEvents)
        cityField.isEnabled = false
        
        commentTextView.delegate = self
        
        setupEditScreen()
        
        createToolbar()
        createElementPicker()
    }
    // Проверка основных полей на пустоту
    private func isMainFieldsEmpty() -> Bool {
        if nameField.text?.isEmpty == true || surnameField.text?.isEmpty == true || commentTextView.text.isEmpty == true {
            return true
        } else {
            return false
        }
    }
    // Кнопка "Отмена"
    @IBAction func cancelAction(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    // Вспомогательные функции для наблюдателей
    @objc private func mainFieldsChanged(){
        if isMainFieldsEmpty() == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @objc private func regionWasSet() {
        if regionField.text?.isEmpty == true {
            cityField.isEnabled = false
        } else {
            cityField.isEnabled = true
        }
    }
    // Сохранение данных
    func saveFeedback() {
        if currentFeedback == nil {
            guard let entity = NSEntityDescription.entity(forEntityName: "Feedback", in: context!) else { return }
            
            let fbObject = Feedback(entity: entity, insertInto: context)
            
            fbObject.name = nameField.text
            fbObject.surname = surnameField.text
            fbObject.comment = commentTextView.text
            fbObject.city = cityField.text
            fbObject.email = emailField.text
            fbObject.region = regionField.text
            fbObject.phoneNumber = phoneNumberField.text
            fbObject.middleName = middleNameField.text
            
            do {
                try context!.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            currentFeedback?.city = cityField.text
            currentFeedback?.name = nameField.text
            currentFeedback?.comment = commentTextView.text
            currentFeedback?.surname = surnameField.text
            currentFeedback?.region = regionField.text
            currentFeedback?.email = currentFeedback?.email
            currentFeedback?.middleName = middleNameField.text
            currentFeedback?.phoneNumber = phoneNumberField.text
            
            do {
                try context!.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    // Заполняем текстовые поля при переходе с существующего ряда.
    func setupEditScreen(){
        if currentFeedback != nil {
            setupNavigationBar()
            
            nameField.text = currentFeedback?.name
            surnameField.text = currentFeedback?.surname
            middleNameField.text = currentFeedback?.middleName
            regionField.text = currentFeedback?.region
            cityField.text = currentFeedback?.city
            phoneNumberField.text = currentFeedback?.phoneNumber
            emailField.text = currentFeedback?.email
            commentTextView.text = currentFeedback?.comment
        }
    }
    // Делаем кнопку "Назад" вместо "Отмена"
    private func setupNavigationBar(){
        if let topItem = navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil )
        }
        navigationItem.leftBarButtonItem = nil
        title = currentFeedback?.surname
        saveButton.isEnabled = true
    }
    
}

// MARK: UITextViewDelegate
extension NewFeedback: UITextViewDelegate {
    // Проверка на пустоту
    func textViewDidChange(_ textView: UITextView) {
        if !isMainFieldsEmpty() {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
}


extension NewFeedback: UIPickerViewDelegate, UIPickerViewDataSource {
    // Работа с PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if regionField.isEditing {
            return regionNames.count + 1
        }
        
        if cityField.isEditing {
            guard let region = regionField.text else { return 0 }
            guard let cities = cityNames[region] else { return 0 }
            return cities.count + 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0 { return "– – –" }
        if regionField.isEditing {
            
            return regionNames[row-1]
        }
        
        if cityField.isEditing {
            guard let region = regionField.text else { return nil }
            guard let cities = cityNames[region] else { return nil }
            
            return cities[row-1]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if regionField.isEditing {
            if row == 0 {
                regionField.text = ""
                cityField.text = ""
                return
            }
            regionField.text = regionNames[row-1]
            guard let cityInField = cityField.text else { return }
            guard let citiesByCurrentRegion = cityNames[regionNames[row-1]] else { return }
            if !citiesByCurrentRegion.contains(cityInField) { cityField.text = nil }
        }
        
        if cityField.isEditing {
            if row == 0 {
                cityField.text = ""
                return
            }
            guard let region = regionField.text else { return }
            guard let cities = cityNames[region] else { return }
            cityField.text = cities[row-1]
        }
    }
    // Делаем кнопку "готово" над pickerView
    private func createToolbar() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово",
                                         style: .plain,
                                         target: self,
                                         action: #selector(dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        regionField.inputAccessoryView = toolbar
        cityField.inputAccessoryView = toolbar
        // Castomization
        toolbar.tintColor = .systemBlue
        toolbar.barTintColor = .white
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    // Для ввода Региона и Города
    func createElementPicker() {
        let pickerViewRegion = UIPickerView()
        let pickerViewCity = UIPickerView()
        pickerViewRegion.delegate = self
        pickerViewCity.delegate = self
        regionField.inputView = pickerViewRegion
        cityField.inputView = pickerViewCity
    }
    
}
