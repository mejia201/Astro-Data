import SwiftUI
import URLImage

struct MissionsView: View {
    @State private var marsPhotos = [MarsPhoto]()

    var body: some View {
            NavigationView {
                List(marsPhotos) { photo in
                    VStack(alignment: .leading) {
                        Text("Photo ID: \(photo.id)")
                        Text("Sol: \(photo.sol)")
                        Text("Camera: \(photo.camera.name)")
                        Text("URL image:\(photo.img_src) ")
                        URLImage(URL(string: photo.img_src)!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .padding()
                        }
                    }
                }
                .onAppear {
                    fetchMarsPhotosByDate()
                }
                .navigationTitle("Mars Rover Photos")
            }
        }

    func fetchMarsPhotosByDate() {
        let urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=2015-6-3&api_key=lKnPv8jXStvjQhTPZARSErbLhJC5zrj2qAK73An4"
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    if let jsonData = data {
                        do {
                            let decoder = JSONDecoder()
                            let photoData = try decoder.decode(MarsPhotoResponse.self, from: jsonData)
                            DispatchQueue.main.async {
                                self.marsPhotos = photoData.photos
                            }
                        } catch {
                            print("Error al analizar JSON: \(error)")
                        }
                    }
                } else {
                    print("Error en la solicitud: \(error!.localizedDescription)")
                }
            }
            task.resume()
        }
    }
}

struct MissionsView_Previews: PreviewProvider {
    static var previews: some View {
        MissionsView()
    }
}

struct MarsPhotoResponse: Decodable {
    let photos: [MarsPhoto]
}

struct MarsPhoto: Identifiable, Decodable {
    let id: Int
    let sol: Int
    let camera: Camera
    let img_src: String
}

struct Camera: Decodable {
    let id: Int
    let name: String
}
