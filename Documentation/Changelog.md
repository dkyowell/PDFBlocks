#  Changelog

## v0.2.5.2
* Breaking Change: In VStack, VGrid, and Columns the wrapping: parameter is renamed to wrap:.
* Added .none and .wrap to truncationMode(:).
* Changed Text: will not truncate unless truncationMode .tail is set.
* Changed Text: will not wrap unless truncationMode .wrap is set.
* Changed Table: removed page number from pageHeader and pageFooter blocks
* Enhanced `PageNumberReader` with ability to report total pages
* Fixed Text wrap in VStack
* Fixes various layout issues

## v0.2.5.1
* Performance improvment for Text
* Breaking Change: In VStack, VGrid, and Columns the pageWrap: parameter is renamed to wrapContents:.
* Various fixes
* Moved Examples out of Sources directory

## v0.2.5
* Added gradient fill support for Text
* Added Repeat block
* Added AttributedString support for Text
* Changed .font(size:) to .fontSize(:)
* Changed Columns to adjust its height so that column lengths are even.

## v0.2.4
* Added StrokeStyle
* Added Line
* Added .fontWeight, .fontWidth, and .fontDesign
* Added .kerning
* Added fixedLength option to Spacer
* Added .opacity modifier to Color
* Renamed HGrid to VGrid
* Fixed if/then, switch functionality in @BlockBuilder

## v0.2.3
* Added .scaleEffect modifier
* Early look at Columns layout. Not complete
* Early look at page or column wrapable Text
* Changed default layout to center instead of top leading
* Changed name of Size to Dimension and allow points to be expressed as literals
* Change Text to use CoreText rendering

## v0.2.2
* Added .rotationEffect modifier
* Added .offset modifier
* Added more Shape drawing functions

## v0.2.1
* Added Shapes
* Added Gradient fill
* Added ShapeStyle
* Added .textStroke modifier
* Added .textFill modifier
