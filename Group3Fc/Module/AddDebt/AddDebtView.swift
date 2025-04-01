//
//  AddDebtVIew2.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 28/03/25.
//

import SwiftUI
import SwiftData

struct AddDebtView2: View {
    private enum Field: Hashable {
        case name, amount, nextDueDate, dateCreated, notes
    }
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = AddDebtViewModel()
    @FocusState private var focusedField: Field?
    @State private var refreshTrigger = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    hideKeyboard()
                }
            NavigationStack {
                List {
                    VStack {
                        HStack( spacing: 5) {
                            Text("Nama Peminjam")
                                .font(.body)
                                .foregroundStyle(ConstantColors.blueShade)
                            
                            Spacer()
                            
                            TextField("Nama", text: $viewModel.name)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.5,alignment: .trailing)
                                .multilineTextAlignment(.trailing)
                                .focused($focusedField, equals: .name)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .amount
                                }
                                .onChange(of: viewModel.name) { oldValue, newValue in
                                    if !newValue.isEmpty && newValue != oldValue {
                                        viewModel.suggestedBorrowers = viewModel.findMatchingBorrowers(for: newValue, context: context)
                                    } else {
                                        viewModel.suggestedBorrowers = []
                                    }
                                }
                        }.padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
                            .tint(ConstantColors.blueShade)
                            .frame(height: 44)
                        
                        if !viewModel.suggestedBorrowers.isEmpty && focusedField == .name {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack (){
                                    ForEach(viewModel.suggestedBorrowers, id: \.id) { borrower in
                                        Button(action: {
                                            viewModel.name = borrower.name
                                            viewModel.suggestedBorrowers = []
                                        }) {
                                            Text(borrower.name)
                                                .font(.subheadline)
                                                .padding(6)
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    HStack( spacing: 5) {
                        Text("Jumlah")
                            .font(.body)
                            .foregroundStyle(.blueShade)
                        
                        Spacer()
                        
                        TextField("Rp 0", text: $viewModel.amountText)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.5,alignment: .trailing)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .amount)
                            .keyboardType(.numberPad)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = nil
                            }
                            .onChange(of: viewModel.amountText) { _ in
                                viewModel.formatCurrencyInput()
                            }
                        
                    }.tint(ConstantColors.blueShade)
                        .frame(height: 44)
                    
                    HStack( spacing: 5) {
                        Text("Tanggal Utang")
                            .font(.body)
                            .foregroundStyle(.blueShade)
                        
                        Spacer()
                        
                        HStack (spacing: 8){
                            Image(systemName:  "calendar")
                                .foregroundStyle(ConstantColors.primary)
                                .font(.title3)
                            
                            DatePicker("",selection: $viewModel.dateCreated, displayedComponents: [.date])
                                .labelsHidden()
                                .accentColor(.blueShade)
                                .foregroundStyle(ConstantColors.blueShade)
                                .tint(ConstantColors.blueShade)
                                .submitLabel(.next)
                                .focused($focusedField, equals: .dateCreated)
                                .onTapGesture {
                                    focusedField = .dateCreated
                                }
                                .onSubmit {
                                    focusedField = .nextDueDate
                                }
                        }
                    }.frame(height: 44)
                    
                    
                    HStack( spacing: 5) {
                        Text("Tanggal Tagih")
                            .font(.body)
                            .foregroundStyle(.blueShade)
                        
                        Spacer()
                        
                        HStack (spacing: 8){
                            Image(systemName: "calendar.badge.clock")
                                .foregroundStyle(ConstantColors.primary
                                ).font(.title3)
                            
                            DatePicker("",selection: $viewModel.nextDueDate, displayedComponents: [.date])
                                .labelsHidden()
                                .accentColor(.blueShade)
                                .tint(.blueShade)
                                .submitLabel(.next)
                                .focused($focusedField, equals: .nextDueDate)
                                .onTapGesture {
                                    focusedField = .nextDueDate
                                }
                                .onSubmit {
                                    focusedField = .notes
                                }
                        }
                    }.frame(height: 44)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        TextField("Catatan",text: $viewModel.notes, axis : .vertical)
                            .frame(height: 100, alignment: .top)
                            .submitLabel(.done)
                            .focused($focusedField, equals: .notes)
                            .onTapGesture {
                                focusedField = .notes
                            }
                            .onSubmit {
                                focusedField = nil
                            }
                        
                    }
                }.padding(.top, 1)
                    .background(ConstantColors.greyBackground)
                    .scrollContentBackground(.visible)
                    .tint(ConstantColors.blueShade)
                    .navigationTitle("Tambah Utang")
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarLeading) {
                            Button(action: {
                                dismiss()
                            }) {
                                Text("Batal").font(.body).foregroundColor(.white) // Gunakan .white langsung
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                if focusedField != nil {
                                    focusedField = nil
                                }else {
                                    
                                    if !(viewModel.name.isEmpty && viewModel.amount.isZero) {
                                        viewModel.addBorrower(for: viewModel.name,
                                                              amount: viewModel.amount,
                                                              nextDueDate: viewModel.nextDueDate,
                                                              dateCreated: viewModel.dateCreated,
                                                              notes: viewModel.notes,
                                                              context: context
                                        )
                                        
                                        refreshTrigger.toggle()
                                        dismiss()
                                    } else {
                                        showAlert = true
                                    }
                                }
                            }) {
                                Text(focusedField != nil ? "Selesai" :"Simpan")
                                    .font(.body)
                                    .foregroundColor(.white)
                            }
                        }
                    }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddDebtView2()
}
