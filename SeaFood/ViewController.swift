//
//  ViewController.swift
//  SeaFood
//
//  Created by Akash Pawar on 7/18/19.
//  Copyright © 2019 Akash Pawar. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = userPickedimage
            
            guard let ciimage = CIImage(image: userPickedimage) else{fatalError("Could not convert UIImage into CIImage")
                
            }
            detect(image: ciimage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil )
    }
    
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{ fatalError("Loading CoreML Model Failed")}
    
    
    let request = VNCoreMLRequest(model: model) { (request, error) in
        guard let result = request.results as? [VNClassificationObservation] else{
            fatalError("May be model failed to process image")
        }
        
        if let firstResult = result.first{
            if firstResult.identifier.contains("hotdog"){
                self.navigationItem.title = "Hotdog!"
            }
            else{
                self.navigationItem.title = "Not HotDog"
            }
        }
    }
    
    let handler = VNImageRequestHandler(ciImage: image)
        do{
        try! handler.perform([request])
        }
        catch{
            print(error)
        }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = .init(true)
        // Do any additional setup after loading the view.
    }

    

}

