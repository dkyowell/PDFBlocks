# Contributions

I welcome contributors to this project, especially for help in the the follwing areas.
Send me an email if you would like to contribute: dkyowell.opensource@gmail.com. 

## Tests
There are no tests at present.

## Support for Linux.
The framework has been designed with a Renderer protocol with eventual support for non-Apple platforms in mind,
but the only Renderer that has been implemented is CGRenderer which has a CoreGraphics dependency. This would make
an excellent framework for Server Side Swift with the addition of Linux support. 

There are many open source C/C++ language rendering libraries that could be leveraged for rendering support. What
is essential is that the library offer support for measuring text. It looks like this would fit the bill:
https://github.com/galkahana/PDF-Writer/wiki/Text-support

## Missing Features
* Right to Left language support
* Shapes / Bezier paths
* Multipage Text 
* AttributedString
* More extensive grid support
* Hyperlinks
* Table of Contents
* Forms
* Many more!

