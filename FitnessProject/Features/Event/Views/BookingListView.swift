//
//  BookingListView.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 01/04/2025.
//
import SwiftUI
import Foundation


struct BookingListView: View {
    
    @StateObject var viewModel: ListViewModel
    @EnvironmentObject var eventDataVM: EventDataViewModel
    @EnvironmentObject private var authVM: AuthViewModel
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Horisontal scroll med datoer
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 40) {
                        //loopet iterer igennem alle dagene i arrayet, og opretter DayView til hvert dag som dele de samme properties som vi bruger viewModel
                        ForEach(viewModel.days.indices, id: \.self) { index in
                            let day = viewModel.days[index]
                            let isSelected = (day == viewModel.selectedDate)
                            let isToday = Calendar.current.isDateInToday(day)
                            
                            DayView(day: day,
                                    isSelected: isSelected,
                                    isToday: isToday,
                                    formattedWeekday: formattedWeekday,
                                    formattedDay: formattedDay) {
                                viewModel.selectedDate = day
                                let df = DateFormatter()
                                df.dateFormat = "yyyy-MM-dd HH:mm 'DK time'"
                                df.timeZone = TimeZone(identifier: "Europe/Copenhagen")
                                print("Selected date (DK): \(df.string(from: day))")
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                    .background(Color.blue)
                
                // Liste over events
                ScrollView {
                    let eventsForDate = eventDataVM.events
                        .filter { Calendar.current.isDate($0.EventDate, inSameDayAs: viewModel.selectedDate) }
                        .sorted { $0.EventDate < $1.EventDate }
                    //henter events ned udfra dato, så det sorteret
                    ForEach(eventsForDate) { event in
                        NavigationLink(value: event) {
                            EventBoxView(event: event)
                        }
                        .tint(.black)
                    }
                }
                .navigationDestination(for: EventModel.self) { event in
                    EventFullView(eventID: event.id)
                }
                if authVM.currentRole == .instructor {
                    NavigationLink("＋") {
                        EventCreateView()
                    }
                    .font(.system(size: 40, weight: .bold))
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    
    
    
    func formattedDay(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    func formattedWeekday(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "da_DK")
        formatter.dateFormat = "EEEEE"
        return formatter.string(from: date)
    }
}



