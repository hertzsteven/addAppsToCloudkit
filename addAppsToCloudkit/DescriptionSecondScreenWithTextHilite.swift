/*
import SwiftUI

struct Person: Identifiable {
    let id = UUID()
    var name: String
    var description: String?
}

struct PersonListView: View {
    @State private var people: [Person] = [
        Person(name: "John", description: "John is a software engineer."),
        Person(name: "Jane", description: "Jane is a teacher."),
        Person(name: "Bob")
    ]
    
    var body: some View {
        NavigationView {
            List(people) { person in
                NavigationLink(
                    destination: DescriptionView(person: person, didUpdateDescription: { description in
                        self.didUpdateDescription(for: person, with: description)
                    }),
                    label: {
                        HStack {
                            Text(person.name)
                            Spacer()
                            if let description = person.description {
                                Text(description)
                                    .foregroundColor(.gray)
                            }
                        }
                    })
            }
            .navigationTitle("People")
        }
    }
    
    func didUpdateDescription(for person: Person, with description: String) {
        if let index = people.firstIndex(where: { $0.id == person.id }) {
            if people[index].description != description {
                people[index].description = description
                showAlert(for: person)
            }
        }
    }
    
    func showAlert(for person: Person) {
        let alert = UIAlertController(title: "Description Updated", message: "\(person.name)'s description has been updated.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
}

struct DescriptionView: View {
    @State private var description: String
    private let originalDescription: String
    var person: Person
    var didUpdateDescription: (String) -> Void
    
    init(person: Person, didUpdateDescription: @escaping (String) -> Void) {
        self.person = person
        self._description = State(initialValue: person.description ?? "")
        self.originalDescription = person.description ?? ""
        self.didUpdateDescription = didUpdateDescription
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    var body: some View {
        VStack {
            Text(person.name)
                .font(.title)
                .padding(.bottom)
            ZStack(alignment: .topLeading) {
                if description.isEmpty {
                    Text("Enter description here...")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
                TextEditor(text: $description)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .white
            UITextView.appearance().textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            DispatchQueue.main.async {
                // Set focus to the text editor when the view appears
                UITextView.appearance().isScrollEnabled = true
                UITextView.appearance().becomeFirstResponder()
            }
        }
        .onDisappear {
            if self.description != self.originalDescription {
                // Save the description if it has changed
                didUpdateDescription(description)
            }
        }
    }
}
*/