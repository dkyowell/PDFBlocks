/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

private struct Document: Block {
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
                    .font(size: 12)
                    .bold()
                TableColumnTitles()
            } footer: { _, _ in
                HGrid(columnCount: 3, columnSpacing: .in(0.5), rowSpacing: .in(1), allowPageWrap: true) {
                    Text("A")
                    Text("B")
                    Text("C")
                    Text("D")
                    Text("E")
                    Text("F")
                    Text("G")
                    Text("H")
                    Text("I")
                    Text("J")
                    Text("K")
                }
                .font(size: 48)
                .padding(.vertical, .in(1))
//                Divider(thickness: .pt(0.75), padding: .pt(2))
//                Text("\(rows.count) records for \(stateName(abberviation: value))")
//                    .bold()
//                    .padding(.leading, .max)
            }
        } header: {} pageHeader: { pageNo in
            HStack {
                Text("Page \(pageNo)")
                    .padding(.trailing, .max)
                Text("Donor List")
                    .padding(.horizontal, .max)
                    .font(size: 12)
                    .bold()
                Text(Date(), format: .mmddyy)
                    .padding(.leading, .max)
            }
            .padding(.bottom, .pt(9))
            if pageNo > 1 {
                TableColumnTitles()
            }
        }
    }
}

private func stateName(abberviation: String) -> String {
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

#if os(iOS) || os(macOS)
    import PDFKit

    #Preview {
        print("\n>>>>")
        let view = PDFView()
        view.autoScales = true
        Task {
            if let data = try? await Document(data: loadData(CustomerData.self, from: customerData))
                .renderPDF(size: .letter, margins: .init(.in(1)))
            {
                view.document = PDFDocument(data: data)
            }
        }
        return view
    }
#endif

private struct CustomerData: Decodable {
    let firstName: String
    let lastName: String
    let address: String
    let city: String
    let state: String
    let zip: String
    let dob: Date
}

private let customerData = """
[
  {
    "dob": "1980-12-23T07:59:10.728Z",
    "zip": "77698",
    "city": "Geyserville",
    "state": "CA",
    "address": "771 Kimball Street",
    "lastName": "Frazier",
    "firstName": "Francis"
  },
  {
    "dob": "1995-11-08T02:48:50.492Z",
    "zip": "78769",
    "city": "Alafaya",
    "state": "CA",
    "address": "232 Everit Street",
    "lastName": "Harrell",
    "firstName": "Leticia"
  },
  {
    "dob": "1989-09-11T18:27:23.951Z",
    "zip": "75809",
    "city": "Greensburg",
    "state": "TX",
    "address": "231 Pierrepont Place",
    "lastName": "Jacobs",
    "firstName": "Barrett"
  },
  {
    "dob": "1950-10-28T14:24:32.226Z",
    "zip": "75592",
    "city": "Tryon",
    "state": "NY",
    "address": "186 Berkeley Place",
    "lastName": "Moreno",
    "firstName": "Roberson"
  },
  {
    "dob": "1985-01-24T13:19:43.807Z",
    "zip": "76348",
    "city": "Dowling",
    "state": "CA",
    "address": "384 Belmont Avenue",
    "lastName": "Gomez",
    "firstName": "Conrad"
  },
  {
    "dob": "1960-10-05T03:43:45.296Z",
    "zip": "76356",
    "city": "Wattsville",
    "state": "TX",
    "address": "546 Adelphi Street",
    "lastName": "Monroe",
    "firstName": "Emma"
  },
  {
    "dob": "1995-04-04T05:02:12.585Z",
    "zip": "78408",
    "city": "Onton",
    "state": "TX",
    "address": "86 Cranberry Street",
    "lastName": "Summers",
    "firstName": "Barlow"
  },
  {
    "dob": "1993-02-13T04:16:35.833Z",
    "zip": "77166",
    "city": "Edneyville",
    "state": "CA",
    "address": "375 Buffalo Avenue",
    "lastName": "Delaney",
    "firstName": "Kristy"
  },
  {
    "dob": "1961-01-30T23:58:01.455Z",
    "zip": "78049",
    "city": "Morningside",
    "state": "CA",
    "address": "917 Beekman Place",
    "lastName": "Finch",
    "firstName": "Valdez"
  },
  {
    "dob": "1981-03-05T22:27:52.856Z",
    "zip": "75819",
    "city": "Hegins",
    "state": "CA",
    "address": "674 Montauk Avenue",
    "lastName": "Lee",
    "firstName": "Kristen"
  },
  {
    "dob": "1971-05-24T01:46:44.149Z",
    "zip": "76303",
    "city": "Robbins",
    "state": "NY",
    "address": "37 Lenox Road",
    "lastName": "Chapman",
    "firstName": "Simone"
  },
  {
    "dob": "1987-09-05T10:32:04.547Z",
    "zip": "77060",
    "city": "Sardis",
    "state": "TX",
    "address": "307 Poplar Street",
    "lastName": "Buckley",
    "firstName": "Barnett"
  },
  {
    "dob": "2000-12-06T08:18:18.909Z",
    "zip": "76989",
    "city": "Beechmont",
    "state": "CA",
    "address": "130 Ludlam Place",
    "lastName": "Hardin",
    "firstName": "Buchanan"
  },
  {
    "dob": "1966-06-08T01:23:30.186Z",
    "zip": "78970",
    "city": "Gila",
    "state": "TX",
    "address": "144 Revere Place",
    "lastName": "Cunningham",
    "firstName": "Ruby"
  },
  {
    "dob": "1957-11-20T14:49:47.741Z",
    "zip": "75800",
    "city": "Hendersonville",
    "state": "TX",
    "address": "554 Ellery Street",
    "lastName": "Nelson",
    "firstName": "Isabel"
  },
  {
    "dob": "1996-11-28T07:46:53.445Z",
    "zip": "77246",
    "city": "Summerset",
    "state": "TX",
    "address": "281 Douglass Street",
    "lastName": "Bailey",
    "firstName": "Beulah"
  },
  {
    "dob": "1975-04-30T06:56:31.322Z",
    "zip": "75525",
    "city": "Taft",
    "state": "CA",
    "address": "917 Rochester Avenue",
    "lastName": "Richmond",
    "firstName": "Gloria"
  },
  {
    "dob": "1951-08-15T10:51:28.097Z",
    "zip": "78320",
    "city": "Lumberton",
    "state": "CA",
    "address": "959 Louise Terrace",
    "lastName": "Morris",
    "firstName": "Terry"
  },
  {
    "dob": "1972-04-09T14:20:51.825Z",
    "zip": "75509",
    "city": "Fairview",
    "state": "TX",
    "address": "983 Oxford Street",
    "lastName": "Justice",
    "firstName": "Torres"
  },
  {
    "dob": "1983-06-28T19:23:06.667Z",
    "zip": "76214",
    "city": "Bangor",
    "state": "CA",
    "address": "849 Degraw Street",
    "lastName": "Fernandez",
    "firstName": "Ladonna"
  },
  {
    "dob": "2000-08-22T09:04:26.686Z",
    "zip": "78138",
    "city": "Dale",
    "state": "CA",
    "address": "328 Moultrie Street",
    "lastName": "Fitzpatrick",
    "firstName": "Sloan"
  },
  {
    "dob": "1985-11-12T04:56:36.944Z",
    "zip": "76776",
    "city": "Smock",
    "state": "NY",
    "address": "210 Underhill Avenue",
    "lastName": "Marquez",
    "firstName": "Wade"
  },
  {
    "dob": "1953-07-18T22:01:16.162Z",
    "zip": "78139",
    "city": "Muse",
    "state": "CA",
    "address": "513 Monroe Place",
    "lastName": "Cotton",
    "firstName": "Vance"
  },
  {
    "dob": "1999-06-24T07:33:25.955Z",
    "zip": "77885",
    "city": "Datil",
    "state": "CA",
    "address": "312 Garnet Street",
    "lastName": "Head",
    "firstName": "Janice"
  },
  {
    "dob": "1962-04-21T22:40:21.315Z",
    "zip": "75914",
    "city": "Ernstville",
    "state": "NY",
    "address": "336 Pooles Lane",
    "lastName": "Ratliff",
    "firstName": "Jacquelyn"
  },
  {
    "dob": "1952-01-28T17:33:46.682Z",
    "zip": "75256",
    "city": "Sanford",
    "state": "TX",
    "address": "632 Debevoise Avenue",
    "lastName": "Fulton",
    "firstName": "Mayer"
  },
  {
    "dob": "1969-02-04T14:20:56.455Z",
    "zip": "78578",
    "city": "Dubois",
    "state": "NY",
    "address": "807 Garland Court",
    "lastName": "Osborn",
    "firstName": "Claudia"
  },
  {
    "dob": "1983-04-19T08:48:43.243Z",
    "zip": "77041",
    "city": "Eagletown",
    "state": "NY",
    "address": "226 Dahlgreen Place",
    "lastName": "Boyer",
    "firstName": "Patricia"
  },
  {
    "dob": "1983-07-24T03:51:54.286Z",
    "zip": "78444",
    "city": "Mammoth",
    "state": "TX",
    "address": "877 Robert Street",
    "lastName": "Molina",
    "firstName": "Blackburn"
  },
  {
    "dob": "1960-11-20T16:46:12.473Z",
    "zip": "78445",
    "city": "Wheaton",
    "state": "NY",
    "address": "427 Rutland Road",
    "lastName": "Koch",
    "firstName": "Effie"
  },
  {
    "dob": "1967-02-18T23:39:31.981Z",
    "zip": "76708",
    "city": "Noxen",
    "state": "NY",
    "address": "620 Hunts Lane",
    "lastName": "Delgado",
    "firstName": "Winters"
  },
  {
    "dob": "1990-04-08T21:28:50.504Z",
    "zip": "78896",
    "city": "Hamilton",
    "state": "CA",
    "address": "110 Merit Court",
    "lastName": "Glover",
    "firstName": "Williamson"
  },
  {
    "dob": "1956-02-14T22:55:16.144Z",
    "zip": "78270",
    "city": "Brooktrails",
    "state": "CA",
    "address": "802 Townsend Street",
    "lastName": "Best",
    "firstName": "Lambert"
  },
  {
    "dob": "1988-11-22T18:37:11.505Z",
    "zip": "78779",
    "city": "Brewster",
    "state": "TX",
    "address": "671 Heath Place",
    "lastName": "Guy",
    "firstName": "Bush"
  },
  {
    "dob": "1992-02-22T10:32:19.213Z",
    "zip": "78999",
    "city": "Cannondale",
    "state": "CA",
    "address": "931 Scholes Street",
    "lastName": "Barrett",
    "firstName": "Regina"
  },
  {
    "dob": "1992-12-15T08:02:17.680Z",
    "zip": "76907",
    "city": "Sims",
    "state": "CA",
    "address": "629 Oriental Boulevard",
    "lastName": "Miller",
    "firstName": "Carmela"
  },
  {
    "dob": "1974-05-04T01:30:08.451Z",
    "zip": "77417",
    "city": "Evergreen",
    "state": "TX",
    "address": "882 Lewis Place",
    "lastName": "Jordan",
    "firstName": "Mason"
  },
  {
    "dob": "1960-10-02T19:57:03.871Z",
    "zip": "78327",
    "city": "Brownsville",
    "state": "CA",
    "address": "842 Maple Avenue",
    "lastName": "Freeman",
    "firstName": "Emily"
  },
  {
    "dob": "1961-09-30T09:20:43.294Z",
    "zip": "76618",
    "city": "Harrison",
    "state": "TX",
    "address": "238 Fair Street",
    "lastName": "Carroll",
    "firstName": "Kristi"
  },
  {
    "dob": "1990-04-28T14:48:43.339Z",
    "zip": "77012",
    "city": "Barstow",
    "state": "CA",
    "address": "746 Suydam Place",
    "lastName": "Mccarty",
    "firstName": "Morris"
  },
  {
    "dob": "1971-02-23T13:59:21.724Z",
    "zip": "78991",
    "city": "Keller",
    "state": "TX",
    "address": "272 Withers Street",
    "lastName": "Howe",
    "firstName": "Young"
  },
  {
    "dob": "1964-11-18T03:21:16.085Z",
    "zip": "75304",
    "city": "Ada",
    "state": "CA",
    "address": "649 Clifton Place",
    "lastName": "Haney",
    "firstName": "Hartman"
  },
  {
    "dob": "1996-11-23T08:21:47.579Z",
    "zip": "75504",
    "city": "Takilma",
    "state": "TX",
    "address": "385 Raleigh Place",
    "lastName": "Swanson",
    "firstName": "Violet"
  },
  {
    "dob": "1962-10-28T01:04:40.222Z",
    "zip": "78947",
    "city": "Winston",
    "state": "TX",
    "address": "922 Kossuth Place",
    "lastName": "Salazar",
    "firstName": "Stella"
  },
  {
    "dob": "1979-05-02T10:25:16.231Z",
    "zip": "77321",
    "city": "Leyner",
    "state": "NY",
    "address": "576 Kane Place",
    "lastName": "Wolfe",
    "firstName": "Reese"
  },
  {
    "dob": "1977-06-16T09:48:23.267Z",
    "zip": "78345",
    "city": "Brandywine",
    "state": "CA",
    "address": "346 Aviation Road",
    "lastName": "Horton",
    "firstName": "Mclean"
  },
  {
    "dob": "1996-04-17T13:14:26.328Z",
    "zip": "75596",
    "city": "Disautel",
    "state": "CA",
    "address": "905 Argyle Road",
    "lastName": "Mcfadden",
    "firstName": "English"
  },
  {
    "dob": "1971-05-15T05:46:54.382Z",
    "zip": "77351",
    "city": "Leland",
    "state": "CA",
    "address": "164 Olive Street",
    "lastName": "Bowman",
    "firstName": "Cash"
  },
  {
    "dob": "1993-06-01T17:43:41.544Z",
    "zip": "76990",
    "city": "Stollings",
    "state": "TX",
    "address": "702 Evans Street",
    "lastName": "Pearson",
    "firstName": "Lindsey"
  },
  {
    "dob": "1988-09-16T12:53:42.972Z",
    "zip": "77467",
    "city": "Coral",
    "state": "CA",
    "address": "34 Dahl Court",
    "lastName": "Landry",
    "firstName": "Jacklyn"
  },
  {
    "dob": "1984-08-05T20:23:40.005Z",
    "zip": "77760",
    "city": "Canterwood",
    "state": "TX",
    "address": "780 Lincoln Road",
    "lastName": "Woods",
    "firstName": "Stuart"
  },
  {
    "dob": "1978-10-29T15:14:47.396Z",
    "zip": "77551",
    "city": "Oneida",
    "state": "NY",
    "address": "475 Franklin Street",
    "lastName": "Pacheco",
    "firstName": "Suzanne"
  },
  {
    "dob": "1997-08-07T14:47:42.330Z",
    "zip": "75159",
    "city": "Lowgap",
    "state": "TX",
    "address": "786 Louisa Street",
    "lastName": "Morrison",
    "firstName": "Sykes"
  },
  {
    "dob": "1998-09-24T08:42:19.476Z",
    "zip": "76907",
    "city": "Ryderwood",
    "state": "CA",
    "address": "799 Karweg Place",
    "lastName": "Burton",
    "firstName": "Park"
  },
  {
    "dob": "1975-12-14T01:04:49.290Z",
    "zip": "78942",
    "city": "Waikele",
    "state": "NY",
    "address": "117 Grattan Street",
    "lastName": "Cross",
    "firstName": "Christy"
  },
  {
    "dob": "1997-03-28T03:02:36.445Z",
    "zip": "77616",
    "city": "Chapin",
    "state": "NY",
    "address": "555 Hastings Street",
    "lastName": "Hernandez",
    "firstName": "Tania"
  },
  {
    "dob": "1966-03-20T19:39:27.534Z",
    "zip": "77986",
    "city": "Kingstowne",
    "state": "CA",
    "address": "429 Lake Avenue",
    "lastName": "Russell",
    "firstName": "Duke"
  },
  {
    "dob": "1992-11-11T20:59:30.607Z",
    "zip": "75140",
    "city": "Delshire",
    "state": "NY",
    "address": "1000 Bayview Avenue",
    "lastName": "Goff",
    "firstName": "Norman"
  },
  {
    "dob": "2001-03-22T19:59:51.430Z",
    "zip": "78590",
    "city": "Faywood",
    "state": "CA",
    "address": "162 Loring Avenue",
    "lastName": "Meyer",
    "firstName": "Robertson"
  },
  {
    "dob": "1950-02-03T16:21:44.743Z",
    "zip": "77960",
    "city": "Websterville",
    "state": "NY",
    "address": "44 Jamaica Avenue",
    "lastName": "Bender",
    "firstName": "Hazel"
  },
  {
    "dob": "1964-10-12T05:15:52.628Z",
    "zip": "75137",
    "city": "Linwood",
    "state": "TX",
    "address": "692 Desmond Court",
    "lastName": "Mathis",
    "firstName": "Walters"
  },
  {
    "dob": "1998-03-23T09:27:08.534Z",
    "zip": "76347",
    "city": "Sharon",
    "state": "NY",
    "address": "350 Kent Street",
    "lastName": "Cook",
    "firstName": "Pamela"
  },
  {
    "dob": "1979-11-09T21:23:06.849Z",
    "zip": "75798",
    "city": "Cotopaxi",
    "state": "TX",
    "address": "723 Luquer Street",
    "lastName": "Rutledge",
    "firstName": "Myra"
  },
  {
    "dob": "1955-11-04T05:34:46.526Z",
    "zip": "77766",
    "city": "Roland",
    "state": "CA",
    "address": "485 Cooper Street",
    "lastName": "Bauer",
    "firstName": "Sheryl"
  },
  {
    "dob": "1976-08-12T23:41:04.454Z",
    "zip": "76255",
    "city": "Edinburg",
    "state": "CA",
    "address": "293 Delevan Street",
    "lastName": "Sanford",
    "firstName": "Solis"
  },
  {
    "dob": "1997-04-22T12:21:00.766Z",
    "zip": "75077",
    "city": "Wakulla",
    "state": "NY",
    "address": "290 Denton Place",
    "lastName": "Prince",
    "firstName": "Kimberly"
  },
  {
    "dob": "1999-09-24T20:53:53.159Z",
    "zip": "75556",
    "city": "Cliffside",
    "state": "CA",
    "address": "201 Bushwick Court",
    "lastName": "Merrill",
    "firstName": "Saundra"
  },
  {
    "dob": "1993-10-15T16:55:08.731Z",
    "zip": "75483",
    "city": "Norfolk",
    "state": "NY",
    "address": "956 Dover Street",
    "lastName": "Banks",
    "firstName": "Klein"
  },
  {
    "dob": "1996-11-09T00:09:07.021Z",
    "zip": "78014",
    "city": "Juarez",
    "state": "TX",
    "address": "894 Bergen Court",
    "lastName": "Nieves",
    "firstName": "Maxine"
  },
  {
    "dob": "1986-12-30T08:41:53.426Z",
    "zip": "76050",
    "city": "Southmont",
    "state": "NY",
    "address": "235 Herkimer Court",
    "lastName": "Nixon",
    "firstName": "Jan"
  },
  {
    "dob": "2002-11-15T12:00:48.784Z",
    "zip": "77454",
    "city": "Lopezo",
    "state": "NY",
    "address": "101 Pine Street",
    "lastName": "Bonner",
    "firstName": "Ida"
  },
  {
    "dob": "1972-08-27T01:44:50.778Z",
    "zip": "75904",
    "city": "Holcombe",
    "state": "TX",
    "address": "631 Tennis Court",
    "lastName": "Bush",
    "firstName": "Hester"
  },
  {
    "dob": "1989-06-23T05:28:59.281Z",
    "zip": "78294",
    "city": "Brandermill",
    "state": "NY",
    "address": "973 Russell Street",
    "lastName": "Peters",
    "firstName": "Deirdre"
  },
  {
    "dob": "1953-04-02T00:48:40.534Z",
    "zip": "76900",
    "city": "Gorham",
    "state": "NY",
    "address": "175 Autumn Avenue",
    "lastName": "Owens",
    "firstName": "Lee"
  },
  {
    "dob": "1958-05-12T03:20:15.637Z",
    "zip": "77268",
    "city": "Hartsville/Hartley",
    "state": "CA",
    "address": "258 Howard Alley",
    "lastName": "Evans",
    "firstName": "Tricia"
  },
  {
    "dob": "1968-05-17T20:36:58.331Z",
    "zip": "75779",
    "city": "Shawmut",
    "state": "TX",
    "address": "56 Mersereau Court",
    "lastName": "Schneider",
    "firstName": "Luna"
  },
  {
    "dob": "1964-05-07T08:23:05.733Z",
    "zip": "78498",
    "city": "Norvelt",
    "state": "CA",
    "address": "245 Perry Place",
    "lastName": "Graves",
    "firstName": "Martin"
  },
  {
    "dob": "1976-07-28T20:38:35.530Z",
    "zip": "77476",
    "city": "Masthope",
    "state": "CA",
    "address": "95 Everett Avenue",
    "lastName": "Arnold",
    "firstName": "Trudy"
  },
  {
    "dob": "1994-09-10T00:21:19.680Z",
    "zip": "76017",
    "city": "Monument",
    "state": "TX",
    "address": "979 Anna Court",
    "lastName": "Erickson",
    "firstName": "Abigail"
  },
  {
    "dob": "1978-02-21T13:59:11.605Z",
    "zip": "78149",
    "city": "Tedrow",
    "state": "CA",
    "address": "793 Berriman Street",
    "lastName": "Mcgee",
    "firstName": "Dyer"
  },
  {
    "dob": "1988-11-15T02:15:59.785Z",
    "zip": "75059",
    "city": "Emerald",
    "state": "CA",
    "address": "5 Amherst Street",
    "lastName": "Rodgers",
    "firstName": "Ronda"
  },
  {
    "dob": "1996-11-23T12:00:15.094Z",
    "zip": "75823",
    "city": "Joes",
    "state": "NY",
    "address": "662 Taylor Street",
    "lastName": "Frank",
    "firstName": "Ray"
  },
  {
    "dob": "1976-09-21T12:56:30.972Z",
    "zip": "76812",
    "city": "Loomis",
    "state": "CA",
    "address": "221 Amity Street",
    "lastName": "Cole",
    "firstName": "Barbra"
  },
  {
    "dob": "1989-12-01T22:19:30.996Z",
    "zip": "75652",
    "city": "Camino",
    "state": "TX",
    "address": "658 Lawn Court",
    "lastName": "Lloyd",
    "firstName": "Victoria"
  },
  {
    "dob": "1978-07-21T06:55:15.808Z",
    "zip": "78152",
    "city": "Mathews",
    "state": "TX",
    "address": "227 Baltic Street",
    "lastName": "George",
    "firstName": "Neal"
  },
  {
    "dob": "1987-10-05T03:35:29.765Z",
    "zip": "77855",
    "city": "Grazierville",
    "state": "NY",
    "address": "550 Newkirk Avenue",
    "lastName": "Obrien",
    "firstName": "Rasmussen"
  },
  {
    "dob": "2002-12-16T05:46:39.613Z",
    "zip": "77959",
    "city": "Bannock",
    "state": "NY",
    "address": "534 Thames Street",
    "lastName": "Malone",
    "firstName": "Cecilia"
  },
  {
    "dob": "1950-03-29T01:15:35.053Z",
    "zip": "75277",
    "city": "Chestnut",
    "state": "NY",
    "address": "417 Winthrop Street",
    "lastName": "Mclean",
    "firstName": "Rochelle"
  },
  {
    "dob": "1957-01-25T17:08:35.656Z",
    "zip": "75589",
    "city": "Nescatunga",
    "state": "TX",
    "address": "785 Bridge Street",
    "lastName": "Case",
    "firstName": "Pollard"
  },
  {
    "dob": "1976-02-25T02:56:33.135Z",
    "zip": "78595",
    "city": "Nelson",
    "state": "CA",
    "address": "770 Hoyt Street",
    "lastName": "Mcpherson",
    "firstName": "Kelley"
  },
  {
    "dob": "1994-12-27T02:11:55.717Z",
    "zip": "77821",
    "city": "Valle",
    "state": "TX",
    "address": "857 Horace Court",
    "lastName": "Gould",
    "firstName": "Kaitlin"
  },
  {
    "dob": "1989-08-26T03:45:01.364Z",
    "zip": "75800",
    "city": "Aguila",
    "state": "TX",
    "address": "954 Stryker Court",
    "lastName": "Byrd",
    "firstName": "Lydia"
  },
  {
    "dob": "1963-08-13T00:18:35.323Z",
    "zip": "76581",
    "city": "Romeville",
    "state": "NY",
    "address": "316 Harbor Lane",
    "lastName": "Duke",
    "firstName": "Edwina"
  },
  {
    "dob": "1980-07-08T14:53:53.531Z",
    "zip": "77125",
    "city": "Harold",
    "state": "TX",
    "address": "894 Bouck Court",
    "lastName": "Patton",
    "firstName": "Barr"
  },
  {
    "dob": "1972-02-16T10:35:41.958Z",
    "zip": "77668",
    "city": "Soham",
    "state": "TX",
    "address": "902 Cadman Plaza",
    "lastName": "Harmon",
    "firstName": "Nettie"
  },
  {
    "dob": "1984-02-27T20:21:18.053Z",
    "zip": "78880",
    "city": "Cetronia",
    "state": "TX",
    "address": "176 Schenck Street",
    "lastName": "Meyers",
    "firstName": "Meadows"
  },
  {
    "dob": "1966-05-18T21:57:24.058Z",
    "zip": "77128",
    "city": "Goochland",
    "state": "NY",
    "address": "457 Farragut Place",
    "lastName": "Sheppard",
    "firstName": "Kari"
  },
  {
    "dob": "1967-08-16T08:12:40.303Z",
    "zip": "75552",
    "city": "Deputy",
    "state": "TX",
    "address": "509 Arkansas Drive",
    "lastName": "Buchanan",
    "firstName": "Kaye"
  },
  {
    "dob": "1987-10-23T10:53:40.000Z",
    "zip": "77214",
    "city": "Bordelonville",
    "state": "TX",
    "address": "62 Greenwood Avenue",
    "lastName": "Hebert",
    "firstName": "White"
  },
  {
    "dob": "1980-06-13T21:12:53.881Z",
    "zip": "77206",
    "city": "Worton",
    "state": "CA",
    "address": "974 Belvidere Street",
    "lastName": "Logan",
    "firstName": "Tamara"
  }
]
"""
