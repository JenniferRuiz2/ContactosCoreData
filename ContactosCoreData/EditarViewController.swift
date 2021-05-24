//
//  EditarViewController.swift
//  ContactosCoreData
//
//  Created by Ramiro y Jennifer on 17/05/21.
//

import UIKit
import CoreData

class EditarViewController: UIViewController {

    var recibirNombre: String?
    var recibirNumero: String?
    var recibirDireccion: String?
    var recibirIndice: Int?
    
    var contactos = [Contacto]()
    
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarCoreData()
        nombreTextField.text = recibirNombre
        telefonoTextField.text = recibirNumero
        direccionTextField.text = recibirDireccion
        
        print("Indice del arreglo \(recibirIndice)")
        //MARK: Agregar gestura a la imagen
        let gestura = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestura.numberOfTapsRequired = 1
        gestura.numberOfTouchesRequired = 1
        //agregar la gestura de la imagen
        imagenPerfil.addGestureRecognizer(gestura)
        imagenPerfil.isUserInteractionEnabled = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func clickImagen(gestura: UITapGestureRecognizer){
        print("Cambiar imagen")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    //leer de Core Data
    func cargarCoreData(){
        let fetchRequest : NSFetchRequest<Contacto> = Contacto.fetchRequest()
        do {
            contactos = try contexto.fetch(fetchRequest)
        } catch {
            print("Error al cargar el core data \(error.localizedDescription)")
        }
    }
    
    @IBAction func tomarFotoBtn(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType = .savedPhotosAlbum
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cancelarBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func guardarBtn(_ sender: UIButton) {
        do {
            contactos[recibirIndice!].setValue(nombreTextField.text, forKey: "nombre")
            contactos[recibirIndice!].setValue(Int64(telefonoTextField.text!), forKey: "telefono")
            contactos[recibirIndice!].setValue(direccionTextField.text, forKey: "direccion")
            contactos[recibirIndice!].setValue(imagenPerfil.image?.pngData(), forKey: "imagen")
            
            try self.contexto.save()
            print("Se actualuzo")
        } catch  {
            print("Error al actualizar \(error.localizedDescription)")
        }
        navigationController?.popViewController(animated: true)
    }
}

//MARK: Protocolo para la gestura y selección de la imagen
extension EditarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //Que vamos a hacer cuando el usuario selecciona una imagen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSeleccionada = info [UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            imagenPerfil.image = imagenSeleccionada
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
