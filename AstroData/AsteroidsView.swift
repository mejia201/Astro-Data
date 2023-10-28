import SwiftUI
import UIKit


struct AsteroidsView: View {
    @State private var startDate = Date()
        @State private var endDate = Date()
        @State private var asteroidData: [Asteroid] = []
        @State private var isLoading = false
        @State private var hasSelectedDates = false
        
    var body: some View {
            NavigationView {
                VStack {
                    if !hasSelectedDates {
                        VStack {
                            
                            Text("Busqueda de Asteroides")
                                .font(.title)
                                .bold()
                                
                            
                            Image("osiris")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 280)
                                .padding()
                              
                            
                            Text("Consejo: Para un mejor resultado pon las fechas")
                                .font(.callout)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                              Text("con una semana de diferencia entre si.")
                                .font(.callout)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                               
                            
                            
                            Group{
                                
                                Section(header: Text("Selección de fechas")
                                    .font(.title3)
                                    .padding()){
                                        
                                        DatePicker("Fecha de inicio:", selection: $startDate, in: ...Date(), displayedComponents: .date)
                                            .padding()
                                        
                                        DatePicker("Fecha de fin:", selection: $endDate, in: ...Date(), displayedComponents: .date)
                                            .padding()
                                        
                                    }
                                
                            }
                            
                            Button(action: {
                                hasSelectedDates = true
                                fetchAsteroidData()
                            }) {
                                
                                
                                Text("Obtener datos de asteroides")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    } else {
                        if isLoading {
                            ProgressView("Cargando datos...")
                        } else {
                            
                            if asteroidData.isEmpty{
                                Text("No se encontraron resultados")
                                    .font(.title3)
                                    .padding()
                                Button(action: {
                                    
                                    hasSelectedDates = false
                                    asteroidData.removeAll()
                                }) {
                                    Text("Reintentar")
                                        .font(.title3)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            } else {
                                NavigationView{
                                    Form{
                                        List(asteroidData, id: \.id) { asteroid in
                                            Section(header: Text("Nombre: \(asteroid.name)")){
                                                
                                                Text("ID: \(asteroid.id)")
                                                                                                    .font(.callout)
                                                                                                    .bold()
                                                                                                    .foregroundColor(.blue)
                                                
                                           
                                                
                                                Text("Tamaño Minimo estimado (km): \(asteroid.estimatedDiameter.kilometers.estimatedDiameterMin) Tamaño Maximo estimado (km): \(asteroid.estimatedDiameter.kilometers.estimatedDiameterMax)")
                                                                                                    .font(.callout)
                                                
                                                
                                                Text("Potencialmente Peligroso: \(asteroid.potentiallyHazardous ? "Sí" : "No")")
                                                                                                    .font(.callout)
                                                
                                                
                                                if let closeApproachData = asteroid.closeApproachData.first {
                                                    Text("Fecha Acercamiento: \(closeApproachData.closeApproachDate)")
                                                        .font(.callout)
                                                    
                                                    Text("Cuerpo Orbitante: \(closeApproachData.orbitingBody)")
                                                        .font(.callout)
                                                    
                                                    
                                                    
                                                    Text("Velocidad (km/s): \(closeApproachData.relativeVelocity.kilometersPerSecond)")
                                                        .font(.callout)

                                                  
                                                    }
    
                                                
                                            }
                                            
                                            
                                        }
                                        Section{
                                            
                                            Button(action: {
                                                hasSelectedDates = false
                                                asteroidData.removeAll()
                                            }) {
                                                HStack {
                                                    Image(systemName: "globe.central.south.asia.fill")
                                                    Text("Volver a consultar")
                                                }
                                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 40)
                                                    .background(Color.blue)
                                                    .foregroundColor(.white)
                                                .cornerRadius(10)                                                    }
                                        }
                                        .padding()
                                    }
                                    
                                    .navigationBarTitle("Asteroides")
                                }
                                
                                
                                
                            }
                            
                        }
                    }
                }
           
            }
        }

    
    
    
    func fetchAsteroidData() {
        isLoading = true

       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)

    
        let apiKey = "lKnPv8jXStvjQhTPZARSErbLhJC5zrj2qAK73An4"
        let urlString = "https://api.nasa.gov/neo/rest/v1/feed?start_date=\(startDateString)&end_date=\(endDateString)&api_key=\(apiKey)"

        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(NASADataResponse.self, from: data)

                    
                        asteroidData = response.nearEarthObjects.flatMap { (date, asteroids) in
                            return asteroids.map { asteroid in
                                return Asteroid(id: asteroid.id, name: asteroid.name, absoluteMagnitude: asteroid.absoluteMagnitude, estimatedDiameter: asteroid.estimatedDiameter,
                                                potentiallyHazardous: asteroid.potentiallyHazardous, closeApproachData: asteroid.closeApproachData)
                            }
                        }

                        isLoading = false
                    } catch {
                        print("Error al decodificar la respuesta JSON: \(error)")
                        isLoading = false
                    }
                }
            }.resume()
        }
    }


    
    
    
    
}



struct AsteroidsView_Previews: PreviewProvider {
    static var previews: some View {
        AsteroidsView()
    }
}


struct NASADataResponse: Decodable {
    let links: Links
    let elementCount: Int
    let nearEarthObjects: [String: [Asteroid]]
    
    enum CodingKeys: String, CodingKey {
        case links = "links"
        case elementCount = "element_count"
        case nearEarthObjects = "near_earth_objects"
    }
}

struct Links: Decodable {
    let next: String?
    let prev: String?
    let selfLink: String?
    
    enum CodingKeys: String, CodingKey {
        case next = "next"
        case prev = "prev"
        case selfLink = "self"
    }
}

struct Asteroid: Decodable {
    let id: String
    let name: String
    let absoluteMagnitude: Double // Magnitud absoluta del asteroide
    let estimatedDiameter: Diameter // Tamaño estimado del asteroide
    let potentiallyHazardous: Bool // Indica si el asteroide es potencialmente peligroso
    let closeApproachData: [CloseApproachData] // Datos de acercamiento cercano del asteroide

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case absoluteMagnitude = "absolute_magnitude_h"
        case estimatedDiameter = "estimated_diameter"
        case potentiallyHazardous = "is_potentially_hazardous_asteroid"
        case closeApproachData = "close_approach_data"
    }
}

struct Diameter: Decodable {
    let kilometers: DiameterUnit
    let meters: DiameterUnit
    let miles: DiameterUnit
    let feet: DiameterUnit

    enum CodingKeys: String, CodingKey {
        case kilometers = "kilometers"
        case meters = "meters"
        case miles = "miles"
        case feet = "feet"
    }
}

struct DiameterUnit: Decodable {
    let estimatedDiameterMin: Double
    let estimatedDiameterMax: Double

    enum CodingKeys: String, CodingKey {
        case estimatedDiameterMin = "estimated_diameter_min"
        case estimatedDiameterMax = "estimated_diameter_max"
    }
}


struct CloseApproachData: Decodable {
    let closeApproachDate: String
    let relativeVelocity: RelativeVelocity
    let missDistance: MissDistance
    let orbitingBody: String

    enum CodingKeys: String, CodingKey {
        case closeApproachDate = "close_approach_date"
        case relativeVelocity = "relative_velocity"
        case missDistance = "miss_distance"
        case orbitingBody = "orbiting_body"
    }
}

struct RelativeVelocity: Decodable {
    let kilometersPerSecond: String
    let kilometersPerHour: String
    let milesPerHour: String

    enum CodingKeys: String, CodingKey {
        case kilometersPerSecond = "kilometers_per_second"
        case kilometersPerHour = "kilometers_per_hour"
        case milesPerHour = "miles_per_hour"
    }
}


struct MissDistance: Decodable {
    let astronomical: String
    let lunar: String
    let kilometers: String
    let miles: String
}
