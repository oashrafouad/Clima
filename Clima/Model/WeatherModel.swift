import Foundation

struct WeatherModel
{
    let conditionId: Int
    let cityName: String
    let temperature: Float
    
    var temperatureString: String
    {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String
    {
        switch conditionId
        {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...501:
            return "cloud.rain"
        case 502...504:
            return "cloud.heavyrain"
        case 511:
            return "cloud.sleet"
        case 520...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801:
            return "cloud.sun"
        case 802...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}
