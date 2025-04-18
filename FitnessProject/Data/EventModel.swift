//
//  EventModel.swift
//  FitnessProject
//
//  Created by Peter Hannibal Hildorf on 05/04/2025.
//
import Foundation

struct EventModel: Identifiable {
    let id: UUID
    var EventTitle: String = ""
    var EventDuration: Int
    var EventTrainer: String = ""
    var EventLocation: String = ""
    var EventMemembers: [String]
    var EventSlots: Int
    var EventDate: Date
    var EventPicture: String
    var EventDescription: String
    
    // Ny initializer, der tillader at sætte id'et manuelt
    init(id: UUID = UUID(),
         EventTitle: String,
         EventDuration: Int,
         EventTrainer: String,
         EventLocation: String,
         EventMemembers: [String],
         EventSlots: Int,
         EventDate: Date,
         EventPicture: String,
         EventDescription: String) {
        self.id = id
        self.EventTitle = EventTitle
        self.EventDuration = EventDuration
        self.EventTrainer = EventTrainer
        self.EventLocation = EventLocation
        self.EventMemembers = EventMemembers
        self.EventSlots = EventSlots
        self.EventDate = EventDate
        self.EventPicture = EventPicture
        self.EventDescription = EventDescription
    }
}
extension EventModel {
    static let sampleData: [EventModel] = {
        let calendar = Calendar.current
        let today = Date()

        // Eksempel på datoer ved at tilføje eller ændre dage og tidspunkter
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let nextWeek = calendar.date(byAdding: .day, value: 7, to: today)!
        
        return [
            // Fitness-event i dag
            EventModel(
                EventTitle: "Fitness",
                EventDuration: 60,
                EventTrainer: "Peter Hildorf",
                EventLocation: "Amager Strand",
                EventMemembers: ["Peter", "Oliver", "Andreas", "Morten"],
                EventSlots: 20,
                EventDate: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: today) ?? today,
                EventPicture: "Fitness",
                EventDescription: "Kom ned og skub noget jern, bliv stor og stærk, og vær klar til sommer og stå skarp"
            ),
            // Yoga-event i morgen
            EventModel(
                EventTitle: "Yoga",
                EventDuration: 45,
                EventTrainer: "Maria Jensen",
                EventLocation: "Nørrebro Center",
                EventMemembers: ["Anna", "Sofie"],
                EventSlots: 10,
                EventDate: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: tomorrow) ?? tomorrow,
                EventPicture: "Yoga",
                EventDescription: "Få styr på din krop, og få strækket godt ud i ledne og befrie dig selv"
            ),
            // Run-event overmorgen
            EventModel(
                EventTitle: "Run",
                EventDuration: 50,
                EventTrainer: "Lars Olsen",
                EventLocation: "Frederiksberg Gym",
                EventMemembers: ["Mads", "Katrine", "Oskar", "Peter"],
                EventSlots: 5,
                EventDate: calendar.date(bySettingHour: 7, minute: 30, second: 0, of: yesterday) ?? yesterday,
                EventPicture: "Run",
                EventDescription: "Kom ud og få frisk luft, og løb en god mængde kilometer i benene, så din kondi er perfekt og kan vise den frem på strava"
            ),
            // Run-event i morgen
            EventModel(
                EventTitle: "Run",
                EventDuration: 60,
                EventTrainer: "Lars Olsen",
                EventLocation: "Søvang",
                EventMemembers: ["Mads", "Katrine", "Peter"],
                EventSlots: 5,
                EventDate: calendar.date(bySettingHour: 18, minute: 30, second: 0, of: nextWeek) ?? nextWeek,
                EventPicture: "Run",
                EventDescription: "Kom ud og få frisk luft, og løb en god mængde kilometer i benene, så din kondi er perfekt og kan vise den frem på strava"
            ),
            // Fitness-event i dag
            EventModel(
                EventTitle: "Fitness",
                EventDuration: 30,
                EventTrainer: "Frank Olsen",
                EventLocation: "Kødbyen",
                EventMemembers: ["Mads", "Katrine", "Peter", "Viktor"],
                EventSlots: 8,
                EventDate: calendar.date(bySettingHour: 12, minute: 30, second: 0, of: today) ?? today,
                EventPicture: "Fitness",
                EventDescription: "Kom ned og skub noget jern, bliv stor og stærk, og vær klar til sommer og stå skarp"
            ),
            EventModel(
                EventTitle: "Fitness",
                EventDuration: 30,
                EventTrainer: "Oskar Jensen",
                EventLocation: "Amager",
                EventMemembers: ["Mads", "Katrine", "Peter", "Viktor"],
                EventSlots: 4,
                EventDate: calendar.date(bySettingHour: 12, minute: 30, second: 0, of: today) ?? today,
                EventPicture: "Fitness",
                EventDescription: "Kom ned og skub noget jern, bliv stor og stærk, og vær klar til sommer og stå skarp"
            ),
            EventModel(
                EventTitle: "Yoga",
                EventDuration: 30,
                EventTrainer: "Sebastian Trautner",
                EventLocation: "Roskilde",
                EventMemembers: ["Mads", "Katrine", "Peter",],
                EventSlots: 4,
                EventDate: calendar.date(bySettingHour: 20, minute: 30, second: 0, of: today) ?? today,
                EventPicture: "Yoga",
                EventDescription: "Få styr på din krop, og få strækket godt ud i ledne og befrie dig selv"
            )
        ]
    }()
}
