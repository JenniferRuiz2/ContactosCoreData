//
//  ViewController.swift
//  ContactosCoreData
//
//  Created by Ramiro y Jennifer on 14/05/21.
//

import UIKit

class ViewController: UIViewController {
    
    var nombreEnviar: String?

    var contactos = [MiContacto]()
    
    @IBOutlet weak var tablaContactos: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nuevo = MiContacto(nombre: "Luna", telefono: 4567890123, direccion: "Morelia")
        contactos.append(nuevo)
        tablaContactos.delegate = self
        tablaContactos.dataSource = self
        
        tablaContactos.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "celda")
    }

    @IBAction func agregarContacto(_ sender: UIBarButtonItem) {
        let alerta = UIAlertController(title: "Agregar", message: "Nuevo contacto", preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) { [self] (_) in
            print("Se agrego el contacto")
            
            guard let nombreAlert = alerta.textFields?.first?.text else {
                return
            }
            
            guard let telefonoAlert = Int64(alerta.textFields?[1].text ?? "0000000000") else {
                return
            }
            
            guard let direccionAlert = alerta.textFields?.last?.text else {
                return
            }
            
            let nuevoContacto = MiContacto(nombre: nombreAlert, telefono: telefonoAlert, direccion: direccionAlert)
            
            self.contactos.append(nuevoContacto)
            self.tablaContactos.reloadData()
            print(self.contactos)
        }
        alerta.addTextField { (nombreTF) in
            nombreTF.placeholder = "Nombre"
        }
        alerta.addTextField { (telefonoTF) in
            telefonoTF.placeholder = "Telefóno"
        }
        alerta.addTextField { (direccionTF) in
            direccionTF.placeholder = "Dirección"
        }
        alerta.addAction(accionAceptar)
        let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alerta.addAction(accionCancelar)
        present(alerta, animated: true, completion: nil)
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaContactos.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! ContactoTableViewCell
        celda.nombreLabel.text = contactos[indexPath.row].nombre
        celda.telefonoLabel.text = "☏ \(contactos[indexPath.row].telefono ??  00000000000)"
        return celda
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tablaContactos.deselectRow(at: indexPath, animated: true)
        nombreEnviar = contactos[indexPath.row].nombre
        performSegue(withIdentifier: "editarContacto", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarContacto"{
            let objEditar = segue.destination as! EditarViewController
            objEditar.recibirNombre = nombreEnviar
        }
    }
    
}
