import Foundation
import CoreLocation

class WeatherKitManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var temperature: Double?
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping () -> Void) {
        let apiKey = "cc4fdee8f310fe3fba972c2be52bcac5"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"

        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
                        DispatchQueue.main.async {
                            self.temperature = decodedData.main.temp
                            completion()
                        }
                    } catch {
                        print(error)
                        completion()
                    }
                }
            }.resume()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            fetchWeatherData(latitude: latitude, longitude: longitude) {}
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

struct WeatherData: Codable {
    let main: Main
}

struct Main: Codable {
    let temp: Double
}

