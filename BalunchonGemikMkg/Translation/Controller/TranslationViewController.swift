//
//  TranslationViewController.swift
//  BalunchonGemikMkg
//
//  Created by Mikungu Giresse on 10/01/23.
//

import UIKit

class TranslationViewController: UIViewController {
    
    

    @IBOutlet weak var textArea: UITextView!
    
    @IBOutlet weak var textTraductedArea: UILabel!
    
    @IBOutlet weak var traductionButton: UIButton!
    
    let translate = TranslationService (session: URLSession(configuration: .default))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
 
    @IBAction func dismissKeyBoardTranslate(_ sender: UITapGestureRecognizer) {
        textArea.resignFirstResponder()
    }
    
   
    @IBAction func translateTapped(_ sender: Any) {
        traductionButton.isHidden = true
        
        let encodedString = textArea.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "<>!*();^:@&=+$,|/?%#[]{}~’\" ").inverted)
        
        // ask to api google translate to return the text translated
        translate.getTranslate(request: translate.createTranslateRequest(sentence: encodedString!)) { succes, translate in
            guard succes, let translate = translate else {
                self.presentAlert(with: "Oups! Echec de requête")
                self.traductionButton.isHidden = false
                return
            }
            self.textTraductedArea.text = translate.returnTextTranslated()
            self.traductionButton.isHidden = false
        }
        
    }
    
}

extension TranslationViewController {
    // create an alert, the parameter "with error" is the error message
    private func presentAlert(with error: String){
        let alertVC = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}
