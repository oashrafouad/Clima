import Foundation

struct WeatherData: Codable
{
    let name: String
    let timezone: Int
    let main: Main
    let weather: [Weather]
}

struct Main: Codable
{
    let temp: Float
}

struct Weather: Codable
{
    let id: Int
}
