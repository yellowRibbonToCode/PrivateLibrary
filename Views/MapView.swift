////
////  MapView.swift
////  PrivateLibrary
////
////  Created by 강희영 on 2021/10/24.
////
//
//import SwiftUI
//import MapKit
//
//struct Place: Identifiable {
//    let id = UUID()
//    let coordinate: CLLocationCoordinate2D
//}
//
//struct MapView: View {
//    var coordinate: CLLocationCoordinate2D
//    @State private var region = MKCoordinateRegion()
//    @State private var annotationItems = [ Place(coordinate: .init(latitude: 0, longitude: 0)) ]
//    
//    var body: some View {
//        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: annotationItems)
//        {item in
//            MapAnnotation(coordinate: item.coordinate)
//            {
//                Image(systemName: "square.fill")
//                    .font(.title)
//                    .foregroundColor(.mainBrown)
//                    .opacity(0.3)
//            }
//        }
//        .onAppear {
//            setRegion(coordinate)
//        }
//    }
//    
//    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
//        region = MKCoordinateRegion(
//            center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//        annotationItems = [Place(coordinate: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))]
//    }
//}
//
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(coordinate: CLLocationCoordinate2D(latitude: 37.480514, longitude: 126.97969))
//    }
//}
