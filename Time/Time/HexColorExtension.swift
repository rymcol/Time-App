//
//  HexColorExtension.swift
//  Time
//
//  Created by Abdurrahman on 3/23/16.
//  Copyright © 2016 CertifiedWebDevelopers. All rights reserved.
//


#if os(iOS) || os(tvOS)
	import UIKit
	typealias SWColor = UIColor
#else
	import Cocoa
	typealias SWColor = NSColor
#endif

/// An extension of UIColor (on iOS) or NSColor (on OSX) providing HEX color handling.
public extension SWColor {
	/**
	Create non-autoreleased color with in the given hex string. Alpha will be set as 1 by default.
	- parameter hexString: The hex string, with or without the hash character.
	- returns: A color with the given hex string.
	*/
	public convenience init?(hexString: String) {
		self.init(hexString: hexString, alpha: 1.0)
	}
	
	/**
	Create non-autoreleased color with in the given hex string and alpha.
	- parameter hexString: The hex string, with or without the hash character.
	- parameter alpha: The alpha value, a floating value between 0 and 1.
	- returns: A color with the given hex string and alpha.
	*/
	public convenience init?(hexString: String, alpha: Float) {
		var hex = hexString
		
		// Check for hash and remove the hash
		if hex.hasPrefix("#") {
			hex = hex.substringFromIndex(hex.startIndex.advancedBy(1))
		}
		
		if (hex.rangeOfString("(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .RegularExpressionSearch) != nil) {
			
			// Deal with 3 character Hex strings
			if hex.characters.count == 3 {
				let redHex   = hex.substringToIndex(hex.startIndex.advancedBy(1))
				let greenHex = hex.substringWithRange(Range<String.Index>(start: hex.startIndex.advancedBy(1), end: hex.startIndex.advancedBy(2)))
				let blueHex  = hex.substringFromIndex(hex.startIndex.advancedBy(2))
				
				hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
			}
			
			let redHex = hex.substringToIndex(hex.startIndex.advancedBy(2))
			let greenHex = hex.substringWithRange(Range<String.Index>(start: hex.startIndex.advancedBy(2), end: hex.startIndex.advancedBy(4)))
			let blueHex = hex.substringWithRange(Range<String.Index>(start: hex.startIndex.advancedBy(4), end: hex.startIndex.advancedBy(6)))
			
			var redInt:   CUnsignedInt = 0
			var greenInt: CUnsignedInt = 0
			var blueInt:  CUnsignedInt = 0
			
			NSScanner(string: redHex).scanHexInt(&redInt)
			NSScanner(string: greenHex).scanHexInt(&greenInt)
			NSScanner(string: blueHex).scanHexInt(&blueInt)
			
			self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
		}
		else {
			// Note:
			// The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
			// so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
			// in future releases, not a feature. -- Apple Forum
			self.init()
			return nil
		}
	}
	
	/**
	Create non-autoreleased color with in the given hex value. Alpha will be set as 1 by default.
	- parameter hex: The hex value. For example: 0xff8942 (no quotation).
	- returns: A color with the given hex value
	*/
	public convenience init?(hex: Int) {
		self.init(hex: hex, alpha: 1.0)
	}
	
	/**
	Create non-autoreleased color with in the given hex value and alpha
	- parameter hex: The hex value. For example: 0xff8942 (no quotation).
	- parameter alpha: The alpha value, a floating value between 0 and 1.
	- returns: color with the given hex value and alpha
	*/
	public convenience init?(hex: Int, alpha: Float) {
		var hexString = String(format: "%2X", hex)
		let leadingZerosString = String(count: 6 - hexString.characters.count, repeatedValue: Character("0"))
		hexString = leadingZerosString + hexString
		self.init(hexString: hexString as String , alpha: alpha)
	}
}
