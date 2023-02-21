//
//  ScrollViewWithToggleSection.swift
//  addAppsToCloudkit
//
//  Created by Steven Hertz on 2/21/23.
//

import SwiftUI


struct ScrollViewWithToggleSection: View {
    let words = ["apple", "banana", "orange"]
    let sentences = [        "I like apples and bananas.",        "I ate a banana and an orange for breakfast.",        "Oranges are my favorite fruit.",        "The apple pie is delicious."    ]
    
    var body: some View {
        ScrollView {
            ForEach(words, id: \.self) { word in
                DisclosureGroup(
                    content: {
                        ForEach(sentences.filter { $0.contains(word) }, id: \.self) { sentence in
                            Text(sentence)
                                .frame( maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                    },
                    label: {
                        Text(word.capitalized)
                    }
                )
            }
        }
        .padding()
    }
}

//struct ScrollViewWithToggleSection: View {
//    @State private var sectionExpanded = false
//
//    var body: some View {
//        ScrollView {
//            VStack {
//                DisclosureGroup(
//                    isExpanded: $sectionExpanded,
//                    content: {
//                        HStack {
//                            Text("Item 1")
//                            Spacer()
//                        }
//                        Text("Item 2")
//                        Text("Item 3")
//                    },
//                    label: {
//                        Text("Section 1")
//                    }
//                ).padding()
//                DisclosureGroup(
//                    isExpanded: $sectionExpanded,
//                    content: {
//                        Text("Item 1")
//                        Text("Item 2")
//                        Text("Item 3")
//                    },
//                    label: {
//                        Text("Section 2")
//                    }
//                )
//            }
//        }
//    }
//}

//struct ScrollViewWithToggleSection: View {
//    @State private var sectionsExpanded = Array(repeating: false, count: 3)
//
//    var body: some View {
//        ScrollView {
//            ForEach(0..<3) { sectionIndex in
//                VStack {
//                    HStack {
//                        Text("Section \(sectionIndex + 1)")
//                        Spacer()
//                        Button(action: {
//                            self.sectionsExpanded[sectionIndex].toggle()
//                        }) {
//                            Image(systemName: self.sectionsExpanded[sectionIndex] ? "chevron.up" : "chevron.down")
//                        }
//                    }
//                    if self.sectionsExpanded[sectionIndex] {
//                        Text("Item 1")
//                        Text("Item 2")
//                        Text("Item 3")
//                    }
//                }
//            }
//        }
//    }
//}

struct ScrollViewWithToggleSection_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewWithToggleSection()
    }
}
