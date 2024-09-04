import SwiftUI

struct Sheet: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let age: Int
}

let sheets = [Sheet(name: "test", age: 10)]

struct ContentView: View {
    var body: some View {
        TabView {
            VStack {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                }
                NavigationStack {
                    List(sheets) { sheet in
                        NavigationLink(sheet.name, value: sheet)
                    }
                    .navigationDestination(for: Sheet.self) { sheet in
                        SheetView(sheet: sheet)
                    }
                }
                Section(header: Text("Drawing header").font(.headline)) {
                    NavigationStack {
                        List(sheets) { sheet in
                            NavigationLink(sheet.name, value: sheet)
                        }
                        .navigationDestination(for: Sheet.self) { sheet in
                            SheetView(sheet: sheet)
                        }
                    }
                }.padding()}.tabItem {
                    Label("Received", systemImage: "tray.and.arrow.down.fill")
                }.badge(2)
            
            SheetView(sheet: sheets[0])
                .tabItem {
                    Label("Drawing", systemImage: "pencil")
                }
            
            SheetView(sheet: sheets[0])
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
                .badge("!")
        }}
                    
    }


#Preview {
    ContentView()
}
