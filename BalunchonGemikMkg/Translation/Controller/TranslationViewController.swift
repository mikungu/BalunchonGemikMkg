//
//  TranslationViewController.swift
//  BalunchonGemikMkg
//
//  Created by Mikungu Giresse on 10/01/23.
//

import UIKit

class TranslationViewController: UIViewController {
    
    
    //MARK: -Properties
    @IBOutlet weak var textArea: UITextView!
    
    @IBOutlet weak var textTraductedArea: UILabel!
    
    @IBOutlet weak var traductionButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let translate = TranslationModel ()
    
    //MARK: -Ovveride
    override func viewDidLoad() {
        //super.viewDidLoad()
        activityIndicator.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    //MARK: -Actions
    @IBAction func dismissKeyBoardTranslate(_ sender: UITapGestureRecognizer) {
        textArea.resignFirstResponder()
    }
    
    
    @IBAction func translateTapped(_ sender: Any) {
        traductionButton.isHidden = true
        
        let encodedString = textArea.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "<>!*();^:@&=+$,|/?%#[]{}~’\" ").inverted)
        
        // ask to api google translate to return the text translated
        translate.getTranslation(sentence: encodedString!) { (success, translate) in
            guard let translate = translate, success == true else {
                self.presentAlert(with: "Oups! Echec de requête")
                self.traductionButton.isHidden = false
                self.activityIndicator.isHidden = true
                return
            }
            self.textTraductedArea.text = translate.returnTextTranslated()
            self.activityIndicator.isHidden = true
            self.traductionButton.isHidden = false
        }
        
    }
    
}

//MARK: -Extension
extension TranslationViewController {
    // create an alert, the parameter "with error" is the error message
    private func presentAlert(with error: String){
        let alertVC = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}
