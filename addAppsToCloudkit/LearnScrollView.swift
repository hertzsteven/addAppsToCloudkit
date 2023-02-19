

import SwiftUI

struct Appo: Identifiable {
    let id = UUID()
    let cloudkitKey: String
    var name: String
    var category: String?
}

struct PersonListView: View {
    @State private var appos: [Appo] = [
        Appo(cloudkitKey: "ca.ripplepublishing.countsortmatch-1", name: "Count, Sort and Match", category: "Numbers"),
        Appo(cloudkitKey: "busythings.qdapps.feedthemonkey-193", name: "Feed the Monkey", category: "Alphabet"),
        Appo(cloudkitKey: "mobi.abcmouse.academy-190", name: "ABCmouse.com")
    ]
    
    var body: some View {
        NavigationView {
            List(appos) { appo in
                NavigationLink(
                    destination: DescriptionView(appo: appo, didUpdateDescription: { category in
                        self.didUpdateDescription(for: appo, with: category)
                    }),
                    label: {
                        HStack {
                            Text(appo.name)
                            Spacer()
                            if let category = appo.category {
                                Text(category)
                                    .foregroundColor(.gray)
                            }
                        }
                    })
            }
            .navigationTitle("Apps")
        }
    }
    
    func didUpdateDescription(for appo: Appo, with category: String) {
        if let index = appos.firstIndex(where: { $0.id == appo.id }) {
            if appos[index].category != category {
                appos[index].category = category
                showAlert(for: appo)
            }
        }
    }
    
    func showAlert(for appo: Appo) {
        let alert = UIAlertController(title: "Description Updated", message: "\(appo.name)'s category has been updated.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
}

struct DescriptionView: View {
    @State private var category: String
    private let originalDescription: String
    var appo: Appo
    var didUpdateDescription: (String) -> Void
    
    init(appo: Appo, didUpdateDescription: @escaping (String) -> Void) {
        self.appo = appo
        self._category = State(initialValue: appo.category ?? "")
        self.originalDescription = appo.category ?? ""
        self.didUpdateDescription = didUpdateDescription
    }
    
    var body: some View {
        VStack {
            Text(appo.name)
                .font(.title)
                .padding(.bottom)
            TextEditor(text: $category)
                .padding()
        }
        .onDisappear {
            if self.category != self.originalDescription {
                // Save the category if it has changed
                didUpdateDescription(category)
            }
        }
    }
}

