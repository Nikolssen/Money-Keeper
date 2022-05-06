//
//  Task12Widget.swift
//  Task12Widget
//
//  Created by Ivan Budovich on 5/1/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    func data() -> ([(String, Double)], Bool)? {
        guard let userDefaults = UserDefaults.init(suiteName: "group.budovich.task") else { return nil }
        let isAuthorized = userDefaults.value(forKey: "UserForWidget") as? Bool ?? false
        if isAuthorized {
            let dictData = userDefaults.value(forKey: "WidgetInfo") as? Data
            if let dictData = dictData {
                let decoder = PropertyListDecoder()
                let dict = try? decoder.decode([String: Double].self, from: dictData)
                if let dict = dict {
                    let array = dict.map { ($0, $1) }
                    return (array, isAuthorized)
                }
            }
        }
        return ([], false)
    }
}


struct Task12WidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Image("BG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            VStack {
                if let data = entry.data(), !data.0.isEmpty {
                    if !data.1 {
                        Text("User is not authorized")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title)
                    }
                    else {
                        TabView {
                            ForEach(data.0, id: \.0) { value in
                                VStack {
                                    if value.1 > 0 {
                                        Text("Today gained: \(value.1) " + value.0)
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .font(.title)
                                            .tag(value.0)
                                    }
                                    else
                                    if value.1 < 0 {
                                        Text("Today spent: \(value.1 * (-1)) " + value.0)
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .font(.title)
                                            .tag(value.0)
                                    }
                                    
                                    if value.1 == 0 {
                                        Text("There is no change in \(value.0)")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .font(.title)
                                            .tag(value.0)
                                    }
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                    }
                    
                }
                else {
                    Text("Data is not available")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title)
                }
            }
            
        }
        
        
    }
}

@main
struct Task12Widget: Widget {
    let kind: String = "Task12Widget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Task12WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Task12Widget_Previews: PreviewProvider {
    static var previews: some View {
        Task12WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
