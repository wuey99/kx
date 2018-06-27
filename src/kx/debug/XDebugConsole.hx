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
package kx.debug ;
	
	import kx.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	
	import openfl.display.*;
	import openfl.text.*;
	import openfl.utils.*;
	
//------------------------------------------------------------------------------------------
	class XDebugConsole extends XLogicObject {
		private var m_textFormat:TextFormat;
		private var m_textArea:XTextSprite;
		private var m_disableOutput:Int;
		private var m_fontClass:Class<Dynamic>; // <Dynamic>
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
			
			m_disableOutput = 0;
		}

//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);

			m_fontClass = getArg (args, 0);
			
			createSprites ();
		}

//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			var xsprite:XDepthSprite;
			
			m_textArea = createXTextSprite (32, 32, "");
			
			xsprite = addSpriteAt (m_textArea, 0, 0, true);
			xsprite.setDepth (999999);
			
			setTextProps ();
			
			addText ("starting ...");
			
			show ();
		}

//------------------------------------------------------------------------------------------
// set text field properties
//------------------------------------------------------------------------------------------
		public function setTextProps ():Void {
			m_textArea.selectable = true;
			m_textArea.multiline = true;
			m_textArea.wordWrap = true;
			m_textArea.embedFonts = true;
		
			m_textArea.width = 320;
			m_textArea.height = 480;
			
//			var __font:Font = new __fontClass ();		
//			m_textArea.font = __font.fontName;
			
			m_textArea.bold = true;
			m_textArea.color = 0x404040;
			m_textArea.letterSpacing = 0.0;
		}

//------------------------------------------------------------------------------------------
		public function disableOutput (__flag:Bool):Void {
			if (__flag) {
				m_disableOutput++;
			}
			else
			{
				if (m_disableOutput > 0) {
					m_disableOutput--;
				}
			}
		}
		
//------------------------------------------------------------------------------------------
		public function addText (__text:String):Void {
// !STARLING!
			if (m_disableOutput <= 0) {
				if (true /* CONFIG::flash */) {
//					m_textArea.v.appendText (__text + "\n");
//					m_textArea.v.setTextFormat (m_textFormat);
				}
			}
		}

//------------------------------------------------------------------------------------------
		public function clear ():Void {
			m_textArea.text = "";
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
// }
