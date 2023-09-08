//
//  EventModalView.swift
//  ATLAS
//
//  Created by phuong phan on 07/09/2023.
//

import SwiftUI

struct EventModalView: View {
    @Binding var showModal: Bool
    @State private var selectedEvent = EventDataDropDown.flight
    @State private var selectedReminder = ReminderDataDropDown.before
    
    @State var tfEventName: String = ""
    @State private var isAllDay = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button(action: {
                        self.showModal.toggle()
                    }) {
                        Text("Cancel").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                    }

                    Spacer()

                    Text("Add Event").foregroundColor(.black).font(.system(size: 17, weight: .semibold))

                    Spacer()

                    Button(action: {
                        //TODO
                    }) {
                        Text("Done").foregroundColor(Color.theme.azure).font(.system(size: 17, weight: .regular))
                    }
                }
                .padding()
                .background(.white)

                Rectangle().fill(.black.opacity(0.3)).frame(height: 1)
            }

            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Event Type")

                        Picker("", selection: $selectedEvent) {
                            ForEach(EventDataDropDown.allCases, id: \.self) {
                                Text($0.rawValue).tag($0.rawValue)
                            }
                        }.pickerStyle(MenuPickerStyle())
                    }

                    TextField("Enter Name of Event", text: $tfEventName)
                        .font(.system(size: 15)).frame(maxWidth: .infinity)
                        .padding(.vertical)

                    Grid(alignment: .topLeading) {
                        GridRow {
                            Text("Start").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                            Text("End").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                            Text("All Day").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                        }.frame(maxWidth: .infinity, alignment: .leading)

                        Divider()

                        GridRow {
                            Text("DD/MM/YY HHMM").foregroundColor(Color.black).font(.system(size: 15, weight: .regular)).frame(alignment: .leading)
                            Text("DD/MM/YY HHMM").foregroundColor(Color.black).font(.system(size: 15, weight: .regular)).frame(alignment: .leading)
                            Toggle("", isOn: $isAllDay).fixedSize().frame(alignment: .leading)
                        }.frame(maxWidth: .infinity, alignment: .leading).padding(.bottom)

                        GridRow {
                            Text("Location").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                        }.frame(maxWidth: .infinity, alignment: .leading)

                        Divider().padding(.horizontal, -16)

                        GridRow {
                            Text("XXXXXXXXX").foregroundColor(Color.black).font(.system(size: 15, weight: .regular)).frame(alignment: .leading)
                        }.frame(maxWidth: .infinity, alignment: .leading).padding(.bottom)
                    }.frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("People").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))

                            Spacer()

                            Button(action: {

                            }, label: {
                                Text("Invite")
                            }).buttonStyle(PlainButtonStyle())

                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 8)

                        Divider().padding(.horizontal, -16)

                        TextField("Add other Atlas users to this flight", text: $tfEventName)
                            .font(.system(size: 15)).frame(maxWidth: .infinity)
                            .padding(.vertical)
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Reminders").foregroundColor(Color.black).font(.system(size: 15, weight: .semibold))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 8)

                        Divider().padding(.horizontal, -16)

                        Picker("", selection: $selectedReminder) {
                            ForEach(ReminderDataDropDown.allCases, id: \.self) {
                                Text($0.rawValue).tag($0.rawValue)
                            }
                        }.pickerStyle(MenuPickerStyle())
                    }

                }// End VStack
                .padding()

            }// End VStack
            .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(.white))
                .cornerRadius(8)
                .padding()

            Spacer()
        }
        .background(Color.theme.antiFlashWhite)
    }
}

struct EventModalView_Previews: PreviewProvider {
    static var previews: some View {
        EventModalView(showModal: .constant(true))
    }
}
