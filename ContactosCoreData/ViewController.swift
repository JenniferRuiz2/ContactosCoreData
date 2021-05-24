//
//  ViewController.swift
//  ContactosCoreData
//
//  Created by Ramiro y Jennifer on 14/05/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var nombreEnviar: String?
    var telefonoEnviar: String?
    var direccionEnviar: String?
    var indiceEnviar: Int?
    

    var contactos = [Contacto]()
    
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tablaContactos: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablaContactos.delegate = self
        tablaContactos.dataSource = self
        cargarCoreData()
        
        tablaContactos.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "celda")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tablaContactos.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //guardar
    func guardarContacto(){
        do {
            try contexto.save()
            print("Se guardo correctamente")
        } catch let error as NSError {
            print("Error al guardar: \(error.localizedDescription)")
        }
    }
    
    //leer
    func cargarCoreData(){
        let fetchRequest : NSFetchRequest<Contacto> = Contacto.fetchRequest()
        do {
            contactos = try contexto.fetch(fetchRequest)
        } catch  {
            print("Error al cargar datos de core Data: \(error.localizedDescription)")
        }
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
            
            let imagenTmp = UIImageView(image: #imageLiteral(resourceName: "imagen"))
            
            let nuevoContacto = Contacto(context: self.contexto)
            nuevoContacto.nombre = nombreAlert
            nuevoContacto.telefono = telefonoAlert
            nuevoContacto.direccion = direccionAlert
            nuevoContacto.imagen = imagenTmp.image?.pngData()
            
            self.contactos.append(nuevoContacto)
            self.guardarContacto()
            self.tablaContactos.reloadData()
            print(self.contactos)
        }
        alerta.addTextField { (nombreTF) in
            nombreTF.placeholder = "Nombre"
            nombreTF.autocapitalizationType = .words
            nombreTF.textAlignment = .center
        }
        alerta.addTextField { (telefonoTF) in
            telefonoTF.placeholder = "Telefóno"
            telefonoTF.keyboardType = .numberPad
            telefonoTF.textAlignment = .center
        }
        alerta.addTextField { (direccionTF) in
            direccionTF.placeholder = "Dirección"
            direccionTF.autocapitalizationType = .words
            direccionTF.textAlignment = .center
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
        celda.telefonoLabel.text = " ☎️ \(contactos[indexPath.row].telefono ??  0000000000)"
        celda.fotoImageView.image = UIImage(data: contactos[indexPath.row].imagen!)
        return celda
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tablaContactos.deselectRow(at: indexPath, animated: true)
        nombreEnviar = contactos[indexPath.row].nombre
        telefonoEnviar = "\(contactos[indexPath.row].telefono ?? 0000000000)"
        direccionEnviar = contactos[indexPath.row].direccion
        indiceEnviar = indexPath.row
        performSegue(withIdentifier: "editarContacto", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarContacto"{
            let objEditar = segue.destination as! EditarViewController
            objEditar.recibirNombre = nombreEnviar
            objEditar.recibirNumero = telefonoEnviar
            objEditar.recibirDireccion = direccionEnviar
            objEditar.recibirIndice = indiceEnviar
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let borrar = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            print("Borrar")
            //eliminar de CoreData
            self.contexto.delete(self.contactos[indexPath.row])
            //eliminar de la UI
            self.contactos.remove(at: indexPath.row)
            self.guardarContacto()
            self.tablaContactos.reloadData()
        }
        borrar.image = UIImage(named: "borrar.png")
        borrar.backgroundColor = .white
        
        return UISwipeActionsConfiguration(actions: [borrar])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let llamada = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            print("Llamada")
            
        }
        llamada.image = UIImage(named: "telefono.png")
        llamada.backgroundColor = .white
        
        let mensaje = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            print("Mensaje")
        }
        mensaje.image = UIImage(named: "mensaje.png")
        mensaje.backgroundColor = .white
        
        return UISwipeActionsConfiguration(actions: [llamada, mensaje])
    }
    
}
