import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
        
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        weatherManager.delegate = self
        // While editing, show the Clear button in the text field
//        searchTextField.clearButtonMode = .whileEditing
    }

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
    
    func weatherDidUpdate(_ weatherManager: WeatherManager, weather: WeatherModel)
    {
        print(weather.cityName)
        print(weather.temperature)
    }
    
    func didFailWithError(_ weatherManager: WeatherManager, _ error: Error) {
        print(error)
    }
}
