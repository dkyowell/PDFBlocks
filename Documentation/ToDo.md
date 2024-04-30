# Need to Implement

## Test Sub-Tables

## Document Tables

## TextTruncateMode
Target: v0.4

## LayoutPriority
Target: v0.4


# Enhancements

## Text
wrap in a VStack

## Image
?

## Columns
Self-Size for equal length columns.

## Grids
There should be more layout options and an HGrid

## Shape
There are many intersection, union, etc functions that I have not yet implemented. Path is just a very thin layer
on top of MutablePath. I could just get rid of all of it and operate directly upon a MutablePath. Or, I could 
expose MutablePath.





# Layout

The layout heuristic is intentionally simpler than SwiftUI.

Blocks are asked to size themselves given a proposed size. They return a min size and a max size.


# A Text 
