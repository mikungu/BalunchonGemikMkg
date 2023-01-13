//
//  DollarViewController.swift
//  BalunchonGemikMkg
//
//  Created by Mikungu Giresse on 10/01/23.
//

import UIKit

final class DollarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    //we have the property of the textField where the user can write the amount
    @IBOutlet weak var amountLocalDevise: UITextField!
    //we have the property of the pickerView where the user can select the name of his local device
    @IBOutlet weak var localDeviceName: UIPickerView!
    //we have the button with which the use has to click on to get the result
    @IBOutlet weak var validerButton: UIButton!
    //we have an area where the result has to appear
    @IBOutlet weak var responseArea: UILabel!
    
    //we have an instance of DollarService
    private let dollar = DollarService(session: URLSession(configuration: .default))
    
    //the pickerView has only one column (component)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //the pickerView's elements is a rates.count
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rates.count
    }
    //response of the element selected
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rates[row]
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()

           // "EUR" defined as localDeviceName by default in the pickerView
           localDeviceName.selectRow(46, inComponent: 0, animated: true)
       }
    
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
    //we retrieve the data in the form
    private func createPetObject () {
        let amountLocal = self .amountLocalDevise.text
        let localDeviceIndex = self .localDeviceName.selectedRow(inComponent: 0)
        let device = rates [localDeviceIndex]
    
    }
    
    @IBAction func validate(_ sender: Any) {
        
        
        validateButton.isHidden = true
  
        dollar.getDollar() { succes, dollar in
      
            guard succes, let dollar = dollar else {
                self.presentAlert(with: "la requête à échoué")
                return
            }
            
            let localDevise = self.LocalDeviseTextField.text
            let moneyIndex = self.ratePickerView.selectedRow(inComponent: 0)
            let money = rates[moneyIndex]
            
            // here we try to convert the money in a Double
            // if the user enter an invalide number, present an alert to the user
            guard let result = Double(localDevise!) else {
                self.presentAlert(with: "Veuillez entrer un nombre valide")
                self.activityLoading.isHidden = true
                self.validateButton.isHidden = false
                return
            }
            
            let convertion = dollar.convertionIntoDollar(number : result, local : money, dict : dollar.rates as NSDictionary)
            
            self.responseLabel.text = "\(result) \(money) vaut actuellement \(Double(round(100*(convertion))/100))$ !"

            self.activityLoading.isHidden = true
            self.validateButton.isHidden = false
        }
        createPetObject()
        }
    }
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
