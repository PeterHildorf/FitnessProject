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
                        NavigationLink {
                            EventFullView(
                                event: event,
                                dataViewModel: viewModel.data,
                                eventViewModel: EventViewModel(data: viewModel.data)
                            )
                        } label: {
                            // Her sender du data med ind i boksen:
                            EventBoxView(data: viewModel.data, event: event)
                        }
                        .foregroundColor(.black)
                        
                        if event.id != viewModel.sortedEventsAsc.last?.id {
                            Divider()
                        }
                        
                    }
                }
                NavigationLink {
                    EventCreateView(viewModel: EventViewModel(data: viewModel.data))
                } label: {
                    Text("+")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(22)
                }
            }
        }
        .navigationTitle("Booking")
        .navigationBarTitleDisplayMode(.inline)
        
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




struct BookingListView_Preview: PreviewProvider {
    static var previews: some View {
        BookingListView(viewModel: ListViewModel(data: DataViewModel(), year: Calendar.current.component(.year, from: Date())))
    }
}
