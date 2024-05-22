/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

struct Trait {
    var proprtionalWidth: Double?
    var layoutPriority: Int = 0
    var wrapContents: Bool = false
    var pageInfo: PageInfo?
    var computePageCount: Bool = false
}
