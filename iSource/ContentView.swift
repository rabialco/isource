//
//  ContentView.swift
//  iSource
//
//  Created by Rabialco Argana on 27/07/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RandomizeView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Randomize Feature View
struct RandomizeView : View {
    
    // MARK: - Data Value
    @State var topic_value = [
        Topic(id: 0, name: "State", offset: 0, place: 1, videoID: "48JYBb5yJ0s", appleDocumentation: "swiftui/state", otherDocumentation: [OtherDocumentation(title: "What is the @State property wrapper", organization: "HackingwithSwift", url: "https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-state-property-wrapper"), OtherDocumentation(title: "State in SwiftUI", organization: "SwiftOnTap", url: "https://swiftontap.com/state")]),
        Topic(id: 1, name: "Binding", offset: 0, place: 2, videoID: "lgtB3WLEOYg", appleDocumentation: "swiftui/binding", otherDocumentation: [OtherDocumentation(title: "What is the @Binding property wrapper", organization: "HackingwithSwift", url: "https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-binding-property-wrapper"), OtherDocumentation(title: "Binding in SwiftUI", organization: "SwiftOnTap", url: "https://swiftontap.com/binding")]),
        Topic(id: 2, name: "ObservedObject", offset: 0, place: 3, videoID: "a7oMETqWbnQ", appleDocumentation: "swiftui/observedobject", otherDocumentation: [OtherDocumentation(title: "How to use @ObservedObject to manage state from external objects", organization: "HackingwithSwift", url: "https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-observedobject-to-manage-state-from-external-objects"), OtherDocumentation(title: "ObservedObject in SwiftUI", organization: "SwiftOnTap", url: "https://swiftontap.com/observedobject")]),
        Topic(id: 3, name: "EnvironmentObject", offset: 0, place: 4, videoID: "xs2nOhD7R5M", appleDocumentation: "swiftui/environmentobject", otherDocumentation: [OtherDocumentation(title: "How to use @EnvironmentObject to share data between views", organization: "HackingwithSwift", url: "https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-environmentobject-to-share-data-between-views"), OtherDocumentation(title: "EnvironmentObject in SwiftUI", organization: "SwiftOnTap", url: "https://swiftontap.com/environmentobject")]),
        Topic(id: 4, name: "StateObject", offset: 0, place: 5, videoID: "VLUhZbz4arg", appleDocumentation: "swiftui/stateobject", otherDocumentation: [OtherDocumentation(title: "What is the @StateObject property wrapper?", organization: "HackingwithSwift", url: "https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-stateobject-property-wrapper"), OtherDocumentation(title: "StateObject in SwiftUI", organization: "SwiftOnTap", url: "https://swiftontap.com/stateobject")]),
        Topic(id: 5, name: "ObservableObject", offset: 0, place: 6, videoID: "VioWHKN1eKs", appleDocumentation: "combine/observableobject", otherDocumentation: [OtherDocumentation(title: "ObservableObject in SwiftUI", organization: "SwiftOnTap", url: "https://swiftontap.com/observableobject"), OtherDocumentation(title: "SwiftUI ObservableObject Tutorial", organization: "iOS Creator", url: "https://www.ioscreator.com/tutorials/swiftui-observable-object-tutorial")]),
    ]
    
    // Count Card Swipe
    @State var swiped = 0
    @Namespace var name
    @State var selected : Topic = Topic(id: 0, name: "State", offset: 0, place: 1, videoID: "48JYBb5yJ0s", appleDocumentation: "state", otherDocumentation: [OtherDocumentation(title: "What is the @State property wrapper", organization: "HackingwithSwift", url: "https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-state-property-wrapper")])
    @State var show = false

    var body: some View {
        ZStack{
            VStack {
                // MARK: - Stack Element Topic
                GeometryReader {reader in
                    VStack{
                        ZStack {
                            ForEach(topic_value.reversed()){topic in
                                CardView(topic: topic, reader: reader, swiped: $swiped,show: $show, selected: $selected, name: name)
                                
                                // MARK: - Gesture
                                    .offset(x: topic.offset)
                                    .rotationEffect(.init(degrees: getRotation(offset: topic.offset)))
                                    .gesture(DragGesture().onChanged({ (value) in
                                        // Update Position
                                        withAnimation{
                                            if value.translation.width > 0 {
                                                topic_value[topic.id].offset = value.translation.width
                                            }
                                        }
                                    }).onEnded({ (value) in
                                        withAnimation {
                                            if value.translation.width > 150{
                                                topic_value[topic.id].offset = 1000
                                                
                                                // Update Swipe id
                                                swiped = topic.id + 1
                                                
                                                restoreCard(id: topic.id)
                                            }
                                            else {
                                                topic_value[topic.id].offset = 0
                                            }
                                        }
                                    }))
                            }
                        }
                        .padding(.top, 50)
                        .padding(.bottom, 100)
                        // MARK: - Text
                        Text("Hmm, what to learn?")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("Click randomize button below to get inspiration what to learn in SwiftUI!")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .frame(width: 250, height: 30, alignment: .center)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                        Button(action: {
                            randomizeCard()
                            }) {
                                Image(systemName: "r.joystick.tilt.down.fill")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.black)
                            }
                    }
                }
                
            }
            .opacity(show ? 0 : 1)
            
            if show {
                Detail(topic: selected, show: $show, name: name)
            }
        }
        .background(
            LinearGradient(gradient: .init(colors: [Color(hex: "F6E0BB"), Color(hex: "E5E5E5"), Color(hex: "E5E5E5")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    // MARK: - Randomize Feature
    func randomizeCard() {
        topic_value.shuffle()
        var int = 1
        ForEach(topic_value){topic in
            topic_value[topic.id].place = int
            int += 1
        }
        int = 1
    }
    
    // MARK: - Restore Card Feature
    func restoreCard(id: Int) {
        var currentCard = topic_value[id]
        
        // Append Last Topic
        
        currentCard.id = topic_value.count
        
        topic_value.append(currentCard)
        
        // Animation Going Back
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation{
                topic_value[topic_value.count - 1].offset = 0
            }
        }
    }
    
    // MARK: - Rotation Feature
    func getRotation (offset: CGFloat) -> Double {
        let value = offset / 200
        
        let angle : CGFloat = 5
        
        let degree = Double(value * angle)
        
        return degree
    }
}

// MARK: - Card View
struct CardView : View {
    var topic : Topic
    var reader : GeometryProxy
    @Binding var swiped : Int
    @Binding var show : Bool
    @Binding var selected: Topic
    var name : Namespace.ID
    
    var body: some View {
        VStack {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
                    VStack() {
                        Text("\(topic.name)")
                            .font(.system(size: 25 ))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .matchedGeometryEffect(id: topic.name, in: name)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        
                        ZStack (){
                            Button(action: {
                                withAnimation(.easeIn){
                                    selected = topic
                                    show.toggle()
                                }
                                
                            }) {
                                Text("Detail >")
                                    .font(.system(size: 10))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }
                .padding(.horizontal)
            })
            // MARK: - Dynamic Frame Setting
            .frame(width: reader.frame(in: .global).width - 50,height: reader.frame(in: .global).height - 350)
            .padding(.vertical, 10)
            .background(.white)
            .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.black, lineWidth: 4)
                )
            .cornerRadius(15)
            .padding(.horizontal, 20 + (CGFloat(topic.id - swiped)))
            .offset(y: topic.id - swiped <= 2 ? CGFloat(topic.id - swiped) * 25 : 50)
            .shadow(color: Color.black.opacity(0.12), radius: 5, x: 0, y: 5)
        }
        .contentShape(Rectangle())
    }
}

// MARK: - Detail View
struct Detail : View {
    
    var topic : Topic
    @Binding var show : Bool
    var name : Namespace.ID
    
    var body: some View {
        ScrollView {
            VStack{
                HStack(alignment: .top, spacing: 12) {
                    Button(action: {
                        withAnimation(.linear){
                            show.toggle()
                        }
                        
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                    }
                    Text("\(topic.name)")
                        .matchedGeometryEffect(id: topic.name, in: name)
                        .font(.system(size: 30, weight: .bold))
                    
                    Spacer(minLength: 0)
                }
                .padding(.leading, 20)
                .padding([.top,.bottom,.trailing])
                
                // MARK: - Tutorial Video
                Text("Tutorial Video")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 300, height: 50, alignment: .leading)
                HStack {
                    VStack {
                        VideoView(videoID: topic.videoID)
                            .frame(width: 300, height: 150, alignment: .leading)
                            .cornerRadius(15)
                    }
                }
                .frame(width: 320,height: 170)
                .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.black, lineWidth: 4)
                    )
                .background(Color.white)
                .cornerRadius(15)
                
                // MARK: - Apple Documentation
                Text("Apple Documentation")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 300, height: 50, alignment: .leading)

                HStack {
                    Link(destination: URL(string: "https://developer.apple.com/documentation/\(topic.appleDocumentation)")!) {
                        VStack {
                            Text("\(topic.name) Documentation")
                                .font(.system(size: 20, weight: .bold))
                                .frame(width: 280, height: 20, alignment: .leading)
                            Text("Apple Developer")
                                .font(.system(size: 15))
                                .frame(width: 280, height: 20, alignment: .leading)
                            ZStack (){
                                Text("Click to redirect ")
                                        .font(.system(size: 10))
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                            .padding(.trailing, 20)
                        }
                    }
                }
                .accentColor(.black)
                .padding(.leading, 20)
                .padding(.vertical)
                .frame(width: 320,height: 120)
                .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.black, lineWidth: 4)
                    )
                .background(Color.white)
                .cornerRadius(15)
                
                // MARK: - Other Documentation
                Text("Other Documentation")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 300, height: 50, alignment: .leading)
                ForEach(topic.otherDocumentation){otherDocumentation in
                        HStack {
                            Link(destination: URL(string: "\(otherDocumentation.url)")!) {
                            VStack {
                                Text(otherDocumentation.title)
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 280, height: 50, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .padding(.horizontal, 30)
                                Text(otherDocumentation.organization)
                                    .font(.system(size: 15))
                                    .frame(width: 280, height: 20, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .padding(.horizontal, 30)
                                ZStack (){
                                    Text("Click to redirect ")
                                            .font(.system(size: 10))
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                .padding(.trailing, 20)
                            }
                        }
                        .accentColor(.black)
                        .padding(.leading, 20)
                        .padding(.vertical)
                        .frame(width: 320,height: 120)
                        .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.black, lineWidth: 4)
                            )
                        .background(Color.white)
                        .cornerRadius(15)
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
}

// MARK: - Data Struct
struct Topic : Identifiable {
    var id : Int
    var name : String
    var offset : CGFloat
    var place : Int
    var videoID : String
    var appleDocumentation : String
    var otherDocumentation : Array<OtherDocumentation>
}

struct OtherDocumentation : Identifiable{
    var id: String {
        self.title
    }
    var title : String
    var organization : String
    var url : String
}

// MARK: - Hex Color Initialization
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
