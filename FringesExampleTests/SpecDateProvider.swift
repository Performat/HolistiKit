import Foundation
@testable import FringesExample

class SpecDateProvider {

    fileprivate lazy var currentDate: Date = {
        let strTime = "2016-08-23 00:00:00 +0000"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter.date(from: strTime)!
    }()

    func set(date: Date) {
        self.currentDate = date
    }
}

extension SpecDateProvider: DateProviding {

    var date: Date {
        return currentDate
    }
}