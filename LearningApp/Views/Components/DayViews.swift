import SwiftUI

/// One day number. Learned = orange, Frozen = blue, today with no log = solid orange.
struct DayCircle: View {
    let date: Date
    let status: DayStatus?
    let isToday: Bool
    var size: CGFloat = 44

    private var fillColor: Color {
        switch status {
        case .some(.learned): return Theme.orangeDim
        case .some(.frozen):  return Theme.blueDim
        case .none:           return isToday ? Theme.orange : Color.clear
        }
    }

    private var textColor: Color {
        switch status {
        case .some(.learned): return Theme.orange
        case .some(.frozen):  return Theme.blue
        case .none:           return Color.white
        }
    }

    var body: some View {
        Text("\(Calendar.app.component(.day, from: date))")
            .font(.system(size: 20))
            .foregroundStyle(textColor)
            .frame(width: size, height: size)
            .background(Circle().fill(fillColor))
    }
}

struct WeekStrip: View {
    let days: [WeekDay]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(days) { day in
                VStack(spacing: 8) {
                    Text(Formats.weekdayLetter.string(from: day.date))
                        .font(.system(size: 13, weight: .semibold))
                    DayCircle(date: day.date, status: day.status, isToday: day.isToday)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
