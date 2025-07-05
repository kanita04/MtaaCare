//
//  IssueModel.swift
//  MtaaCare
//

import Foundation
import FirebaseFirestore
import UIKit

struct IssueModel: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var category: String
    var location: String
    var imageURL: String
    var timestamp: Date
    var userId: String
    var reporterName: String
    var status: String

    // UI helpers
    var reportedDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }

    var image: UIImage? {
        return nil 
    }
}

extension IssueModel {
    var categoryImageName: String {
        switch category.lowercased() {
        case "roads": return "roads"
        case "sanitation": return "sanitation"
        case "infrastructure": return "infrastructure"
        case "water": return "water"
        case "electricity": return "electricity"
        default: return "placeholder" // fallback image
        }
    }
}



