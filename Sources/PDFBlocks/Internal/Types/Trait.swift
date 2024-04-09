/**
 *  PDF Blocks
 *  Copyright (c) David Yowell 2024
 *  MIT license, see LICENSE file for details
 */

struct Trait {
    var proprtionalWidth: Double?
    var layoutPriority: Int = 0
    var containsMultipageBlock: Bool = false
    var pageInfo: PageInfo?
}
