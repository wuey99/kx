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
package kx.debug;
	
// X classes
	import kx.XApp;
	import kx.type.*;
	
//	import com.mattism.http.xmlrpc.*;
//	import com.mattism.http.xmlrpc.util.*;
	
	import openfl.events.ErrorEvent;
	import openfl.events.Event;
	
//------------------------------------------------------------------------------------------
	class XDebug {
		private var m_XApp:XApp;
		private var m_disabled:Bool;
		private var m_complete:Bool;
		private static var CHUNK_SIZE:Int = 128;
								
//------------------------------------------------------------------------------------------
		public function new () {	
			// super ();
			
			m_disabled = false;
			m_complete = false;
		}

//------------------------------------------------------------------------------------------
		public function setup (__XApp:XApp):Void {
			m_XApp = __XApp;
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public function disable (__flag:Bool):Void {
			m_disabled = __flag;
		}

//------------------------------------------------------------------------------------------
		public function print (args:Array<Dynamic>):Void {
			var __output:String;
			
			__output = "";
			
			for (i in 0 ... args.length) {
				__output += args[i] + " ";	
			}
			
			__output = "................................................................... " + __output;
			
			var __length:Int = Math.floor ((__output.length+CHUNK_SIZE)/CHUNK_SIZE);
			
			var i:Int;
			
			for (i in 0 ... __length) {
				print2 (__output.substr (i*CHUNK_SIZE, XType.min (__output.length - i*CHUNK_SIZE, CHUNK_SIZE)));
			}
		}
			
//------------------------------------------------------------------------------------------
		public function print2 (__output:String):Void {
			/*
			if (m_disabled) {
				return;
			}

			m_complete = false;
			
			var __connection:ConnectionImpl;
			
			try {
				__connection = new ConnectionImpl("http://localhost:8001/XDEBUG");
			}
			catch (e:Dynamic) {
				return;
			}
			
			try {	
				__connection.removeParams ();
				__connection.addParam (__output, XMLRPCDataTypes.STRING);
				__connection.call ("debugOut");
				__connection.addEventListener (Event.COMPLETE, __onCompleteHandler);
				__connection.addEventListener (ErrorEvent.ERROR, __onErrorHandler);
			}
			catch (e:Dynamic) {
				trace (": XDebug: ", e);
			}
			
			function __onCompleteHandler (e:Event):Void {
				__removeEventListeners ();
				
				m_complete = true;
			}
			
			function __onErrorHandler (e:ErrorEvent):Void {
				trace (": XDebug: ", e);
				
				__removeEventListeners ();
				
				m_complete = true;
			}
			
			function __removeEventListeners ():Void {
				__connection.removeEventListener (Event.COMPLETE, __onCompleteHandler);
				__connection.removeEventListener (ErrorEvent.ERROR, __onErrorHandler);
			}
			*/
		}

//------------------------------------------------------------------------------------------		
	}
	
//------------------------------------------------------------------------------------------
// }