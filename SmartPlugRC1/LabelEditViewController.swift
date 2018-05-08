//
//  LabelEditViewController.swift
//  SmartPlugRC1
//
//  Created by Lander Saavedra on 11/03/18.
//  Copyright © 2018 com.RudyLLantoy. All rights reserved.
//

import UIKit

class LabelEditViewController: UIViewController, UITextFieldDelegate {
    
    //@IBOutlet weak var labelTextField: UITextField!
   // @IBOutlet weak var LabelTextField: UILabel!
    
    @IBOutlet weak var LabelTextField: UITextField!
    //@IBOutlet weak var LabelTextField: UILabel!
    var label: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LabelTextField.becomeFirstResponder()
        //Realice cualquier configuración adicional después de cargar la vista.
        self.LabelTextField.delegate = self
        
        LabelTextField.text = label
        
        //definido en el protocolo UITextInputTraits
        LabelTextField.returnKeyType = UIReturnKeyType.done
        LabelTextField.enablesReturnKeyAutomatically = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Elimine cualquier recurso que pueda ser recreado.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        label = textField.text!
        performSegue(withIdentifier: Id.labelUnwindIdentifier, sender: self)
        //Este método se puede usar cuando no se necesita aprobación de estado
        //navigationController?.popViewController(animated: true)
        return false
    }
    
}

