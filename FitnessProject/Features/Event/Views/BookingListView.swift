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
                
                // Liste over events
                ScrollView {
                    ForEach(viewModel.sortedEventsAsc) { event in
                        NavigationLink(value: event) {
                            // Kun event med
                            EventBoxView(event: event)
                        }
                        .tint(.black)
                    }
                }
                .navigationDestination(for: EventModel.self) { event in
                    // Destination henter altid selv den seneste data fra miljøet
                    EventFullView(eventID: event.id)
                }
                
                NavigationLink("＋") {
                    EventCreateView()
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





// Preview
struct BookingListView_Previews: PreviewProvider {
    static var previews: some View {
        // Opret og seed EventDataViewModel med sampleData
        let eventDataVM = EventDataViewModel()
        eventDataVM.events = EventModel.sampleData
        
        // Opret ListViewModel
        let listVM = ListViewModel(
            data: eventDataVM,
            year: Calendar.current.component(.year, from: Date())
        )
        
        return NavigationStack {
            BookingListView(viewModel: listVM)
                .environmentObject(eventDataVM)
        }
    }
}
