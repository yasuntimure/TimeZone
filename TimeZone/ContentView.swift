//
//  ContentView.swift
//  TimeZone
//
//  Created by Eyüp on 2.05.2023.
//

import Foundation
import SwiftUI
import WidgetKit

struct ContentView: View {
    
    let timeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
        .map { TimeZoneIdentifier(identifier: $0) }
    
    let colors = [Color.red,
                  Color.green,
                  Color.blue,
                  Color.orange,
                  Color.yellow,
                  Color.pink,
                  Color.purple,
                  Color.gray,
                  Color.black,
                  Color.white]
    
    @State var selectedTimeZoneIdentifier = TimeZoneIdentifier(identifier: TimeZone.current.identifier)
    @State var selectedBackgroundColor = Color.orange
    @State var selectedTextColor = Color.black
    
    var body: some View {
        VStack {
            WidgetView(selectedTimeZoneIdentifier: $selectedTimeZoneIdentifier,
                       selectedBackgroundColor: $selectedBackgroundColor,
                       selectedTextColor: $selectedTextColor)
            .frame(width: ScreenSize.width/2.2, height: ScreenSize.width/2.2, alignment: .center)
            .cornerRadius(15)
            .shadow(radius: 12)
            .padding(50)
            Form {
                Section("Please select timezone") {
                    Picker(selection: $selectedTimeZoneIdentifier, label: Text("Timezone")) {
                        ForEach(timeZoneIdentifiers) { identifier in
                            Text(identifier.identifier)
                                .tag(identifier)
                        }
                    }
                }
                
                Section(header: Text("Please select background color")) {
                    Picker(
                        selection: $selectedBackgroundColor,
                        label: HStack {
                            Image(systemName: "rectangle.fill")
                            Text("Background Color").bold()
                        }
                    ) {
                        ForEach(colors.dropLast(), id: \.self) { color in
                            Text(color.description.uppercased())
                        }
                    }
                    .foregroundColor(selectedBackgroundColor)
                }
                
                Section(header: Text("Please select text color")) {
                    Picker(
                        selection: $selectedTextColor,
                        label: HStack {
                            Image(systemName: "textformat.size")
                            Text("Text Color").bold()
                        }
                    ) {
                        ForEach(colors, id: \.self) { color in
                            Text(color.description.uppercased())
                        }
                    }
                    .foregroundColor((selectedTextColor != Color.white) ? selectedTextColor : Color.lightGray)
                }
            }
        }
    }
}

struct WidgetView: View {
    
    @Binding var selectedTimeZoneIdentifier: TimeZoneIdentifier
    @Binding var selectedBackgroundColor: Color
    @Binding var selectedTextColor: Color
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(selectedBackgroundColor.gradient)
            VStack {
                Text(selectedTimeZoneIdentifier.identifier.getCityName())
                    .font(.title3)
                    .padding(.trailing, 25)
                Text(selectedTimeZoneIdentifier.identifier.getCurrentTime())
                    .font(.largeTitle).bold()
                    .padding(.top, -5)
            }
            .foregroundColor(selectedTextColor)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TimeZoneIdentifier: Identifiable, Hashable {
    let id = UUID()
    let identifier: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: TimeZoneIdentifier, rhs: TimeZoneIdentifier) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}





