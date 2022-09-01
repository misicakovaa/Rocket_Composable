//
//  DateFormatterExtension.swift
//  Rocket
//
//  Created by Adela Mišicáková on 25.07.2022.
//

import Foundation

extension DateFormatter {
    
    //MARK: - Input date format
    
    struct DateFormatHolder {
        static var _inputDateFormat: String = "yyyy-MM-dd"
        static var _outputDateFormat: String = "d.M.yyyy"
    }
    
    static var inputDateFormat: String {
        get {
            return DateFormatHolder._inputDateFormat
        }
        
        set(newValue) {
            DateFormatHolder._inputDateFormat = newValue
        }
    }
    
    //MARK: - Output date format
    
    static var outputDateFormat: String {
        get {
            return DateFormatHolder._outputDateFormat
        }
        
        set(newValue) {
            DateFormatHolder._outputDateFormat = newValue
        }
    }
}
