//
//  DataViewModel.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 08/04/2025.
//

import SwiftUI
import Combine

class DataViewModel: ObservableObject {
    //Deler data til de andre viewmodels skal tilgå denne samme data
    @Published var events: [EventModel] = EventModel.sampleData
    
    func addMember(to eventID: UUID, member: String){
        guard let idx = events.firstIndex(where: { $0.id == eventID }) else {return}
        print("skal opdatere eventet")
        if !events[idx].EventMemembers.contains(member) {
            events[idx].EventMemembers.append(member)
        }
    }
    
    func removeMember(from eventID: UUID, member: String) {
        guard let idx = events.firstIndex(where: { $0.id == eventID }) else { return }
        events[idx].EventMemembers.removeAll { $0 == member }

    }
}
