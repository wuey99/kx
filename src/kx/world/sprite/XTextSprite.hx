//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "X-Engine"
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
package kx.world.sprite;
	
	// begin include "..\\..\\flash.h";
	import openfl.display.*;
	// end include "..\\..\\flash.h";
	// begin include "..\\..\\text.h";
	import openfl.text.*;
	// end include "..\\..\\text.h";

	import openfl.filters.*;
	import openfl.text.TextFormat;
	
//------------------------------------------------------------------------------------------
	class XTextSprite extends XSprite {
		private var m_text:TextField;
		private var m_textFormat:TextFormat;

//------------------------------------------------------------------------------------------
		public function new (
			__width:Float=32,
			__height:Float=32,
			__text:String="",
			__fontName:String="Aller",
			__fontSize:Int=12,
			__color:Int=0x000000,
			__bold:Bool=false,
			__embedFonts:Bool = true
		) {
			super ();
			
			setup ();
			
			{
				m_text = new TextField ();		
				m_textFormat = new TextFormat ();
				
				this.width = __width;
				this.height = __height;
				this.text = __text;
				this.font = __fontName;
				this.size = __fontSize;
				this.color = __color;
				this.bold = __bold;
				this.embedFonts = __embedFonts;
			}
			
			addChild (m_text);
		}

//------------------------------------------------------------------------------------------
		public override function setup ():Void {
			super.setup ();
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
		}
		
//------------------------------------------------------------------------------------------
		public function getTextField ():TextField {
			return m_text;
		}
		
//------------------------------------------------------------------------------------------
		public var text (get, set):String;
		
		public function get_text ():String {
			return "";
		}
		
		public function set_text (__text:String): String {
			{
				m_text.htmlText = __text; __format ();
			}
			
			return __text;
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
			/* @:override get, set filters Array<BitmapFilter> */
			
		public override function get_filters ():Array<BitmapFilter> /* <BitmapFilter> */ {
				return null;
			}
			
		public override function set_filters (__val:Array<BitmapFilter> /* <BitmapFilter> */): Array<BitmapFilter> {
				m_text.filters = __val;
				
				return __val;
			
			}
			/* @:end */

//------------------------------------------------------------------------------------------
		public var color (get, set):Int;
		
		public function get_color ():UInt {
			return 0;
		}
		
		public function set_color (__color:UInt): Int {
			{
				m_text.textColor = __color; __format ();
			}
			
			return __color;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var bold (get, set):Bool;
		
		public function get_bold ():Bool {
			return true;
		}
		
		public function set_bold (__val:Bool): Bool {
			{
				m_textFormat.bold = __val; __format ();
			}
			
			return __val;			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public var font (get, set):String;
		
		public function get_font ():String {
			return "";
		}
		
		public function set_font (__val:String): String {
			{
				m_textFormat.font = __val; __format ();
			}
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var size (get, set):Int;
		
		public function get_size ():Int {
			return 0;
		}
		
		public function set_size (__val:Int): Int {
			{
				m_textFormat.size = __val; __format ();
			}
			
			return __val;			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var align (get, set):String;
		
		public function get_align ():String {
			return "";
		}
		
		public function set_align (__val:String): String {
			this.hAlign = __val;
			
			return "";			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var hAlign (get, set):String;
		
		public function get_hAlign ():String {
			return "";
		}
		
		public function set_hAlign (__val:String): String {
			{
				switch (__val) {
					case "left":
						m_textFormat.align = TextFormatAlign.LEFT;
						// break;
					case "right":
						m_textFormat.align = TextFormatAlign.RIGHT;
						// break;
					case "center":
						m_textFormat.align = TextFormatAlign.CENTER;
						// break;
				}
				
				__format ();
			}
			
			return "";			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var vAlign (get, set):String;
		
		public function get_vAlign ():String {
			return "";
		}
		
		public function set_vAlign (__val:String): String {

			
			return "";			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:override get, set width Float */
		
		public override function get_width ():Float {
			return m_text.width;
		}
		
		public override function set_width (__val:Float): Float {
			m_text.width = __val;
			
			return __val;
			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:override get, set height Float */
		
		public override function get_height ():Float {
			return m_text.height;
		}
		
		public override function set_height (__val:Float): Float {
			m_text.height = __val;
			
			return __val;
			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var textWidth (get, set):Float;
		
		public function get_textWidth ():Float {
			{
				return m_text.textWidth;
			}
		}
		
		public function set_textWidth (__val:Float):Float {
			return 0;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var textHeight (get, set):Float;
		
		public function get_textHeight ():Float {
			{
				return m_text.textHeight;
			}
		}
		
		public function set_textHeight (__val:Float):Float {
			return 0;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function autoCalcSize ():Void {
			width =	textWidth + 8;
			height = textHeight + 8;
		}
		
//------------------------------------------------------------------------------------------
		public function autoCalcWidth ():Void {
			width =	textWidth + 8;
		}
	
//------------------------------------------------------------------------------------------
		public function autoCalcHeight ():Void {
			height = textHeight + 8;
		}
		
//------------------------------------------------------------------------------------------
		public var letterSpacing (get, set):Float;
		
		public function get_letterSpacing ():Float {
			return 0;
		}
		
		public function set_letterSpacing (__val:Float): Float {
			{
				m_textFormat.letterSpacing = __val; __format ();
			}
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var leading (get, set):Int;
		
		public function get_leading ():Int {
			return 0;
		}
		
		public function set_leading (__val:Int): Int {
			{
				m_textFormat.leading = __val; __format ();
			}
			
			return __val;			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var selectable (get, set):Bool;
		
		public function get_selectable ():Bool {
			return true;
		}
		
		public function set_selectable (__val:Bool): Bool {
			{
				m_text.selectable = __val;
			}
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var multiline (get, set):Bool;
		
		public function get_multiline ():Bool {
			return true;
		}
		
		public function set_multiline (__val:Bool): Bool {
			{
				m_text.multiline = __val; __format ();
			}
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var wordWrap (get, set):Bool;
		
		public function get_wordWrap ():Bool {
			return true;
		}
		
		public function set_wordWrap (__val:Bool): Bool {
			{
				m_text.wordWrap = __val; __format ();
			}
			
			return __val;			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public var italic (get, set):Bool;
		
		public function get_italic ():Bool {
			return true;
		}
		
		public function set_italic (__val:Bool): Bool {
			return true;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var kerning (get, set):Bool;
		
		public function get_kerning ():Bool {
			return true;
		}
		
		public function set_kerning (__val:Bool): Bool {
			return true;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var underline (get, set):Bool;
		
		public function get_underline ():Bool {
			return true;
		}
		
		public function set_underline (__val:Bool): Bool {
			return true;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var embedFonts (get, set):Bool;
		
		public function get_embedFonts ():Bool {
			return true;
		}
		
		public function set_embedFonts (__val:Bool): Bool {
			{
				m_text.embedFonts = __val; __format ();
			}
			
			return __val;			
		}
		/* @:end */
				
//------------------------------------------------------------------------------------------
		private function __format ():Void {
			m_text.setTextFormat (m_textFormat);
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }