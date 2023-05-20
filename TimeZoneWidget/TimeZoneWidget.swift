//
//  TimeZoneWidget.swift
//  TimeZoneWidget
//
//  Created by Eyüp on 2.05.2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), identifier: TimeZone.current.identifier, backgroundColor: .orange, textColor: .black)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), identifier: TimeZone.current.identifier, backgroundColor: .orange, textColor: .black)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
           var entries: [SimpleEntry] = []
           let currentDate = Date()
           
           for minuteOffset in 0..<60 {
               let futureDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
        
               if let selectedTimeZone = UserDefaults.standard.string(forKey: "selectedTimeZone") {
                   let entry = SimpleEntry(date: futureDate, identifier: selectedTimeZone, backgroundColor: .orange, textColor: .black)
                   entries.append(entry)
               } else {
                   let entry = SimpleEntry(date: futureDate, identifier: TimeZone.current.identifier, backgroundColor: .orange, textColor: .black)
                   entries.append(entry)
               }
           }
           
           let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!))
           completion(timeline)
       }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let identifier: String
    let backgroundColor: Color
    let textColor: Color
}

struct TimeZoneWidgetEntryView : View {
    
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(.orange.gradient)
            VStack (alignment: .leading) {
                Text(entry.identifier.getCityName())
                    .font(.title3)
                Text(entry.identifier.getCurrentTime(date: entry.date))
                    .font(.largeTitle).bold()
                    .padding(.top, -5)
            }
        }
    }
    
}

struct TimeZoneWidget: Widget {
    let kind: String = "TimeZoneWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TimeZoneWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Time Zone Widget App")
        .description("Shows a specific city time as you choose")
        .supportedFamilies([.systemSmall])
    }
}


struct TimeZoneWidget_Previews: PreviewProvider {
    static var previews: some View {
        TimeZoneWidgetEntryView(entry: SimpleEntry(date: Date(), identifier: TimeZone.current.identifier, backgroundColor: .orange, textColor: .black))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
