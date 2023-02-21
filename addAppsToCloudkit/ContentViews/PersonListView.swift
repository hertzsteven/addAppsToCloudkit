

import SwiftUI
import CloudKit


struct Appo: Identifiable, Comparable {
    let id = UUID()
    let cloudkitKey: String
    var name: String
    var category: String?
    var profileName: String?
    
    static func < (lhs: Appo, rhs: Appo) -> Bool {
        return lhs.name < rhs.name
    }
    
}

struct PersonListView: View {
    
    let profileNames = [
        "10 fingers +",
        "123 Genius PRO - First Numbers and Counting Games ",
        "123 Genius PRO - First Numbers and Counting Games",
        "ABC - Magnetic Alphabet HD for Kids",
        "ABC Genius PRO - Alphabet, Phonics, and Handwriting",
        "Alphabet Sounds Learning App",
        "Alphabet Sounds Word Study",
        "AlphaTots Alphabet",
        "Busy Shapes",
        "Butterfly Math",
        "Categories - Categorization Skill Development App",
        "Count, Sort and Match",
        "Counting Bear - Easily Learn How to Count",
        "Counting Bears",
        "Counting Dots: Number Practice",
        "Dexteria Jr. - Fine Motor Skill Development",
        "Dominoes Addition",
        "Doodle Buddy Paint Draw App",
        "Dr. Seuss's ABC - Read & Learn",
        "Draw and Tell HD",
        "Elmo Loves 123s",
        "Elmo Loves ABCs",
        "Endless Alphabet",
        "Endless Numbers: School Ed.",
        "Endless Numbers",
        "Farm 123 - Learn to count",
        "Feed the Monkey",
        "First Letters & Phonics",
        "First Letters and Phonics",
        "First Words Deluxe",
        "Following Directions Game",
        "Geoboard, by The Math Learning Center",
        "Interactive Alphabet ABC's",
        "iTrace - handwriting for kids",
        "Learning Patterns - Pattern & Logic Game for Kids",
        "Learning Patterns PRO - Develop Thinking Skills",
        "Learning Patterns PRO - Help Kids Develop Thinking",
        "LetterSchool - Block Letters",
        "LetterSchool - Learn to Write!",
        "Line 'em Up",
        "Little Writer Pro",
        "Little Writer Tracing App: Trace Letters & Numbers",
        "Marbotic 10 fingers",
        "Marbotic Learn to Read & Count",
        "Marbotic Smart Shapes",
        "Monkey Math School Sunshine",
        "Monkey Preschool Fix-It ",
        "Monkey Preschool Fix-It",
        "Monkey Preschool lunchbox",
        "Montessori Numbers for Kids",
        "Moose Math - Duck Duck Moose",
        "Moose Math",
        "My PlayHome School",
        "On The Farm ~ Touch, Look, Listen",
        "Oxford Phonics World: Personal",
        "Park Math HD - Duck Duck Moose",
        "Park Math",
        "PreK Letters and Numbers Learning Tracing G",
        "PreK Letters and Numbers Learning Tracing Games",
        "Reading Raven Vol 2 ",
        "Reading Raven Vol 2",
        "Ready to Print",
        "Rhyming Words",
        "ShapeBuilder Preschool Puzzles",
        "Short Vowel Word Study App",
        "Sight Word Games & Flash Card",
        "Sight Word Games & Flash Cards",
        "Sight Word Games Sight Words your way",
        "Sight words sentence builder",
        "SPELLING MAGIC 1 for Schools",
        "Starfall ABC",
        "Starfall ABCs",
        "Startdot Handwriting",
        "Student Signin",
        "TallyTots Counting",
        "Teachers' Pack 1",
        "Teachers' Pack 3",
        "TeachMe: Preschool - Toddler ",
        "Things That Go ~ Touch, Look, Listen",
        "Things That Go Together",
        "Touch, Look, Listen ~ My First Words",
        "What Do I Wear? ~ Touch, Look, Listen",
        "Word Wagon by Duck Duck Moose",
        "Word Wizard for Kids School Ed",
        "Writing Wizard - School Ed.",
        "Zoo Animals ~ Touch, Look, Listen"
    ]
    
    
    var dbs : CKDatabase {
        return CKContainer(identifier: "iCloud.com.developItSolutions.StudentLogins").publicCloudDatabase
    }
    
    @EnvironmentObject var appWork: AppWork
    
    // Declare a @State variable to hold the user's search text
    @State private var searchText = ""

    
    @State private var appos: [Appo] = [
        Appo(cloudkitKey: "ca.ripplepublishing.countsortmatch-188", name: "Count, Sort and Match", category: "Numbers"),
        Appo(cloudkitKey: "busythings.qdapps.feedthemonkey-193", name: "Feed the Monkey", category: "Alphabet"),
        Appo(cloudkitKey: "mobi.abcmouse.academy-190", name: "ABCmouse.com")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                    // Add a text field for the user to enter search text
                
                TextField("Search", text: $searchText)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                
                List(profileNames.filter({
                    searchText.isEmpty || $0.lowercased().contains(searchText.lowercased())
                }), id: \.self) { profile in
                    HStack {
                        Button {
                            appWork.selectedProfileFromList = profile
                            print(appWork.selectedProfileFromList)
                        } label: {
                            Text("do").foregroundColor(.blue)
                        }

                    Text(profile)
                        .font(.system(size: 14))
                        .frame(height: 20) // Set the height of each row
                }
                }
            
                List(appos.filter { searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) }) { appo in
                    
                        //            List(appos) { appo in
                    NavigationLink(
                        destination: DescriptionView(appo: appo,
                                                     didUpdateDescription: { category in
                                                         Task {
                                                             await self.didUpdateDescription(for: appo, with: category)
                                                         }
                                                     },
                                                     didUpdateprofileName: { profileName in
                                                         Task {
                                                             await self.didUpdateprofileName(for: appo, with: profileName)
                                                         }
                                                     }
                                                    ),
                        label: {
                            HStack {
                                Text(appo.name)
                                Spacer()
                                if let category = appo.category {
                                    Text(category)
                                        .foregroundColor(.gray)
                                }
                                if let profileName = appo.profileName {
                                    Text(profileName)
                                        .foregroundColor(.gray)
                                }
                            }.font(.system(size: 14))
                                .frame(height: 20) // Set the height of each row
                                
                  
                        }
                    ).listRowBackground(Color.white)
                }
                
                .navigationTitle("Apps")
            }
        }
        .onAppear {
            Task {
                Task {
                    let recordType = "appProfiles"
                    // Create a predicate that filters records where the "category" property is equal to "Math"
                    let predicate = NSPredicate(format: "category = %@", "Nnnnn")

                    let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
                    let operation = CKQueryOperation(query: query)
                    operation.resultsLimit = 500 // Set the limit to 500 records
    //                var allRecords = [CKRecord]() // Array to hold all the fetched records
                    var newAppos = [Appo]()
                    operation.recordFetchedBlock = { record in
                            guard   let nameValue           = record["name"] as? String,
                                    let cloudkitKeyValue    = record.recordID.recordName as? String,
                                    let categoryValue       = record["category"] as? String,
                                    let profileNameValue    = record["profileName"] as? String
                            else { fatalError("didnt work") }
                            newAppos.append(Appo(cloudkitKey: cloudkitKeyValue, name: nameValue, category: categoryValue, profileName: profileNameValue))
            
                   }
                    
                    operation.queryCompletionBlock = { (cursor, error) in
                        if let error = error {
                            print("Error fetching records: \(error.localizedDescription)")
                        } else  {
                            print("things worked")
                        DispatchQueue.main.async {
                            self.appos = newAppos.sorted()
                        }

                        }
                    }
                    dbs.add(operation)
                }
                    

                
                
                
                
//                let recordType = "appProfiles"
//
//                // Create a predicate that filters records where the "category" property is equal to "Math"
//                let predicate = NSPredicate(format: "category = %@", "Nnnnn")
//
//                let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
////                let query = CKQuery(recordType: recordType, predicate: predicate)
//
//                let dbs = CKContainer(identifier: "iCloud.com.developItSolutions.StudentLogins").publicCloudDatabase
//
//                do {
//                    let records = try await dbs.perform(query, inZoneWith: nil)
//                    let newAppos = records.compactMap { record -> Appo? in
//                        guard   let nameValue           = record["name"] as? String,
//                                let cloudkitKeyValue    = record.recordID.recordName as? String,
//                                let categoryValue       = record["category"] as? String,
//                                let profileNameValue    = record["profileName"] as? String
//                        else { return nil }
//                        return Appo(cloudkitKey: cloudkitKeyValue, name: nameValue, category: categoryValue, profileName: profileNameValue)
////                        return Appx(appBundleId: bundle, name: nameValue, desc: record["description"], catg: record["category"] ?? "")
//                    }
//
//                    DispatchQueue.main.async {
//                        self.appos = newAppos.sorted()
//                    }
//
//                } catch {
//                    print("Error fetching records: \(error.localizedDescription)")
//                }
            }
        }
    }
    
    fileprivate func updateAddRecUsing(theID recordID: CKRecord.ID, withCategory category: String) async {
        do {
            let records = try await dbs.records(for: [recordID])
            let firstResult = records.first?.value
            guard let firstRecord = try firstResult?.get() else { fatalError("couldnt do it") }
            firstRecord["category"] = category
            let savedRecord = try await dbs.save(firstRecord)
        } catch {
            print("Error fetching records: \(error.localizedDescription)")
        }
    }
    
    fileprivate func updateAddRecUsing(theID recordID: CKRecord.ID, withprofileName profileName: String) async {
        do {
            let records = try await dbs.records(for: [recordID])
            let firstResult = records.first?.value
            guard let firstRecord = try firstResult?.get() else { fatalError("couldnt do it") }
            firstRecord["profileName"] = profileName
            let savedRecord = try await dbs.save(firstRecord)
        } catch {
            print("Error fetching records: \(error.localizedDescription)")
        }
    }
    

    
    func didUpdateDescription(for appo: Appo, with category: String) async {
        if let index = appos.firstIndex(where: { $0.id == appo.id }) {
            if appos[index].category != category {
                appos[index].category = category
                let theId = CKRecord.ID(recordName: appo.cloudkitKey)
                await updateAddRecUsing(theID: theId, withCategory: category)
                DispatchQueue.main.async {
//                    showAlert(for: appo)
                }
                
            }
        }
    }
    
    func didUpdateprofileName(for appo: Appo, with profileName: String) async {
        if let index = appos.firstIndex(where: { $0.id == appo.id }) {
            if appos[index].profileName != profileName {
                appos[index].profileName = profileName
                let theId = CKRecord.ID(recordName: appo.cloudkitKey)
                await updateAddRecUsing(theID: theId, withprofileName: profileName)
                DispatchQueue.main.async {
//                    showAlert(for: appo)
                }
                
            }
        }
    }

    
    
    func showAlert(for appo: Appo) {
        let alert = UIAlertController(title: "category or profilename Updated", message: "\(appo.name)'s category or profile has been updated.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
}

struct DescriptionView: View {
    
    @EnvironmentObject var appWork: AppWork
    
    @State private var category: String
    @State private var profileName: String
    private let originalDescription: String
    private let originalprofileName: String
    var appo: Appo
    var didUpdateDescription: (String) -> Void
    var didUpdateprofileName: (String) -> Void

    
    init(appo: Appo, didUpdateDescription: @escaping (String) -> Void, didUpdateprofileName: @escaping (String) -> Void) {
        self.appo = appo
        self._category = State(initialValue: appo.category ?? "")
        self._profileName = State(initialValue: appo.profileName ?? "")
        self.originalDescription = appo.category ?? ""
        self.originalprofileName = appo.profileName ?? ""
        self.didUpdateDescription = didUpdateDescription
        self.didUpdateprofileName = didUpdateprofileName

    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    Button {
                        print(appWork.selectedProfileFromList)
                        profileName = appWork.selectedProfileFromList
                    } label: {
                        Text("do profile")
                    }
                    Button {
                        category = "Pre Writing"
                    } label: {
                        Text("Pre Writing")
                    }
                    Button {
                        category = "Reading"
                    } label: {
                        Text("Reading")
                    }
                    Button {
                        category = "Alphabet"
                    } label: {
                        Text("Alphabet")
                    }
                    Button {
                        category = "Cognition"
                    } label: {
                        Text("Cognition")
                    }
                    Button {
                        category = "Creativity"
                    } label: {
                        Text("Creativity")
                    }
                    Button {
                        category = "Curricula"
                    } label: {
                        Text("Curricula")
                    }
                    Button {
                        category = "Mathematics"
                    } label: {
                        Text("Mathematics")
                    }
                    Button {
                        category = "Curricula"
                    } label: {
                        Text("Curricula")
                    }
 
                }
            }
            Text(appo.name)
                .font(.title)
                .padding(.bottom)
            TextEditor(text: $category)
                .padding()
            TextEditor(text: $profileName)
                .padding()
        }
        .onDisappear {
            if self.category != self.originalDescription {
                // Save the category if it has changed
                didUpdateDescription(category)
            }
            if self.profileName != self.originalprofileName {
                didUpdateprofileName(profileName)
            }
        }
    }
}

struct PersonListView_Previews: PreviewProvider {
    static var previews: some View {
        PersonListView()
    }
}
