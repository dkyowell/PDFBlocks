/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

import Foundation

// PageBlocks are a special class of blocks that must be used at the top level of a Block that is sent
// to a Context for rendering.
protocol PageBlock {}
