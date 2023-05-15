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
        return SimpleEntry(date: Date(), timeZone: TimeZoneIdentifier(identifier: TimeZone.current.identifier), backgroundColor: .orange, textColor: .black)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), timeZone: TimeZoneIdentifier(identifier: TimeZone.current.identifier), backgroundColor: .orange, textColor: .black)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        for minuteOffset in 0 ..< 1440 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let selectedTimeZone = ContentView().selectedTimeZoneIdentifier.identifier // UserDefaults.standard.string(forKey: "selectedTimeZone") ?? TimeZone.current.identifier
            let entry = SimpleEntry(date: entryDate, timeZone: TimeZoneIdentifier(identifier: selectedTimeZone), backgroundColor: .orange, textColor: .black)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let timeZone: TimeZoneIdentifier
    let backgroundColor: Color
    let textColor: Color
}

struct TimeZoneWidgetEntryView : View {
    
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(.orange.gradient)
            VStack {
                Text(entry.timeZone.identifier.getCityName())
                    .font(.title3)
                    .padding(.trailing, 25)
                Text(entry.timeZone.identifier.getCurrentTime())
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
        TimeZoneWidgetEntryView(entry: SimpleEntry(date: Date(), timeZone: TimeZoneIdentifier(identifier: TimeZone.current.identifier), backgroundColor: .orange, textColor: .black))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
