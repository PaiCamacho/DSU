//
//  MapsViewController.swift
//  DSU
//
//  Created by Paola Camacho on 2/7/20.
//  Copyright © 2020 Paola Camacho. All rights reserved.
//

import UIKit
import MapKit
class MapsViewController: UIViewController {
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var pinchGes: UIPinchGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationServices()
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        view.addGestureRecognizer(pinch)

        // Do any additional setup after loading the view.
    }
    @objc func handlePinch(sender: UIPinchGestureRecognizer){
        guard sender.view != nil else {return}
        
        if sender.state == .began || sender.state == .changed{
            sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
            sender.scale = 1.0
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func configureLocationServices(){
        locationManager.delegate = self // View Contoller
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        else if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManager: locationManager)
        }
        
    }
    private func beginLocationUpdates(locationManager: CLLocationManager){
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D){
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1020,longitudinalMeters: 1020)
        mapView.setRegion(zoomRegion, animated: true)
    }
    private func addAnnotations(){
        let locations = [
        ["title": "William C Jason Library", "latitude": 39.185765, "longitude": -75.541868],
        ["title": "Bank of America Building", "latitude": 39.184867, "longitude": -75.541628],
        ["title": "Administration Building", "latitude": 39.186580, "longitude": -75.538813],
        ["title": "Wellness Center", "latitude": 39.187105, "longitude": -75.543084],
        ["title": "Annex Building", "latitude": 39.185284, "longitude": -75.546028],
        ["title": "Conrad Hall", "latitude": 39.185794, "longitude": -75.544836],
        ["title": "Education and Humanities Building", "latitude": 39.185286, "longitude": -75.540449],
        ["title": "Science Center North", "latitude": 39.186812, "longitude": -75.541578],
        ["title": "Science Center South", "latitude": 39.186400, "longitude": -75.541132],
        ["title": "Price Building", "latitude": 39.187080, "longitude": -75.540455],
        ["title": "Village Cafe", "latitude": 39.185076, "longitude": -75.538683],
        ["title": "MLK", "latitude": 39.188060, "longitude": -75.541723]
        ]
        
        for location in locations{
            let annotation = MKPointAnnotation()
            annotation.title = location["title"] as? String
            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
                mapView.addAnnotation(annotation)
        }
        
    }

}
extension MapsViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil{
            zoomToLatestLocation(with: latestLocation.coordinate)
            addAnnotations()
            
        }
        
        currentCoordinate = latestLocation.coordinate
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManager: manager)
        }
    }

    
}
