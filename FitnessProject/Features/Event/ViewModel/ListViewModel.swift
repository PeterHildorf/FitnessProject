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
    
    // listen for alle dage i 2025
    @Published var days: [Date] = []
    // liste for events der skal filteres for forskellige datoer
    
    // variablen som holder styr på dagen der vælges
    @Published var selectedDate: Date = Date()
    
    private var cancellables = Set<AnyCancellable>()

    let today: Date
    
    init(data: EventDataViewModel,year: Int) {
        self.data = data
        self.today = Date()
        self.days = generateDaysFromCurrentWeek(year)
        
        // Abonner på data.events og udløs ViewModel's objectWillChange
        data.$events
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    
    
    // computed property som filtere events
    var filteredEvents: [EventModel] {
        let calendar = Calendar.current
        return data.events.filter { calendar.isDate($0.EventDate, inSameDayAs: selectedDate) }
    }
    // hjælpe funktioner til at sortere events efter tidspunkt
    var sortedEventsAsc: [EventModel] {
        let calendar = Calendar.current
        return data.events
          .filter { calendar.isDate($0.EventDate, inSameDayAs: selectedDate) }
          .sorted { $0.EventDate < $1.EventDate }
      }
    
    var sortedEventsDesc: [EventModel] {
        filteredEvents.sorted { $0.EventDate > $1.EventDate }
    }
    
    
    
    func generateDaysFromCurrentWeek(_ year: Int) -> [Date] {
        var days: [Date] = []
        
        // Opret en kalender, der er låst til DK-tid
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "da_DK")
        calendar.timeZone = TimeZone(identifier: "Europe/Copenhagen")!
        calendar.firstWeekday = 2 // mandag
        
        let today = Date()
        
        // Tjek at det er det rigtige år
        guard calendar.component(.year, from: today) == year else {
            return []
        }
        
        // Find mandagen for indeværende uge
        guard let startOfCurrentWeek = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                          from: today)
        ) else {
            return []
        }
        
        // find 31. december i det angivne år
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
