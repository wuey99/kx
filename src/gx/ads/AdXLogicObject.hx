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
package gx.ads;
	
	import gx.external.*;
	import gx.external.cmpstar.*;
	import gx.external.fgl.*;

	import kx.*;
	import kx.geom.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.world.ui.*;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	//------------------------------------------------------------------------------------------
	class AdXLogicObject extends XLogicObjectCX {
		private var m_continueSignal:XSignal;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			m_continueSignal = createXSignal ();
		}
	
		//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
			
			killAdObject ();
		}
	
		//------------------------------------------------------------------------------------------
		public function killAdObject ():Void {
			if (getAdObject () != null) {
				getAdObject ().nukeLater ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function addContinueListener (__listener:Dynamic /* Function */):Int {
			return m_continueSignal.addListener (__listener);
		}

		//------------------------------------------------------------------------------------------
		public function fireContinueSignal ():Void {
			m_continueSignal.fireSignal ();
		}
		
		//------------------------------------------------------------------------------------------
		public function createAd ():Void {
		}

		//------------------------------------------------------------------------------------------
		public function getAdType ():String {
			return "";
		}
		
		//------------------------------------------------------------------------------------------
		public function getAdID ():String {
			return "";
		}
		
		//------------------------------------------------------------------------------------------
		public function hideAds ():Void {
			if (getAdObject () != null) {
				getAdObject ().hide ();		
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function getAdObject ():AdX {
			return null;
		}
				
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }