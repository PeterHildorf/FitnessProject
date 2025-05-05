//
//  ListViewModel.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 01/04/2025.
//

import Foundation
import SwiftUI
import Combine  

class ListViewModel: ObservableObject {
    
    @ObservedObject var data: EventDataViewModel
    
    // the list of alle the days in 2025
    @Published var days: [Date] = []
    
    // variable that controls the day that is selected
    @Published var selectedDate: Date = Date()
    
    private var cancellables = Set<AnyCancellable>()

    let today: Date
    
    init(data: EventDataViewModel,year: Int) {
        self.data = data
        self.today = Date()
        self.days = generateDaysFromCurrentWeek(year)
        
        // subcribes on data.vents and apply viewmodel object will change
        data.$events
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    
        
    
    func generateDaysFromCurrentWeek(_ year: Int) -> [Date] {
        var days: [Date] = []
        
        // create a calend for dk time
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "da_DK")
        calendar.timeZone = TimeZone(identifier: "Europe/Copenhagen")!
        calendar.firstWeekday = 2 // monday
        
        let today = Date()
        
        // checks the current year
        guard calendar.component(.year, from: today) == year else {
            return []
        }
        
        // Finds monday for the current week
        guard let startOfCurrentWeek = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                          from: today)
        ) else {
            return []
        }
        
        // finds 31. december in current year
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Europe/Copenhagen")!
        guard let endOfYear = formatter.date(from: "\(year)-12-31") else {
            return []
        }
        
        var currentDate = startOfCurrentWeek
        
        while currentDate <= endOfYear {

            let localStartOfDay = calendar.startOfDay(for: currentDate)
            days.append(localStartOfDay)
            
            
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDay
        }
        
        return days
    }
}
