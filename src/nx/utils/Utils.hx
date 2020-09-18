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
package nx.utils;
	
	import kx.*;
	import kx.collections.*;
	import kx.signals.*;
	import kx.geom.*;
	
	import openfl.events.*;
	import openfl.ui.*;

	//------------------------------------------------------------------------------------------	
	class Utils {
		private var m_XApp:XApp;

		private var m_scaleRatio:Float;
		private var m_xoffset:Float;
		private var m_yoffset:Float;
		
		private static var g_instance:Utils;
		
		//------------------------------------------------------------------------------------------
		public function new () {
		}

		//------------------------------------------------------------------------------------------
		public function setup (__XApp:XApp, __params:Array<Dynamic> = null):Void {
			m_XApp = __XApp;
			g_instance = this;
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}

		//------------------------------------------------------------------------------------------
		public static function instance ():Utils {
			return g_instance;
		}
		
		//------------------------------------------------------------------------------------------
		public function fitScreenToDevice ():Void {
			var __scaleX:Float = m_XApp.getDeviceWidth () / m_XApp.getScreenWidth ();
			var __scaleY:Float = m_XApp.getDeviceHeight () / m_XApp.getScreenHeight ();
			
			m_scaleRatio = Math.min (__scaleX, __scaleY);
			
			m_xoffset = (m_XApp.getDeviceWidth () - m_XApp.getScreenWidth () * m_scaleRatio) / 2;
			m_yoffset = (m_XApp.getDeviceHeight () - m_XApp.getScreenHeight () * m_scaleRatio) / 2;
		}

		//------------------------------------------------------------------------------------------
		public function getXOffset ():Float {
			return m_xoffset;
		}
		
		//------------------------------------------------------------------------------------------
		public function getYOffset ():Float {
			return m_yoffset;
		}
		
		//------------------------------------------------------------------------------------------
		public function getScaleRatio ():Float {
			return m_scaleRatio;
		}
		
		//------------------------------------------------------------------------------------------
		public function translateDeviceCoords (__point:XPoint):Void {
			var __x:Float = __point.x - m_xoffset;
			var __y:Float = __point.y - m_yoffset;
			
			__x = Math.max (m_xoffset, __x);
			__y = Math.max (m_yoffset, __y);
			
			__x = Math.min (m_xoffset + m_XApp.getScreenWidth (), __x);
			__y = Math.min (m_yoffset + m_XApp.getScreenHeight (), __y);
			
			__point.x = __x;
			__point.y = __y;
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
