//
//  IssueAnnotation.swift
//  MtaaCare
//

import Foundation
import MapKit
import SwiftUI

struct IssueAnnotation: Identifiable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
    let color: Color
}
