//
// EnumerationView.swift
//
// Created by Andreas in 2020
//

#if canImport(SwiftUI)

import SwiftUI

struct EnumerationView<Content: Sequence>: View where Content.Element: View {

    let content: Content

    init(@SequenceBuilder builder: () -> Content) {
        self.content = builder()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(sequence: content) { (index, content) in
                HStack(alignment: .top) {
                    Text("\(index + 1). ")
                    content
                }
            }
        }
    }
}

struct EnumerationView_Previews: PreviewProvider {
    static var previews: some View {
        EnumerationView {
            Text("Some text")
            VStack {
                ForEach(0..<10, id: \.self) { _ in
                    Text("Lorem ipsum dolet.")
                }
            }
            if true {
                Text("More text")
                Text("Enough text")
            }
            HStack {
                Text("With image:")
                Image(systemName: "checkmark")
            }
            Text("The ending")
        }
        .padding()
    }
}

#endif
