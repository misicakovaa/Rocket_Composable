//
//  StringExtension.swift
//  Rocket
//
//  Created by Adela Mišicáková on 19.07.2022.
//

import Foundation

extension String {
    
    struct DateFormatterHolder {
            static var _dateFormatter: DateFormatter = DateFormatter()
        }
    
    //MARK: - Input Formatter
    
    var inputDateFormatter: DateFormatter {
        get {
            DateFormatterHolder._dateFormatter.dateFormat = DateFormatter.inputDateFormat
            return DateFormatterHolder._dateFormatter
        }
    }
    
    //MARK: - Output Formatter
    
    var outputDateFormatter: DateFormatter {
        get {
            DateFormatterHolder._dateFormatter.dateFormat = DateFormatter.outputDateFormat
            return DateFormatterHolder._dateFormatter
        }
    }
    
    //MARK: - Formate dateString
    // - Formates dateString from format yyyy-MM-dd to d.M.yyyy (by default)
    // - Returns formatted dateString
    
    func formateDateString(fromFormat inputDateFormat: String = "yyyy-MM-dd", toFormat outputDateFormat: String = "d.M.yyyy") -> String {
        
        DateFormatter.inputDateFormat = inputDateFormat
        DateFormatter.outputDateFormat = outputDateFormat
        
        if let date = self.inputDateFormatter.date(from: self) {
            return self.outputDateFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }
}
