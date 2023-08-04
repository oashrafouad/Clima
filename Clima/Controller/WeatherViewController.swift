import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = 5000
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        // While editing, show the Clear button in the text field
        searchTextField.clearButtonMode = .whileEditing
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate
{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.endEditing(true)
    }
    
    // This function dismisses keyboard when return (go) button is pressed
    // textField here refers to the text field that activates (calls) the function, so this can be linked to multiple text fields but they all must have their delegate set to self
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    // Clear the text field when it ends editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text
        {
            weatherManager.fetchWeather(cityName: city)
        }
        textField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate
{
    func weatherDidUpdate(_ weatherManager: WeatherManager, weather: WeatherModel)
    {
        DispatchQueue.main.async() {
            let animationTime = 0.5
            // Added animations
            UIView.transition(with: self.temperatureLabel, duration: animationTime, options: .transitionCrossDissolve) {
                self.temperatureLabel.text = weather.temperatureString
            }
            
            UIView.transition(with: self.cityLabel, duration: animationTime, options: .transitionCrossDissolve) {
                self.cityLabel.text = weather.cityName
            }
            
            UIView.transition(with: self.conditionImageView, duration: animationTime, options: .transitionCrossDissolve) {
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            }
        }
    }
    
    func didFailWithError(_ weatherManager: WeatherManager, _ error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last
        {
//            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            print("location changed")
        }
        print(locations.last)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
