//
//  CustomPicker.swift
//  ATLAS
//
//  Created by phuong phan on 18/09/2023.
//

import SwiftUI

struct CustomPicker: UIViewRepresentable {
    @Binding var dataArrays : [[String]]

    //makeCoordinator()
    func makeCoordinator() -> CustomPicker.Coordinator {
        return CustomPicker.Coordinator(self)
    }

    //makeUIView(context:)
    func makeUIView(context: UIViewRepresentableContext<CustomPicker>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }

    //updateUIView(_:context:)
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<CustomPicker>) {
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: CustomPicker
        init(_ pickerView: CustomPicker) {
            self.parent = pickerView
        }

        //Number Of Components:
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return parent.dataArrays.count
        }

        //Number Of Rows In Component:
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.dataArrays[component].count
        }

        //Width for component:
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return UIScreen.main.bounds.width/3
        }

        //Row height:
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 60
        }

        //View for Row
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: 60))

            let pickerLabel = UILabel(frame: view.bounds)

            pickerLabel.text = parent.dataArrays[component][row]

            pickerLabel.adjustsFontSizeToFitWidth = true
            pickerLabel.textAlignment = .center
            pickerLabel.lineBreakMode = .byWordWrapping
            pickerLabel.numberOfLines = 0

            view.addSubview(pickerLabel)

            view.clipsToBounds = true
            view.layer.cornerRadius = view.bounds.height * 0.1
            view.layer.borderWidth = 0.5
            view.layer.borderColor = UIColor.black.cgColor

            return view
        }
    }
}
