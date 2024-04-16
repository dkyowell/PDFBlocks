#  To Do List

## Version 1.0 Roadmap
### PageWrap Text

### Column Layout

### Offset

### Rotation

### VGrid

## Partialy Implmented
### Grids
There should be more layout options.

### Shape
There are many intersection, union, etc functions that I have not yet implemented. Path is just a very thin layer
on top of MutablePath. I could just get rid of all of it and operate directly upon a MutablePath. Or, I could 
expose MutablePath.

## Fixes

### Overlays
Need to review overlay rendering deferal. It seems that overlays are not being rendered in many cases.



## Reevaluate

### Default Positioning
TopLeading or Center?


### Expose Renderable
Is there a way to make a CustomBlock that uses .sizeFor(), but that does not expose the full Renderable protocol?
Exposing Renderer would not be a big deal.
Offer a PDFBlocksAdvanced import with Renderable?

### Layout


## Version > 1.0
### Leading to Trailing Page Wrap
Currently page wrap only works with elements that flow from top to bottom.

### Gradient fill for text
I have attempted this, but ran into a couple of dead ends. 1) When the Text was in a stack with other elements, the
gradient would randomly decide to spill over the entire page. 2) The gradient would not work at all with multi line
text. 

### Text along a path




## Version 2.0
If library gains widespready adoption, the following could be considered for a 2.0 release.

### Secondary Page Wrap Blocks
Allow Borders, Backgrounds, Overlays, etc

### Custom Layouts
This will wait for a use case and more widespready adoption of PDFBlocks. Any users who are held up would be able
to fork and implement their own.

### Text around a path
This would require CoreText,

