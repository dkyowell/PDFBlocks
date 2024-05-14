/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation
import PDFBlocks
import PDFKit

private struct ExampleColumns4: Block {
    var body: some Block {
        Columns(count: 3, spacing: 16, wrapping: true) {
            Text(speech)
        }
        .fontDesign(.serif)
        .fontSize(22)
    }
}

#Preview {
    previewForDocument(ExampleColumns4())
}


private let speech =
    """
    Five score years ago, a great American, in whose symbolic shadow we stand today, signed the Emancipation Proclamation. This momentous decree came as a great beacon light of hope to millions of Negro slaves  who had been seared in the flames of withering injustice. It came as a joyous daybreak to end the long night of their captivity.

    But one hundred years later, the Negro still is not free. One hundred years later, the life of the Negro is still sadly crippled by the manacles of segregation and the chains of discrimination. One hundred years later, the Negro lives on a lonely island of poverty in the midst of a vast ocean of material prosperity. One hundred years later, the Negro is still languished in the corners of American society and finds himself in exile in his own land. And so we’ve come here today to dramatize a shameful condition.

    In a sense we’ve come to our nation’s capital to cash a check. When the architects of our republic wrote the magnificent words of the Constitution and the Declaration of Independence, they were signing a promissory note to which every American was to fall heir. This note was a promise that all men, yes, black men as well as white men, would be guaranteed the unalienable rights of life, liberty, and the pursuit of happiness. It is obvious today that America has defaulted on this promissory note insofar as her citizens of color are concerned. Instead of honoring this sacred obligation, America has given the Negro people a bad check, a check which has come back marked insufficient funds.
    """
