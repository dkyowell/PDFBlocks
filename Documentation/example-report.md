##  Report
The `Table` component is a data-oriented component that allows for the creation of simple text reports like this, or even complex bespoke layouts with graphical elements for something like company invoices. `Table` is generic over its data types, so `TableColumns` and `TableGroups` can be defined in a type-safe manner using Swift `KeyPaths`.

In this example, the table is grouped by state in alphabetical ordering. Group headers and footers are passed an array of data rows that constitute the group and can use that array for computing summary data; here, a row count is reported in the group foter. 

In this report, you will see that there is no "row print" element. That is because without an explicit `row:` parameter passed to `Table`, a default row is printed based upon the `TableColumns` definitions which define the column widths (proportionally) and a string formatter for non-string data types.

### PDF
[example-report.pdf](example-report.pdf)
### Code

```swift
struct ExampleReport: Block {
    let data: [CustomerData]

    var body: some Block {
        Table(data) {
            TableColumn("Last Name", value: \.lastName, width: 20)
            TableColumn("First Name", value: \.firstName, width: 20)
            TableColumn("Address", value: \.address, width: 35)
            TableColumn("City", value: \.city, width: 25)
            TableColumn("State", value: \.state, width: 10)
            TableColumn("Zip", value: \.zip, width: 10)
            TableColumn("DOB", value: \.dob, format: .mmddyy, width: 10, alignment: .trailing)
        } groups: {
            TableGroup(on: \.state, order: <, spacing: .pt(12)) { _, value in
                Text(stateName(abberviation: value))
                    .fontSize(12)
                    .bold()
                    .padding(.trailing, .max)
                TableColumnTitles()
            } footer: { rows, value in
                Divider(thickness: .pt(0.75), padding: .pt(2))
                Text("\(rows.count) records for \(stateName(abberviation: value))")
                    .bold()
                    .padding(.leading, .max)
            }
        } pageHeader: { pageNo in
            HStack(spacing: .flex) {
                Text("Donor Report")
                PageNumberReader { pageNo in
                    Text("Page \(pageNo)")
                }
            }
            .fontSize(12)
            .bold()
            .padding(.bottom, 12)
            if pageNo > 1 {
                TableColumnTitles()
            }
        }
        .font(.system(size: 8))
    }
}

struct CustomerData {
    let firstName: String
    let lastName: String
    let address: String
    let city: String
    let state: String
    let zip: String
    let dob: Date
}

func stateName(abberviation: String) -> String {
    switch abberviation {
    case "CA":
        "California"
    case "NY":
        "New York"
    case "TX":
        "Texas"
    default:
        "Unknown"
    }
}
```
