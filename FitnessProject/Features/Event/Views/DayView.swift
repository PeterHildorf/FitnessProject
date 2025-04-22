//
//  DayView.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 05/04/2025.
//

import SwiftUI

struct DayView: View {
    let day: Date
    let isSelected: Bool
    let isToday: Bool
    let formattedWeekday: (Date) -> String
    let formattedDay: (Date) -> String
    let onSelect: () -> Void

    var body: some View {
        VStack {
            Text(formattedWeekday(day))
            Text(formattedDay(day))
                .padding(4)
                .background(isToday ? Color.blue.opacity(0.2) : Color.clear)
                .background(isSelected ? Color.green.opacity(0.2) : Color.clear)
                .cornerRadius(6)
                .foregroundColor(isToday ? .blue : .primary)
        }
        .onTapGesture(perform: onSelect)
    }
}
