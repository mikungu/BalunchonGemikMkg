//
//  DollarViewController.swift
//  BalunchonGemikMkg
//
//  Created by Mikungu Giresse on 10/01/23.
//

import UIKit

final class DollarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    //MARK: -Properties
    //we have the property of the textField where the user can write the amount
    @IBOutlet weak var amountLocalDevise: UITextField!
    //we have the property of the pickerView where the user can select the name of his local device
    @IBOutlet weak var localDeviceName: UIPickerView!
    //we have the button with which the use has to click on to get the result
    @IBOutlet weak var validerButton: UIButton!
    //we have an area where the result has to appear
    @IBOutlet weak var responseArea: UILabel!
    
    //we have an instance of Services
    let dollar = DollarModel() 
    //MARK: - Accessible
    //the pickerView has only one column (component)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //the pickerView's elements is a rates.count
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Rates().rate.count
    }
    //response of the element selected
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Rates().rate[row]
    }
    //MARK: -Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // "EUR" defined as localDeviceName by default in the pickerView
        localDeviceName.selectRow(46, inComponent: 0, animated: true)
    }
    //MARK: - Actions
    //we have in the principal view a tapGestureRecogniser
    @IBAction private func dismissKeyBoard(_ sender: UITapGestureRecognizer) {
        //the user has the possibility to hide the keyboard
        amountLocalDevise.resignFirstResponder()
    }
    //the user can hide the keyBoard by pushing on "return" of the keyBoard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func validate(_ sender: Any) {
        
        
        validerButton.isHidden = true
        
        dollar.getDollar { (success, dollar) in
            
                              guard let dollar = dollar, success == true else {
                self.presentAlert(with: "Oups! Echec de requête")
                return
            }
            
            let localDevise = self.amountLocalDevise.text
            let moneyIndex = self.localDeviceName.selectedRow(inComponent: 0)
            let money = Rates().rate[moneyIndex]
            
            // here we try to convert the money in a Double
            // if the user enter an invalide number, present an alert to the user
            guard let result = Double(localDevise!) else {
                self.presentAlert(with: "Veuillez entrer un nombre valide")
                self.validerButton.isHidden = false
                return
            }
            
            let convertion = dollar.changeLocalToDollar(number : result, local : money, dict : dollar.rates as NSDictionary)
            
            self.responseArea.text = "\(result) \(money) vaut actuellement \(Double(round(100*(convertion))/100))$ !"
            
            
            self.validerButton.isHidden = false
        }
    }
}
//MARK: - Extension
//we create an extension of the class DollarViewController...
extension DollarViewController {
    //we present an alert to the user
    private func presentAlert(with error: String) {
        //initialize an instance of this class
        let alertVC = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        //create an action that corresponds to its button
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        //add the action to our alert via the addAction method of UIAlertController
        alertVC.addAction(action)
        //present the alert with the present method of UIViewController
        present(alertVC, animated: true, completion: nil)
    }
    
}
