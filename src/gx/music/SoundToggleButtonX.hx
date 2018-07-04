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
package gx.music;
	
	import kx.*;
	import kx.geom.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.world.ui.*;
	
	import openfl.events.*;
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class SoundToggleButtonX extends XLogicObjectCX {
		public var m_sprite:XMovieClip;
		public var x_sprite:XDepthSprite;
		
		public var m_volume:Float;
		public var m_toggleSignal:XSignal;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic>  /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_volume = getArg (args, 0);

			createSprites ();
			
			if (true /* CONFIG::flash */) {
				m_sprite.mouseEnabled = true;
			}
		}

		//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
			m_toggleSignal = createXSignal ();
			
			m_sprite.addEventListener (xxx.MOUSE_DOWN, onMouseDown);
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
			
			m_sprite.removeEventListener (xxx.MOUSE_DOWN, onMouseDown);
		}

		//------------------------------------------------------------------------------------------
		public function onMouseDown (e:MouseEvent):Void {
			if (m_volume == 0.0) {
				m_volume = 1.0;
			} else {
				m_volume = 0.0;
			}
			
			update ();
			
			m_toggleSignal.fireSignal (m_volume);
		}
		
		//------------------------------------------------------------------------------------------
		public function setVolume (__volume:Float):Void {
			m_volume = __volume;
			
			update ();
		}

		//------------------------------------------------------------------------------------------
		public function update ():Void {
			switch (m_volume) {
				case 0:
					m_sprite.gotoAndStop (1);
					// break;
				case 1:
					m_sprite.gotoAndStop (2);
					// break;
			}			
		}
		
		//------------------------------------------------------------------------------------------
		public function addToggleListener (__listener:Dynamic /* Function */):Int {
			return m_toggleSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeToggleListener (__id:Int):Void {
			m_toggleSignal.removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():Void {
			m_sprite = createXMovieClip (getName ());
			x_sprite = addSpriteAt (m_sprite, m_sprite.dx, m_sprite.dy);
			x_sprite.setDepth (getDepth ());
			
			update ();
			
			show ();
		}

		//------------------------------------------------------------------------------------------
		public function getName ():String {
			return "";
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }