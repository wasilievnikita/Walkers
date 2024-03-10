//
//  MapViewController.swift
//  Walkers
//
//  Created by Никита Васильев on 10.10.2023.
//

import UIKit
import MapKit
import AudioToolbox

class MapViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    private let nc = NotificationCenter.default
    var tapArray:[CLLocationCoordinate2D] = []
    var geocoder: CLGeocoder!
    let locationManager = CLLocationManager()
    
    // MARK: - LifeCycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        addView()
        setupRegion()
        layout()
        changeTextFieldTo()
        changeTextFieldFrom()
        longTapping()
        hideKeyborad()
    }
    
    // MARK: - UIElements
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Найти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(addMembers), for: .touchUpInside)
        button.alpha = 0.8
        return button
    }()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.layer.cornerRadius = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
        return stackView
    }()
    
    private let viewSeparate: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private lazy var compass: UIButton = {
        let button = UIButton(type: .system)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        let btnImage = UIImage(named: "compass")
        button.setImage(btnImage, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(tapFunction), for: .touchUpInside)
        button.alpha = 1
        return button
    }()
    
   @objc func tapFunction() {
        locationManager.startUpdatingLocation()
    }
    
    private let distance: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var textFieldFrom: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.textAlignment = .left
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.placeholder = "Откуда"
        textField.addTarget(self, action: #selector(changeTextFieldFrom), for: .editingDidEnd)
        return textField
    }()
    
    private lazy var textFieldTo: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.textAlignment = .left
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.placeholder = "Куда"
        textField.addTarget(self, action: #selector(changeTextFieldTo), for: .editingDidEnd)
        return textField
    }()
    
    // MARK: - Tap on screen func
    
    func setupRegion() {
        var mapRegion = MKCoordinateRegion()
        mapRegion.center.latitude = 55.753857
        mapRegion.center.longitude = 37.619765
        mapRegion.span.latitudeDelta = 0.1
        mapRegion.span.longitudeDelta = 0.1
        self.mapView.region = mapRegion
    }
    
    func longTapping() {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
    }
    
    @objc func longTap(sender: UIGestureRecognizer){
        print("long tap")
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
        }
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Точка"
        self.mapView.addAnnotation(annotation)
        tapArray.append(annotation.coordinate)
    }
    
    // MARK: - Search users
    
    @objc func addMembers() {
        if mapView.overlays.isEmpty {
            let allert = UIAlertController(title: "Ошибка", message: "Постройте маршрут", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default)
            allert.addAction(okAction)
            present(allert, animated: true)
        } else {
            let searchResult = SearchResult()
            navigationController?.pushViewController(searchResult, animated: true)
        }
    }
    
    func delegates() {
        self.textFieldTo.delegate = self
        self.textFieldFrom.delegate = self
        locationManager.delegate = self
    }

    // MARK: - Change text field in the search
    
    @objc func changeTextFieldFrom() {
        geocoder = CLGeocoder()
        geocoder.geocodeAddressString(textFieldFrom.text!) { (placemarks, error) -> Void in
            if error != nil {
                print("MapKit error")
            }
            if placemarks != nil {
                if let placemark = placemarks?.last {
                    let annotation = MKPointAnnotation()
                    annotation.title = self.textFieldFrom.text!
                    annotation.coordinate = placemark.location!.coordinate
                    self.tapArray.append(annotation.coordinate)
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    @objc func changeTextFieldTo() {
        geocoder = CLGeocoder()
        geocoder.geocodeAddressString(textFieldTo.text!) { (placemarks, error) -> Void in
            if error != nil {
                print("MapKit error")
            }
            if placemarks != nil {
                if let placemark = placemarks?.last {
                    let annotation = MKPointAnnotation()
                    annotation.title = self.textFieldTo.text!
                    annotation.subtitle = self.textFieldTo.text!
                    annotation.coordinate = placemark.location!.coordinate
                    self.tapArray.append(annotation.coordinate)
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    func checkLocationEnable() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.setupManager()
            } else {
                let alert = UIAlertController(title: "Отключена служба геолокации", message: "Хотите включить?", preferredStyle: .alert)
                let settings = UIAlertAction(title: "Настройки", style: .default) { (alert) in
                    if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
                alert.addAction(settings)
                alert.addAction(cancelAction)
                self.present(alert,animated: true, completion: nil)
            }
        }
    }
    
    func setupManager() {
        locationManager.desiredAccuracy =  kCLLocationAccuracyBest
    }
    
    // MARK: - keyboard func
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyborad() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Layout
    
    func addView() {
        view.addSubview(mapView)
        view.addSubview(stackView)
        view.addSubview(searchButton)
        view.addSubview(distance)
        mapView.addSubview(compass)
        stackView.addArrangedSubview(textFieldFrom)
        stackView.addArrangedSubview(viewSeparate)
        stackView.addArrangedSubview(textFieldTo) 
    }
    
    func deleteRoute() {
        for overlay in mapView.overlays {
            mapView.removeOverlay(overlay)
        }
    }
    
    func layout() {
        
        let inset: CGFloat = 150
        
        NSLayoutConstraint.activate([
            
            searchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset / 1.2),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset/2),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset/2),
            
            distance.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: -inset / 15),
            distance.heightAnchor.constraint(equalToConstant: 30),
            distance.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            distance.leadingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: inset/6),
            distance.trailingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: -inset/6),
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: inset/2),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset/15),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset/15),
            stackView.heightAnchor.constraint(equalToConstant: inset * 2/3),
            
            textFieldFrom.topAnchor.constraint(equalTo: stackView.topAnchor),
            textFieldFrom.heightAnchor.constraint(equalToConstant: inset/3),
            textFieldTo.heightAnchor.constraint(equalToConstant: inset/3),
            viewSeparate.topAnchor.constraint(equalTo: textFieldFrom.bottomAnchor),
            viewSeparate.heightAnchor.constraint(equalToConstant: 0.5),
            textFieldTo.topAnchor.constraint(equalTo: viewSeparate.bottomAnchor),
            
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            compass.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 2.7 * inset),
            compass.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            compass.heightAnchor.constraint(equalToConstant: 45),
            compass.widthAnchor.constraint(equalToConstant: 45),
        ])
    }
}

// MARK: - Extensions

extension MapViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true

        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Я здесь"
        mapView.addAnnotation(annotation)
//        annotation.coordinate = placemark.location!.coordinate
        self.tapArray.append(annotation.coordinate)
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var viewMarker: MKMarkerAnnotationView
        let idView = "marker"
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: idView) {
            view.annotation = annotation
            viewMarker = view as! MKMarkerAnnotationView
        } else {
            viewMarker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: idView)
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.setImage( UIImage(named: "path"), for: .normal)
            viewMarker.canShowCallout = true
            viewMarker.calloutOffset = CGPoint(x: 0, y: 8)
            viewMarker.rightCalloutAccessoryView = rightButton
        }
        return viewMarker
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineCap = .round
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        deleteRoute()
        
        var firstCoordinate: CLLocationCoordinate2D
        var secondCoordinate: CLLocationCoordinate2D
        
        var sourcePlacemark: MKPlacemark
        var destinationPlacemark: MKPlacemark
        
        if !(textFieldTo.text!.isEmpty) || !(textFieldFrom.text!.isEmpty) {
            textFieldTo.text = ""
            textFieldFrom.text = ""
        }
        
        firstCoordinate = tapArray.dropLast().last!
        secondCoordinate = tapArray.last!
        
        sourcePlacemark = MKPlacemark(coordinate: firstCoordinate, addressDictionary: nil)
        destinationPlacemark = MKPlacemark(coordinate: secondCoordinate, addressDictionary: nil)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.requestsAlternateRoutes = true
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                            let rect = route.polyline.boundingMapRect
                            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        let loc1 = CLLocation(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude)
        let loc2 = CLLocation(latitude: secondCoordinate.latitude, longitude: secondCoordinate.longitude)
        let calculateDistance = Int(round(loc1.distance(from: loc2)))
        distance.isHidden = false
        distance.text = "Время в пути: " + String(calculateDistance/50) + " " + "мин"
        
    }
}






