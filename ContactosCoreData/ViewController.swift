//
//  ViewController.swift
//  ContactosCoreData
//
//  Created by Ramiro y Jennifer on 14/05/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tablaContactos: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaContactos.delegate = self
        tablaContactos.dataSource = self
        
        tablaContactos.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "celda")
    }


}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaContactos.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! ContactoTableViewCell
        celda.nombreLabel.text = "Luna Hernandez"
        celda.telefonoLabel.text = "4521456709"
        return celda
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

