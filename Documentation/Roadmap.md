#  Roadmap

## Fixes
* The entire library needs to be poked and prodded to find layout problems, especially within nested layout structures.

## Roadmap
The following is a list of items that could be added. 

* URL links.
* Clickable regions within documents.
* Grids: grid layout is limited at present. I would welcome feedback as to what layout support would be useful.
* Justified `Text`. This could be done poorly easily. Using TextKit and hyphenation would give a better implementation. It seems that NSAttributedString has some support for hyphenation. Need to exlore this as it would be an easier implementation than TextKit.
* Barcodes. This is probably beyond the scope of this project and should be done with another library and used in PDFBlocks as an image.
* Charts. This is probably beyond the scope of this project and should be done with another library and used in PDFBlocks as an image.

## Longterm Goals
I would highly welcome collaboration in the following areas.
* Unit tests.
* Right to Left language support.
* This project has been designed with the possiblity of a future cross platform implementation. The iOS/macOS implementation relies upon CoreGraphics and CoreText. I believe that Skia could provide the required functionality for a true cross platform implementation.




