//
//  ReportIssueView.swift
//  MtaaCare

import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth


struct ReportIssueView: View {
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil
    @State private var location: String = ""
    @State private var selectedCategory: String = ""
    @State private var description: String = ""
    @State private var isSubmitting = false
    @State private var errorMessage = ""

    
    let categories = ["Roads", "Sanitation", "Infrastructure", "Water", "Electricity"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Header
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Report An Issue")
                        .font(.headline)
                    Spacer()
                }
                .padding(.bottom, 10)

                // Image Upload
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                            .frame(height: 180)

                        if let image = selectedImage {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 180)
                                .cornerRadius(16)
                        } else {
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("Tap to upload photo")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }
                    }
                }
                .onChange(of: selectedPhoto) { oldValue, newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = Image(uiImage: uiImage)
                        }
                    }
                }

                // Location Input
                VStack(alignment: .leading, spacing: 6) {
                    Text("Location").bold()
                    HStack {
                        TextField("Enter your location...", text: $location)
                            .padding(.horizontal, 10)
                            .frame(height: 44)
                        Image(systemName: "location.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 10)
                    }
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .cornerRadius(8)
                }

                // Category Picker
                VStack(alignment: .leading, spacing: 6) {
                    Text("Issue Category").bold()
                    Menu {
                        ForEach(categories, id: \.self) { cat in
                            Button(cat) { selectedCategory = cat }
                        }
                    } label: {
                        HStack {
                            Text(selectedCategory.isEmpty ? "Select category" : selectedCategory)
                                .foregroundColor(selectedCategory.isEmpty ? .gray.opacity(0.6) : .primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 44)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .cornerRadius(8)
                    }
                }

                // Description Text Area
                VStack(alignment: .leading, spacing: 6) {
                    Text("Description").bold()
                    
                    ZStack(alignment: .topLeading) {
                        if description.isEmpty {
                            Text("Describe the issue in detail...")
                                .foregroundColor(Color.gray.opacity(0.6))
                                .padding(.top, 12)
                                .padding(.horizontal, 16)
                        }

                        TextEditor(text: $description)
                            .padding(10)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            .cornerRadius(8)
                            .frame(height: 120)
                    }
                }

                // Submit Button
                Button(action: {
                    isSubmitting = true
                    errorMessage = ""

                    saveReport(imageURL: nil)
                }) {
                    Text("Submit Report")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.mtaaGreen)
                        .cornerRadius(30)
                }
                .padding(.top, 10)
                
                if isSubmitting {
                    ProgressView("Submitting...")
                        .padding(.top, 10)
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

            }
            .padding()
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
    
    func saveReport(imageURL: String?) {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {
            errorMessage = "User not authenticated."
            isSubmitting = false
            return
        }

        let uid = user.uid
        let email = user.email ?? "unknown"
        let title = description.components(separatedBy: ".").first ?? "Issue Report"

        let reportData: [String: Any] = [
            "title": title,
            "location": location,
            "category": selectedCategory,
            "description": description,
            "imageURL": imageURL ?? "",
            "timestamp": FieldValue.serverTimestamp(),
            "userId": uid,
            "reporterName": email,   // Or fetch displayName if you support profile names
            "status": "Pending"
        ]

        db.collection("reports").addDocument(data: reportData) { error in
            isSubmitting = false
            if let error = error {
                errorMessage = "Failed to save report: \(error.localizedDescription)"
            } else {
                clearForm()
            }
        }
    }

    func clearForm() {
        selectedPhoto = nil
        selectedImage = nil
        location = ""
        selectedCategory = ""
        description = ""
    }

}


#Preview {
    ReportIssueView()
}

