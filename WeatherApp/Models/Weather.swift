//
//  Weather.swift
//  RxWeather
//
//  Created by Дмитрий Мартьянов on 01.08.2022.
//

import Foundation

struct Weather {
    enum RequestType {
        
        case address(String)
        
        case latitudeLongitude(String, String)
        
    }
    
    enum Unit: String {
        
        case metric
        
        case imperial
    }
    
    struct Responce: Decodable {
        
        static let empty = Responce()
        
        private enum CodingKeys: String, CodingKey {
            case latitude
            case longitude
            case resolvedAddress
            case address
            case description
            case days
            
        }
        
        let latitude: Double
        
        let longitude: Double
        
        let resolvedAddress: String
        
        let address: String
        
        let description: String
        
        let days: [Day]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            latitude = try container.decode(Double.self, forKey: .latitude)
            longitude = try container.decode(Double.self, forKey: .longitude)
            resolvedAddress = try container.decode(String.self, forKey: .resolvedAddress)
            address = try container.decode(String.self, forKey: .address)
            description = try container.decode(String.self, forKey: .description)
            days = try container.decode([Day].self, forKey: .days)
        }
        private init() {
            self.latitude = 0.0
            self.longitude = 0.0
            self.resolvedAddress = "-"
            self.address = "-"
            self.description = "-"
            self.days = []
        }
    }
    
    struct Day: Decodable {
        private enum CodingKeys: String, CodingKey {
            case datetimeEpoch
            case tempmax
            case tempmin
            case temp
            case feelslike
            case humidity
            case windspeed
            case precipprob
            case icon
            case hours
        }
        let datetimeEpoch: Int
        
        let tempMax: Float
        
        let tempMin: Float
        
        let temp: Float
        
        let feelsLike: Float
        
        let humidity: Float
        
        let windspeed: Float
        
        let precipProbability: Float
        
        let icon: String
        
        let hours: [Hour]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            datetimeEpoch = try container.decode(Int.self, forKey: .datetimeEpoch)
            tempMax = try container.decode(Float.self, forKey: .tempmax)
            tempMin = try container.decode(Float.self, forKey: .tempmin)
            temp = try container.decode(Float.self, forKey: .temp)
            feelsLike = try container.decode(Float.self, forKey: .feelslike)
            humidity = try container.decode(Float.self, forKey: .humidity)
            windspeed = try container.decode(Float.self, forKey: .windspeed)
            precipProbability = try container.decode(Float.self, forKey: .precipprob)
            icon = try container.decode(String.self, forKey: .icon)
            hours = try container.decode([Hour].self, forKey: .hours)
        }
        
    }
    
    struct Hour: Decodable {
        enum CodingKeys: String, CodingKey {
            case datetimeEpoch
            case temp
            case humidity
            case windspeed
            case precipprob
            case icon
        }
        let datetimeEpoch: Int
        
        let temp: Float
        
        let humidity: Float
        
        let windspeed: Float
        
        let precipProbability: Float
        
        let icon: String
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            datetimeEpoch = try container.decode(Int.self, forKey: .datetimeEpoch)
            temp = try container.decode(Float.self, forKey: .temp)
            humidity = try container.decode(Float.self, forKey: .humidity)
            windspeed = try container.decode(Float.self, forKey: .windspeed)
            precipProbability = try container.decode(Float.self, forKey: .precipprob)
            icon = try container.decode(String.self, forKey: .icon)
        }
        
    }
 }
