//
//  GaleryView.swift
//  AstroData
//
//  Created by Bryan Mejia on 28/10/23.
//

import SwiftUI
import URLImage


struct GaleryView: View {
    @State private var apodImages: [APODImage] = []
    @State private var isLoading = false

    var body: some View {
            VStack {
                    NavigationView {
                        List {
                            ForEach(apodImages) { apodImage in
                                Section(header: Text(apodImage.title)) {
                                    URLImage(URL(string: apodImage.url)!) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 350)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .background(Color.white)
                                            .clipped()
                                            .padding()
                                    }
                                }
                            }
                            Section {
                                Button(action: {
                                    loadImages()
                                }) {
                                    
                                
                                    Text("Recargar imágenes nuevas")
                                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 40)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
                        }
                        .onAppear(perform: loadImages)
                        .navigationBarTitle("NASA APOD Gallery")
                    }
                }
        
        }
    
    
    
    func loadImages() {
          
            let apiKey = "lKnPv8jXStvjQhTPZARSErbLhJC5zrj2qAK73An4"
            let apiUrl = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&count=20"

            if let url = URL(string: apiUrl) {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("Error al obtener datos de la NASA: \(error.localizedDescription)")
                    } else if let data = data,
                        let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        let images = jsonArray.compactMap { APODImage(data: $0) }
                        self.apodImages = images
                    }

                    DispatchQueue.main.async {
                        isLoading = false
                    }
                }
                task.resume()
            }
        }
    
    
    
    
}


struct APODImage: Identifiable {
    let id = UUID()
    let date: String
    let url: String
    let title: String

    init(data: [String: Any]) {
        self.date = data["date"] as? String ?? ""
        self.url = data["url"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
    }
}

struct GaleryView_Preview: PreviewProvider {
    static var previews: some View {
        GaleryView()
    }
}

