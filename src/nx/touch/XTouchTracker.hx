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
package nx.touch;
	
	import kx.*;
	import kx.collections.*;
	import kx.signals.*;
	import kx.geom.XPoint;
	
	import openfl.events.*;
	import openfl.ui.*;

	import nx.utils.*;
	
	//------------------------------------------------------------------------------------------	
	class XTouchTracker {
		private var m_XApp:XApp;
		
		private var m_type:String;

		private var m_startLocalX:Float;
		private var m_startLocalY:Float;
		private var m_startStageX:Float;
		private var m_startStageY:Float;
		
		private var m_currentLocalX:Float;
		private var m_currentLocalY:Float;
		private var m_currentStageX:Float;
		private var m_currentStageY:Float;

		private var m_touchMoveSignal:XSignal;
		private var m_touchEndSignal:XSignal;
		
		private var m_localPoint:XPoint;
		private var m_stagePoint:XPoint;
		
		//------------------------------------------------------------------------------------------
		public function new () {
		}

		//------------------------------------------------------------------------------------------
		public function setup (__XApp:XApp, __type:String, __params:Array<Dynamic>):Void {
			m_XApp = __XApp;
			m_type = __type;
			
			m_touchMoveSignal = m_XApp.createXSignal ();
			m_touchEndSignal = m_XApp.createXSignal ();
			
			m_localPoint = new XPoint ();
			m_stagePoint = new XPoint ();
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
			m_touchEndSignal.fireSignal (this);
			
			m_XApp.getXSignalManager ().removeXSignal (m_touchMoveSignal);
			m_XApp.getXSignalManager ().removeXSignal (m_touchEndSignal);
		}

		//------------------------------------------------------------------------------------------
		public function addTouchMoveListener (__listener:Dynamic):Int {
			return m_touchMoveSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function addTouchEndListener (__listener:Dynamic):Int {
			return m_touchEndSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function setType (__type:String):Void {
			m_type = __type;
		}

		//------------------------------------------------------------------------------------------
		public function getStartLocalX ():Float {
			return m_startLocalX;
		}

		//------------------------------------------------------------------------------------------
		public function getStartLocalY ():Float {
			return m_startLocalY;
		}
		
		//------------------------------------------------------------------------------------------
		public function getStartStageX ():Float {
			return m_startStageX;
		}
		
		//------------------------------------------------------------------------------------------
		public function getStartStageY ():Float {
			return m_startStageY;
		}
		
		//------------------------------------------------------------------------------------------
		public function getCurrentLocalX ():Float {
			return m_currentLocalX;
		}

		//------------------------------------------------------------------------------------------
		public function getCurrentLocalY ():Float {
			return m_currentLocalY;
		}
		
		//------------------------------------------------------------------------------------------
		public function getCurrentStageX ():Float {
			return m_currentStageX;
		}
		
		//------------------------------------------------------------------------------------------
		public function getCurrentStageY ():Float {
			return m_currentStageY;
		}

		//------------------------------------------------------------------------------------------
		public function initPos (e:TouchEvent):Void {
			m_startLocalX = e.localX;
			m_startLocalY = e.localY;
			m_startStageX = e.stageX;
			m_startStageY = e.stageY;
			
			if (Utils.instance () != null) {
				m_localPoint.x = e.localX;
				m_localPoint.y = e.localY;
				
				Utils.instance ().translateDeviceCoords (m_localPoint);
				
				m_stagePoint.x = e.stageX;
				m_stagePoint.y = e.stageY;
				
				Utils.instance ().translateDeviceCoords (m_stagePoint);

				m_currentLocalX = m_localPoint.x;
				m_currentLocalY = m_localPoint.y;
				m_currentStageX = m_stagePoint.x;
				m_currentStageY = m_stagePoint.y;

				#if false
				Utils.instance ().getDebugConsole ().setMessage ([
					"" + m_XApp.getDeviceWidth (), "" + m_XApp.getDeviceHeight (),
					"" + Utils.instance ().getXOffset (), "" + Utils.instance ().getYOffset(),
					"" + e.localX, "" + e.localY,
					"" + e.stageX, "" + e.stageY,
					"" + m_stagePoint.x, "" + m_stagePoint.y,
				]);
				#end
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function updatePos (e:TouchEvent):Void {
			m_currentLocalX = e.localX;
			m_currentLocalY = e.localY;
			m_currentStageX = e.stageX;
			m_currentStageY = e.stageY;

			if (Utils.instance () != null) {
				m_localPoint.x = e.localX;
				m_localPoint.y = e.localY;
				
				Utils.instance ().translateDeviceCoords (m_localPoint);
				
				m_stagePoint.x = e.stageX;
				m_stagePoint.y = e.stageY;
				
				Utils.instance ().translateDeviceCoords (m_stagePoint);

				m_currentLocalX = m_localPoint.x;
				m_currentLocalY = m_localPoint.y;
				m_currentStageX = m_stagePoint.x;
				m_currentStageY = m_stagePoint.y;

				#if false
				Utils.instance ().getDebugConsole ().setMessage ([
					"" + m_XApp.getDeviceWidth (), "" + m_XApp.getDeviceHeight (),
					"" + m_stagePoint.x, "" + m_stagePoint.y,
					"" + Utils.instance ().getScaleRatio ()
				]);
				#end
			}
			
			m_touchMoveSignal.fireSignal (this);
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
