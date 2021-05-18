//
//  EditarViewController.swift
//  ContactosCoreData
//
//  Created by Ramiro y Jennifer on 17/05/21.
//

import UIKit

class EditarViewController: UIViewController {

    var recibirNombre: String?
    
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombreTextField.text = recibirNombre
    }
    

}
