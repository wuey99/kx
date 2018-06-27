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
package gx.messages.level;
	
	import gx.assets.*;
	import gx.text.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xml.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class LevelTextX extends XLogicObjectCX {
		public var script:XTask;
		public var m_levelMessageObject:LevelMessageX;
		
		public var m_message:String;
		public var m_textSize:Int;
		public var m_textWidth:Float;
		public var m_textHeight:Float;
		public var m_textColor:UInt;
		public var m_alignment:String;
		public var m_textX:Float;
		public var m_textY:Float;
		public var m_spacing:Float;
		public var m_leading:Int;
		public var m_fontName:String;

		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
			setupParams ();
		
			createSprites ();
			
			script = addEmptyTask ();
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
		}
		
		//------------------------------------------------------------------------------------------
		// <params
		//   message=""
		//   x=""
		//   y=""
		//   size=""
		//   color=""
		//   width=""
		//   height=""
		//   alignment=""
		//   fontName=""
		// />
		//------------------------------------------------------------------------------------------
		public function setupParams ():Void {
			m_xml = new XSimpleXMLNode ();
			m_xml.setupWithXMLString (item.params);
			
			m_message = "None";
			if (m_xml.hasAttribute ("message")) {
				m_message = m_xml.getAttributeString ("message");
			}
			
			m_textSize = getDefaultSize ();
			if (m_xml.hasAttribute ("size")) {
				m_textSize = m_xml.getAttributeInt ("size");
			}
			
			m_textColor = getDefaultColor ();
			if (m_xml.hasAttribute ("color")) {
				m_textColor = m_xml.getAttributeInt ("color");
			}
			
			m_textWidth = getDefaultWidth ();
			if (m_xml.hasAttribute ("width")) {
				m_textWidth = m_xml.getAttributeInt ("width");
			}
			
			m_textHeight = getDefaultHeight ();
			if (m_xml.hasAttribute ("height")) {
				m_textHeight = m_xml.getAttributeInt ("height");
			}
		
			m_alignment = "left";
			if (m_xml.hasAttribute ("align")) {
				m_alignment = m_xml.getAttributeString ("align");
			}
			
			m_textX = getDefaultX ();
			if (m_xml.hasAttribute ("x")) {
				m_textX = m_xml.getAttributeFloat ("x");
			}
			
			m_textY = getDefaultY ();
			if (m_xml.hasAttribute ("y")) {
				m_textY = m_xml.getAttributeFloat ("y");
			}
			
			m_spacing = getDefaultSpacing ();
			if (m_xml.hasAttribute ("spacing")) {
				m_spacing = m_xml.getAttributeFloat ("spacing");
			}
			
			m_leading = getDefaultLeading ();
			if (m_xml.hasAttribute ("leading")) {
				m_leading = m_xml.getAttributeInt ("leading");
			}
			
			m_fontName = getDefaultFontName ();
			if (m_xml.hasAttribute ("fontName")) {
				m_fontName = m_xml.getAttributeString ("fontName");
			}
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			createMessage ();
			
			setMessage ();
			
			show ();
		}

		//------------------------------------------------------------------------------------------
		public function createMessage ():Void {
			var __dx:Float = 0;
			
			switch (m_alignment) {
				case "left":
					__dx = 0;
					// break;
				case "right":
					__dx = -m_textWidth;
					// break;
				case "center":
					__dx = -m_textWidth/2;
					// break;
			}
			
			m_levelMessageObject = cast xxx.getXLogicManager ().initXLogicObject (
				// parent
				this,
				// logicObject
				cast new LevelMessageX () /* as XLogicObject */,
				// item, layer, depth
				null, getLayer (), 1000,
				// x, y, z
				__dx, 0, 0,
				// scale, rotation
				1.0, 0
			) /* as LevelMessageX */;
			
			addXLogicObject (m_levelMessageObject);			
		}
		
		//------------------------------------------------------------------------------------------
		public function setMessage ():Void {
			m_levelMessageObject.setMessage (
				// message
				m_message,
				// size
				m_textSize, 
				// color
				m_textColor,
				// width, height
				m_textWidth, m_textHeight,
				// alignment
				m_alignment,
				// spacing
				m_spacing,
				// leading
				m_leading,
				// fontName
				m_fontName
			);
		}

		//------------------------------------------------------------------------------------------
		public function getDefaultColor ():UInt {
			return 0x60e060;
		}
		
		//------------------------------------------------------------------------------------------
		public function getDefaultSize ():Int {
			return 32;
		}

		//------------------------------------------------------------------------------------------
		public function getDefaultWidth ():Float {
			return 256.0;
		}
		
		//------------------------------------------------------------------------------------------
		public function getDefaultHeight ():Float {
			return 64.0;
		}

		//------------------------------------------------------------------------------------------
		public function getDefaultX ():Float {
			return 0;
		}
		
		//------------------------------------------------------------------------------------------
		public function getDefaultY ():Float {
			return 0;
		}
		
		//------------------------------------------------------------------------------------------
		public function getDefaultSpacing ():Float {
			return 0.0;
		}
		
		//------------------------------------------------------------------------------------------
		public function getDefaultLeading ():Int {
			return -12;
		}
		
		//------------------------------------------------------------------------------------------
		public function getDefaultFontName ():String {
			return "Aller";
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }