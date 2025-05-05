//
//  FullViewModel.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 05/04/2025.
//

import Foundation

class FullViewModel: ObservableObject {
    func formattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "da_DK")
        formatter.timeZone = TimeZone(identifier: "Europe/Copenhagen")
        formatter.dateStyle = .long  // ex. "7. april 2025"
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
