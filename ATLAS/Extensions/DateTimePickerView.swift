//
//  DateTimePickerView.swift
//  ATLAS
//
//  Created by phuong phan on 25/07/2023.
//

import Foundation
import SwiftUI

struct WheelTimePickerView: UIViewRepresentable {
    @Binding var selection: Date
    var range: ClosedRange<Date>

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker(frame: .zero)
        
        picker.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .dateAndTime
        picker.minimumDate = range.lowerBound
        picker.maximumDate = range.upperBound
        picker.locale = Locale(identifier: "en_GB")

        picker.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)

        return picker
    }

    func updateUIView(_ uiDatePicker: UIDatePicker, context: Context) {
        uiDatePicker.date = selection
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject {
        var wheelTimePickerView: WheelTimePickerView

        init(_ wheelTimePickerView: WheelTimePickerView) {
            self.wheelTimePickerView = wheelTimePickerView
        }

        @objc func changed(_ sender: UIDatePicker) {
            print("sender.date======\(sender.date)")
            let hour = Calendar.current.component(.hour, from: sender.date)
            print("hour======\(hour)")
            self.wheelTimePickerView.selection = sender.date
        }
    }
}
