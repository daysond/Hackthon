//
//  ViewController.swift
//  Hackthon
//
//  Created by Dayson Dong on 2022-02-09.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {
    
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    
    private let locationManager = CLLocationManager()
    private let pickerController = UIImagePickerController()
    
    //UI
    private let customButton = CustomButton()
    
    private let locationLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        l.numberOfLines = 1
        l.textColor = .black
        l.textAlignment = .left
        return l
    }()
    
    private let garbageInfoLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        l.numberOfLines = 1
        l.textColor = .black
        l.textAlignment = .left
        return l
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("did call")
        setupLocationManager()
        setupView()
        view.backgroundColor = .white
        
    }
    
    
    private func setupView() {
        
        pickerController.delegate = self
        
        view.addSubview(locationLabel)
        view.addSubview(garbageInfoLabel)
        view.addSubview(customButton)
        
        customButton.addTarget(self, action: #selector(startCamera), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            locationLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            locationLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant:  -16),
            //            locationLabel.heightAnchor.constraint(equalToConstant: 48),
            
            garbageInfoLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
            garbageInfoLabel.leftAnchor.constraint(equalTo: locationLabel.leftAnchor),
            garbageInfoLabel.widthAnchor.constraint(equalTo: locationLabel.widthAnchor),
            //            garbageInfoLabel.heightAnchor.constraint(equalToConstant: 32),
            
            customButton.topAnchor.constraint(equalTo: garbageInfoLabel.bottomAnchor, constant: 16),
            customButton.leftAnchor.constraint(equalTo: garbageInfoLabel.leftAnchor),
            customButton.widthAnchor.constraint(equalToConstant: 64),
            customButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
        
    }
    
    @objc private func startCamera() {
        
        print("camera")
        
        
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            //            self.pickerController.allowsEditing = true
            self.pickerController.sourceType = .camera
            
            self.present(self.pickerController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
            //            self.pickerController.allowsEditing = true
            self.pickerController.sourceType = .photoLibrary
            
            self.present(self.pickerController, animated: true, completion: nil)
        }))
        
        
        
        alert.modalPresentationStyle = .popover
        
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true)
        
    }
    
    private func setupLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first, error)
        }
    }
    
}


extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error : \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = manager.location else { return }
        
        longitude = location.coordinate.longitude
        latitude = location.coordinate.latitude
        
        fetchCityAndCountry(from: location) { placemark, error in
            guard let placemark = placemark, error == nil else {
                print(error)
                return
            }
            self.locationLabel.text = placemark.subLocality ?? ""
            self.garbageInfoLabel.text = "No garbage collection today."
            //            print(placemark.subLocality)
        }
        
    }
    
    
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image: UIImage?
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            image = pickedImage
            
        } else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            image = pickedImage
        }
        
        if let data = image?.jpeg(.medium) {
            
            let fileName = "ref_\(String.randomString(length: 5))"
            //            let fileName = "name"
            
            let child = SpinnerViewController()
            
            
            
            picker.addChild(child)
            child.view.frame = picker.view.frame
            picker.view.addSubview(child.view)
            child.didMove(toParent: picker)
            
            
            
            func removeSpinner() {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                
            }
            
            
            
            
            NetworkManager.shared.uploadImage(data, longtitude: self.longitude, latitude: self.latitude) { response in
                print("callback")
                DispatchQueue.main.async {
                    removeSpinner()
                    self.pickerController.dismiss(animated: true, completion: nil)
                }

                
            }
            
            
            
        } else {
            
            pickerController.dismiss(animated: true, completion: nil)
            
        }
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        pickerController.dismiss(animated: true, completion: nil)
        
    }
    
    
    
}
