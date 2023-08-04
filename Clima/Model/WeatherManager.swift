import Foundation
import CoreLocation

protocol WeatherManagerDelegate
{
    func weatherDidUpdate(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ weatherManager: WeatherManager, _ error: Error)
}

struct WeatherManager
{
    var delegate: WeatherManagerDelegate?

    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    
    func fetchWeather(cityName: String)
    {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY")
        let urlString = "\(weatherUrl)&appid=\(apiKey!)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY")
        let urlString = "\(weatherUrl)&appid=\(apiKey!)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String)
    {
        // 1. Create a URL
        if let url = URL(string: urlString)
        {
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url, completionHandler:
            // Closure function
            { (data, response, error) in
                // Task can fail if there are connection issues for example
                if error != nil
                {
                    delegate?.didFailWithError(self, error!)
                }
                
                if let safeData = data
                {
                    if let weather = parseJSON(safeData)
                    {
                        delegate?.weatherDidUpdate(self, weather: weather)
                    }
                }
            })
            
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?
    {
        let decoder = JSONDecoder()
        do
        {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        }
        catch
        {
            delegate?.didFailWithError(self, error)
            return nil
        }
    }
}
