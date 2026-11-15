import SwiftUI

/// "Activities" screen. View only: no interaction with the calendar.
struct CalendarView: View {
    @StateObject private var vm: CalendarViewModel
    @Environment(\.dismiss) private var dismiss

    init(store: LearningStore) {
        _vm = StateObject(wrappedValue: CalendarViewModel(store: store))
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(vm.months, id: \.self) { month in
                    MonthSection(month: month, vm: vm)
                    Divider().overlay(Color.white.opacity(0.12))
                }
            }
            .padding(.horizontal, 12)
        }
        .foregroundStyle(Color.white)
        .background(Color.black.ignoresSafeArea())
        .navigationTitle(Strings.activities)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    CircleIcon(systemName: "chevron.left")
                }
            }
        }
    }
}

private struct MonthSection: View {
    let month: Date            // first day of the month
    let vm: CalendarViewModel

    private let calendar = Calendar.app
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    private var leadingBlanks: Int {
        calendar.component(.weekday, from: month) - 1      // Sunday first
    }

    private var dayCount: Int {
        calendar.range(of: .day, in: .month, for: month)?.count ?? 30
    }

    private func date(at offset: Int) -> Date {
        calendar.date(byAdding: .day, value: offset, to: month) ?? month
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Formats.month.string(from: month))
                .font(.system(size: 17, weight: .semibold))
                .padding(.horizontal, 8)

            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(Formats.weekdayHeaders, id: \.self) { name in
                    Text(name)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Theme.secondary)
                }
                ForEach(0..<leadingBlanks, id: \.self) { _ in
                    Color.clear.frame(height: 44)
                }
                ForEach(0..<dayCount, id: \.self) { offset in
                    let day = date(at: offset)
                    DayCircle(date: day,
                              status: vm.status(on: day),
                              isToday: calendar.isDateInToday(day))
                }
            }
            .allowsHitTesting(false)   // view only
        }
        .padding(.vertical, 16)
    }
}
#Preview {
    NavigationStack {
        CalendarView(store: PreviewStore.sample())
    }
    .preferredColorScheme(.dark)
}
