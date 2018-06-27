//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "GX-Engine"
//
// Copyright (c) 2014 Jimmy Huey (wuey99@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// <$end$/>
//------------------------------------------------------------------------------------------
package gx.text;
	
	import gx.*;
	import gx.assets.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class SmallSpriteTextX extends SpriteTextX {

		//------------------------------------------------------------------------------------------
		public static function init (__XApp:XApp):Void {
			__XApp.getBitmapDataAnimManager ().add (GX.appX.getSmallFontName ());
		}
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function getFontName ():String {
			return GX.appX.getSmallFontName ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function getWidths ():Array<Float> /* <Float> */ {
			return  [
				10,		// space
				6,		// !
				14,		// "
				17,		// #
				17,		// $
				22,		// %
				18,		// &
				6,		// '
				10,		// (
				10,		// }
				10,		// .
				14,		// +
				10,		// ,
				11,		// -
				6,		// .
				10,		// /
				14,		// 0
				10,		// 1
				14,		// 2
				14,		// 3
				14,		// 4
				14,		// 5
				14,		// 6
				14,		// 7
				14,		// 8
				14,		// 9
				6,		// :
				10,		// ;
				10,		// <
				11,		// =
				10,		// >
				13,		// ?
				21,		// @
				18,		// A
				18,		// B
				18,		// C
				18,		// D
				16,		// E
				16,		// F
				18,		// G
				18,		// H
				6,		// I
				14,		// J
				18,		// K
				16,		// L
				22,		// M
				18,		// N
				18,		// O
				18,		// P
				18,		// Q
				18,		// R
				18,		// S
				14,		// T
				18,		// U
				14,		// V
				22,		// W
				22,		// X
				22,		// Y
				14,		// Z
				10,		// [
				10,		// \
				10,		// ]
				14,		// ^
			];
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }