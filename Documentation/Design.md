#  Design Notes

I began this project with a dual purpose. I write ERP software and I wanted a SwiftUI like way of coding reports. The
second was to gain a better understanding of how SwiftUI works under the hood. To that latter end, I have made the
project more complex than it needed to be for a PDF generation library. For exampe, TupleBlock is fully generic over its
contents as is TupleView in SwiftUI when a non-generic ArrayBlock would have sufficed instead.


I named the fundamental framework protocol Block instead of View to avoid namespace collisions when this is combined
with a SwiftUI project and also to make it clear at a glance what is PDFBlocks code and what is SwiftUI code.


The enormous difference in complexity between SwiftUI and PDFBlocks is the rendering cycle. PDFBlocks renders once and
is done. SwiftUI has a rendering cycle in which views are rendered, state is updated, or user input is performed, and
views are rendered again and so on. Because PDFBlocks has only one rendering cycle, there is no need for @State or other
associated dynamic properties. The seeming obsession of SwiftUI with Identifiable stems from its need to be able to
identify views from one cycle to the next in order to preserve their state between rendering cycles and to animate them.
Because PDFBlocks has neither of those concerns, ForEach and Table do not have Identifiable requirments for their data.


I do plan to fork this project one day in order to further my investigation into SwiftUI internals and make an
experimental UI framework out of it. The very first step will be to implement structural identity and @State.

## Internals

### Block
The primary building block of the entire project is the recursively defined protocol Block. The only thing that a
Block needs to do is provide a `var body: Block` that returns another Block. 

### Renderable

.sizeFor(:::) and .render(:::) pass both a Context and EnvironmentValues down the block tree. Context is a reference
type which is shared by the entire tree. EnvironmentValues is a value type. Child nodes inherit their parent's
EnvironmentValues, but can ammend them. So, it is possible for every node in the block tree to have a different
EnvironmentValues value.

...
 
 
 
 ## Future
 
 Offset
 Clip
 PageWrap Text
 Stroked Text
 StrokeStyle
 Rotation
 Text along Path?
 https://medium.com/swlh/add-curved-text-in-your-app-3d41d4463c24



Elliptical Gradient: Easy 
 

## Issues

* Text Gradient Fill: I had this working with a couple of caveats.  Multiline text would not render. This seems to be a
limitation of CoreGraphics.
