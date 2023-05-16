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
    
    let knownTimeZoneIdentifiers: [String] = TimeZone.knownTimeZoneIdentifiers
    
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
    
    @State var identifier = TimeZone.current.identifier
    @State var backgroundColor = Color.orange
    @State var textColor = Color.black
    
    var body: some View {
        
        Form {
            WidgetView(identifier: $identifier,
                       backgroundColor: $backgroundColor,
                       textColor: $textColor)
            .frame(width: ScreenSize.width/2.2, height: ScreenSize.width/2.2)
            .cornerRadius(15)
            .shadow(radius: 12)
            .padding(.horizontal, (ScreenSize.width - ScreenSize.width/2.2)/2)
            .padding(50)
            
            Section("Please select timezone") {
                Menu(identifier) {
                    ForEach(knownTimeZoneIdentifiers, id: \.self) { identifier in
                        Button {
                            self.identifier = identifier
                            UserDefaults.standard.set(identifier, forKey: "selectedTimeZone")
                            UserDefaults.standard.synchronize()
                            WidgetCenter.shared.reloadAllTimelines()
                        } label: {
                            Text(identifier)
                        }
                    }
                }
                .foregroundColor(.primary)
            }
            
            Section("Please select background color") {
                Picker(
                    selection: $backgroundColor,
                    label: HStack {
                        Image(systemName: "rectangle.fill")
                        Text("Background Color").bold()
                    }
                ) {
                    ForEach(colors.dropLast(), id: \.self) { color in
                        Text(color.description.uppercased())
                    }
                }
                .foregroundColor(backgroundColor)
            }
            
            
            Section("Please select text color") {
                Picker(
                    selection: $textColor,
                    label: HStack {
                        Image(systemName: "textformat.size")
                        Text("Text Color").bold()
                    }
                ) {
                    ForEach(colors, id: \.self) { color in
                        Text(color.description.uppercased())
                    }
                }
                .foregroundColor((textColor != Color.white) ? textColor : Color.lightGray)
            }
        }
        
    }
    
}

struct WidgetView: View {
    
    @Binding var identifier: String
    @Binding var backgroundColor: Color
    @Binding var textColor: Color
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(backgroundColor.gradient)
            VStack {
                Text(identifier.getCityName())
                    .font(.title3)
                    .padding(.trailing, 25)
                Text(identifier.getCurrentTime())
                    .font(.largeTitle).bold()
                    .padding(.top, -5)
            }
            .foregroundColor(textColor)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





