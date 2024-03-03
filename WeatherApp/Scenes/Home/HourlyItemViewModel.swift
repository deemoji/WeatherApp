import Foundation

struct HourlyItemViewModel {
    let hour: String
    let temp: String
    let humidity: String
    let wind: String
    let precipProbability: String
    let icon: String
}

extension HourlyItemViewModel {
    init(hour: Weather.Hour) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.hour = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(hour.datetimeEpoch)))
        self.temp = String(Int(hour.temp)) + "°"
        self.humidity = String(Int(hour.humidity)) + "%"
        self.wind = String(Int(hour.windspeed)) + " m/s"
        self.precipProbability = String(Int(hour.precipProbability)) + "%"
        self.icon = hour.icon
    }
}
