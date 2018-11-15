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
	
	import kx.XApp;
	import openfl.events.*;
	import openfl.ui.*;
	import kx.collections.*;
	import kx.signals.*;
	
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
		
		//------------------------------------------------------------------------------------------
		public function new () {
		}

		//------------------------------------------------------------------------------------------
		public function setup (__XApp:XApp, __type:String):Void {
			m_XApp = __XApp;
			m_type = __type;
			
			m_touchMoveSignal = m_XApp.createXSignal ();
			m_touchEndSignal = m_XApp.createXSignal ();
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
		public function initPos (e:TouchEvent):Void {
			m_startLocalX = e.localX;
			m_startLocalY = e.localY;
			m_startStageX = e.stageX;
			m_startStageY = e.stageY;
			
			m_currentLocalX = e.localX;
			m_currentLocalY = e.localY;
			m_currentStageX = e.stageX;
			m_currentStageY = e.stageY;
		}
		
		//------------------------------------------------------------------------------------------
		public function updatePos (e:TouchEvent):Void {
			m_currentLocalX = e.localX;
			m_currentLocalY = e.localY;
			m_currentStageX = e.stageX;
			m_currentStageY = e.stageY;
			
			m_touchMoveSignal.fireSignal (this);
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
