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
package kx.task;
	
	import openfl.system.*;
	import openfl.utils.*;
	
	import kx.*;
	import kx.collections.*;
	import kx.pool.*;
	import kx.type.*;
	
	//------------------------------------------------------------------------------------------
	// XTask provides a mechanism to control the execution of functions.
	// Functions can be queued up in an Array and executed at a later time.
	//
	// example of use:
	//
	// var taskList:Array /* <Dynamic> */= [
	//	__moveUp,
	//  __moveDn,
	// ];
	//
	// xxx.getXTaskManager ().addTask (taskList);
	//
	// function __moveUp ():void;
	// function __moveDn ():void;
	//
	// The execution of the queued functions can be manipulated several ways
	// via the use of a rudimentary Scripting system.
	//
	// DELAYED EXECUTION:
	// 	XTask.WAIT, <ticks>
	//
	// var taskList:Array /* <Dynamic> */ = [
	//  __moveUp,
	//  XTask.WAIT, 0x0400,
	//  __moveDn,
	// ];
	//
	// LOOPING:
	// XTask.LOOP, <count>
	//	<function>
	// XTask.NEXT
	// 
	// CALL/RETURN
	// 	XTask.CALL, <label>
	//  XTask.LABEL, "label"
	//  XTASK.RETN
	//
	// GOTO:
	//  XTask.GOTO, <label>
	//
	// some possible uses/applications of XTask:
	// 
	// 1) sequencing animation
	// 2) synchronizing the execution of code
	// 3) efficiently organizing operations that have to be executed in a particular order
	//------------------------------------------------------------------------------------------
	class XTask {
		private var m_taskList:Array<Dynamic>; // <Dynamic>
		private var m_taskIndex:Int;
		private var m_labels:Map<String, Int>; // <String, Int>
		private var m_ticks:Float;
		private var m_stack:Array<Int>; // <Int>
		private var m_loop:Array<Int>; // <Int>
		private var m_stackPtr:Int;
		private var m_parent:Dynamic /* */;
		private var m_flags:Int;
		private var m_subTask:XTask;
		private var m_time:Float;
		private var m_WAIT1000:Bool;
		public var m_isDead:Bool;
		public var tag:String;
		public var m_id:Int;
		public var self:XTask;
		public var m_pool:XObjectPoolManager;
		
		public static var g_id:Int = 0;
		
		private var m_manager:XTaskManager;
		
		public static var g_XApp:XApp;
		public var m_XApp:XApp;
		
// all op-codes
		public static inline var CALL:Int = 0;
		public static inline var RETN:Int = 1;
		public static inline var LOOP:Int = 2;
		public static inline var NEXT:Int = 3;
		public static inline var WAIT:Int = 4;
		public static inline var LABEL:Int = 5;
		public static inline var GOTO:Int = 6;
		public static inline var BEQ:Int = 7;
		public static inline var BNE:Int = 8;
		public static inline var FLAGS:Int = 9;
		public static inline var EXEC:Int = 10;
		public static inline var FUNC:Int = 11;
		public static inline var WAIT1000:Int = 12; 
		public static inline var UNTIL:Int = 13;
		public static inline var POP:Int = 14;
		public static inline var WAITX:Int = 15;
		
		public static inline var XTask_OPCODES:Int = 16;
		
		public static inline var _FLAGS_EQ:Int = 1;
		
		private var m_XTaskSubManager:XTaskSubManager;
		
		//------------------------------------------------------------------------------------------
		public function new () {
			// super ();	
			
			self = this;
			
			m_XTaskSubManager = createXTaskSubManager ();
			
			m_stack = new Array<Int> (); // <Int>
			m_loop = new Array<Int> (); // <Int>
			m_labels = new Map<String, Int> (); // <String, Int>
			
			for (i in 0 ... 8) {
				m_stack.push (0);
				m_loop.push (0);
			}
			
			m_isDead = true;
		}
		
		//------------------------------------------------------------------------------------------
		public function setup (__taskList:Array<Dynamic> /* <Dynamic> */, __findLabelsFlag:Bool = true):Void {
			__reset (__taskList, __findLabelsFlag);
			
			m_id = ++g_id;
		}
		
		//------------------------------------------------------------------------------------------
		private function __reset (__taskList:Array<Dynamic> /* <Dynamic> */, __findLabelsFlag:Bool = true):Void {
			m_taskList = __taskList;
			m_taskIndex = 0;
			for (__key__ in m_labels.keys ()) { m_labels.remove (__key__); } // removeAllKeys
			for (i in 0 ... 8) {
				m_stack[i] = 0;
				m_loop[i] = 0;
			}
			m_stackPtr = 0;
			m_ticks = 0x0100 + 0x0080;
			m_flags = ~_FLAGS_EQ;
			m_subTask = null;
			m_isDead = false;
			m_parent = null;
			m_WAIT1000 = false;
			tag = "";
			
			// locate forward referenced labels.  this is usually done by default, but
			// __findLabelsFlag can be set to false if it's known ahead of time that
			// there aren't any forward referenced labels
			if (__findLabelsFlag) {
				__findLabels ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function createXTaskSubManager ():XTaskSubManager {
			return new XTaskSubManager (null);
		}
		
		//------------------------------------------------------------------------------------------
		public function getParent ():Dynamic /* */ {
			return m_parent;
		}
		
		//------------------------------------------------------------------------------------------
		public function setParent (__parent:Dynamic /* */):Void {
			m_parent = __parent;
		}

		//------------------------------------------------------------------------------------------
		public function setPool (__pool:XObjectPoolManager):Void {
			m_pool = __pool;
		}
		
		//------------------------------------------------------------------------------------------
		public function getPool ():XObjectPoolManager {
			return m_pool;
		}
		
		//------------------------------------------------------------------------------------------
		public function getManager ():XTaskManager {
			return m_manager;
		}
		
		//------------------------------------------------------------------------------------------
		public function setManager (__manager:XTaskManager):Void {
			m_manager = __manager;
			
			m_XTaskSubManager.setManager (__manager);
		}
		
		//------------------------------------------------------------------------------------------
		public static function setXApp (__XApp:XApp):Void {
			g_XApp = __XApp;
		}
		
		//------------------------------------------------------------------------------------------
		public function getXApp ():XApp {
			return g_XApp;
		}
		
		//------------------------------------------------------------------------------------------
		public function kill ():Void {
			removeAllTasks ();
			
			m_isDead = true;
		}	
		
		//------------------------------------------------------------------------------------------
		// execute the XTask, usually called by the XTaskManager.
		//------------------------------------------------------------------------------------------
		public function run ():Void {
			function __retn ():Bool {
				if (m_stackPtr < 0) {
					if (m_parent != null && m_parent != m_manager) {
						m_parent.removeTask (self);
					}
					else
					{
						m_manager.removeTask (self);
					}
					
					return true;
				}		
				else
				{
					return false;
				}
			}
			
			// done execution?
			if (m_isDead) {
				return;
			}

			if (__retn ()) {
				return;
			}
			
			// suspended?
			m_ticks -= 0x0100;
			
			if (m_ticks > 0x0080) {
				return;
			}
			
			// evaluate instructions
			var __cont:Bool = true;
			
			while (__cont && !m_isDead) {
				__cont = __evalInstructions ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		// locate all labels in an XTask
		//------------------------------------------------------------------------------------------
		private function __findLabels ():Void {
			var i:Int;
			var x:Int;
			
			i = 0;
			
			while (i < m_taskList.length) {
				var value:Dynamic /* */ = m_taskList[i++];
				
				if (XType.isFunction (value)) {
				}
				else
				{
					x = cast value; /* as Int */
					
					switch (x) {
						case LABEL:
							var __label:String = cast m_taskList[i++]; /* as String; */
							
//							trace (": new Label: ", __label);
							
							if (!(m_labels.exists (__label))) {
								m_labels.set (__label, i);
							}
							else
							{
								throw (XType.createError ("duplicate label: " + __label));
							}
							
							// break;	
						
						case CALL:
							i++;
							
							// break;
						
						case RETN:
							// break;
						
						case LOOP:
							i++;
							
							// break;
						
						case NEXT:
							// break;
						
						case UNTIL:
							i++;
							
							// break;
						
						case WAIT:
							i++;
							
							// break;
						
						case WAIT1000:
							i++;
							
							// break;
						
						case GOTO:
							i++;
							
							// break;
						
						case BEQ:
							i++;
							
							// break;
						
						case BNE:
							i++;
							
							// break;
						
						case FLAGS:
							i++;
							
							// break;
						
						case EXEC:
							i++;
							
							// break;
						
						case FUNC:
							i++;
							
							// break;
						
						case POP:
							i++;
							
							// break;
						
						case WAITX:
							i++;
							
							// break;
						
						default:
							i = findMoreLabels (x, i);
							
							// break;
					}
				}
			}
		}

		//------------------------------------------------------------------------------------------
		// sub-classes of XTask override this to implement more op-codes
		//
		// find more labels 
		//------------------------------------------------------------------------------------------
		public function findMoreLabels (x:Int, i:Int):Int {
			return i;
		}
		
		//------------------------------------------------------------------------------------------		
		// evaluate instructions
		//------------------------------------------------------------------------------------------	
		private function __evalInstructions ():Bool {
			
			var value:Dynamic /* */ = m_taskList[m_taskIndex++];
			
			//------------------------------------------------------------------------------------------
			if (XType.isFunction (value)) {
				value ();
				
				return true;
			}
			
			//------------------------------------------------------------------------------------------
			switch (cast(value, Int) ) {
				//------------------------------------------------------------------------------------------
				
				//------------------------------------------------------------------------------------------
				case LABEL:
				//------------------------------------------------------------------------------------------
					var __label:String = cast m_taskList[m_taskIndex++]; /* as String */
					
					if (!(m_labels.exists (__label))) {
						m_labels.set (__label, m_taskIndex);
					}
					
					// break;
				
				//------------------------------------------------------------------------------------------					
				case WAIT:
				//------------------------------------------------------------------------------------------
					var __ticks:Float = __evalNumber () * getXApp ().getFrameRateScale ();
					
					m_ticks += __ticks;
					
					if (m_ticks > 0x0080) {
						return false;
					}
					
					// break;
				
				//------------------------------------------------------------------------------------------					
				case WAITX:
				//------------------------------------------------------------------------------------------
					var __ticksX:Float = __evalNumber ();
					
					m_ticks += __ticksX;
					
					if (m_ticks > 0x0080) {
						return false;
					}
					
					// break;
				
				//------------------------------------------------------------------------------------------
				case WAIT1000:
				//------------------------------------------------------------------------------------------
					if (!m_WAIT1000) {
						m_time = m_XTaskSubManager.getManager ().getXApp ().getTime ();
						
						m_ticks += 0x0100;
						m_taskIndex--;
						
						m_WAIT1000 = true;
					}
					else
					{
						var __time:Float = __evalNumber ();
						
						if (m_XTaskSubManager.getManager ().getXApp ().getTime () < m_time + __time) {
							m_ticks += 0x0100;
							m_taskIndex -= 2;
						}
						else
						{
							m_WAIT1000 = false;
							
							return true;
						}		
					}
					
					return false;
					
				//------------------------------------------------------------------------------------------					
				case LOOP:
				//------------------------------------------------------------------------------------------
					var __loopCount:Int = Std.int (__evalNumber ());
					
					m_loop[m_stackPtr] = __loopCount;
					m_stack[m_stackPtr++] = m_taskIndex;
					
					// break;
				
				//------------------------------------------------------------------------------------------
				case NEXT:
				//------------------------------------------------------------------------------------------
					//		trace (": ", m_loop[m_stackPtr-1]);
					
					m_loop[m_stackPtr-1]--;
					
					if (m_loop[m_stackPtr-1] > 0) {	
						m_taskIndex = m_stack[m_stackPtr-1];
					}
					else
					{
						m_stackPtr--;
					}
					
					// break;
				
				//------------------------------------------------------------------------------------------
				case UNTIL:
				//------------------------------------------------------------------------------------------
					var __funcUntil:Dynamic /* Function */ =
						cast m_taskList[m_taskIndex++] /* as Dynamic */ /* Function */;
					
					__funcUntil (self);
					
					if ((m_flags & _FLAGS_EQ) == 0) {	
						m_taskIndex = m_stack[m_stackPtr-1];
					}
					else
					{
						m_stackPtr--;
					}
					
					// break;
				
				//------------------------------------------------------------------------------------------					
				case GOTO:
				//------------------------------------------------------------------------------------------
					var __gotoLabel:String = cast m_taskList[m_taskIndex]; /* as String */
					
					if (!(m_labels.exists (__gotoLabel))) {
						throw (XType.createError ("goto: unable to find label: " + __gotoLabel));
					}
					
					m_taskIndex = m_labels.get(__gotoLabel);
					
					// break;
				
				//------------------------------------------------------------------------------------------					
				case CALL:
				//------------------------------------------------------------------------------------------
					var __callLabel:String = cast m_taskList[m_taskIndex++]; /* as String */
					
					m_stack[m_stackPtr++] = m_taskIndex;
					
					if (!(m_labels.exists(__callLabel))) {
						throw (XType.createError ("call: unable to find label: " + __callLabel));
					}
					
					m_taskIndex = m_labels.get(__callLabel);
					
					// break;
				
				//------------------------------------------------------------------------------------------					
				case RETN:
				//------------------------------------------------------------------------------------------					
					m_stackPtr--;
					
					if (m_stackPtr < 0) {
						return false;
					}
					
					m_taskIndex = m_stack[m_stackPtr];
					
					// break;
				
				//------------------------------------------------------------------------------------------					
				case POP:
				//------------------------------------------------------------------------------------------					
					m_stackPtr--;

					// break;
				
				//------------------------------------------------------------------------------------------
				case BEQ:
				//------------------------------------------------------------------------------------------	
					var __beqLabel:String = cast m_taskList[m_taskIndex++]; /* as String */
					
					if (!(m_labels.exists (__beqLabel))) {
						throw (XType.createError ("goto: unable to find label: " + __beqLabel));
					}
					
					if ((m_flags & _FLAGS_EQ) != 0) {
						m_taskIndex = m_labels.get(__beqLabel);
					}
					
					// break;
				
				//------------------------------------------------------------------------------------------
				case BNE:
				//------------------------------------------------------------------------------------------
					var __bneLabel:String = cast m_taskList[m_taskIndex++]; /* as String */
					
					if (!(m_labels.exists (__bneLabel))) {
						throw (XType.createError ("goto: unable to find label: " + __bneLabel));
					}
					
					if ((m_flags & _FLAGS_EQ) == 0) {
						m_taskIndex = m_labels.get (__bneLabel);
					}
					
					// break;
				
				//------------------------------------------------------------------------------------------
				case FLAGS:
				//------------------------------------------------------------------------------------------
					var __funcFlags:Dynamic /* Function */ = 
						cast m_taskList[m_taskIndex++] /* as Dynamic */ /* Function */;
					
					__funcFlags (self);
					
					// break;
				
				//------------------------------------------------------------------------------------------
				case FUNC:
				//------------------------------------------------------------------------------------------
					var __funcTask:Dynamic /* Function */ =
						cast m_taskList[m_taskIndex++] /* as Dynamic */ /* Function */;
					
					__funcTask (self);
					
					// break;
				
				//------------------------------------------------------------------------------------------
				// launch a sub-task and wait for it to finish before proceeding
				//------------------------------------------------------------------------------------------
				case EXEC:
					if (m_subTask == null) {
						// get new XTask Array run it immediately
						m_subTask = addTask ((cast(m_taskList[m_taskIndex], Array<Dynamic> /* <Dynamic> */) ), true);
						m_subTask.tag = tag;
						m_subTask.setManager (m_manager);
						m_subTask.setParent (self);
						m_subTask.run ();
						m_taskIndex--;
					}

					// if the sub-task is still active, wait another tick and check again
					else if (m_XTaskSubManager.isTask (m_subTask)) {
						m_ticks += 0x0100;
						m_taskIndex--;
						return false;
					}
					// move along
					else
					{
						m_subTask = null;
						m_taskIndex++;
					}
					
					// break;
				
				//------------------------------------------------------------------------------------------
				// more op-codes
				//------------------------------------------------------------------------------------------
				default:
					if (!evalMoreInstructions (cast(value, Int) )) {
						return false;
					}
					
					// break;
				
				//------------------------------------------------------------------------------------------
				// end switch
				//------------------------------------------------------------------------------------------
			}
			
			//------------------------------------------------------------------------------------------
			// end evalInstructions
			//------------------------------------------------------------------------------------------
			return true;
		}
		
		
		//------------------------------------------------------------------------------------------
		// sub-classes of XTask override this to implement more op-codes
		//
		// evaluate more op-codes	
		//------------------------------------------------------------------------------------------
		public function evalMoreInstructions (value:Int):Bool {
			return true;
		}
		
		//------------------------------------------------------------------------------------------
		public function setFlagsBool (__bool:Bool):Void {
			if (__bool) {
				setFlagsEQ ();
			}
			else
			{
				setFlagsNE ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function ifTrue (__bool:Bool):Void {
			if (__bool) {
				setFlagsEQ ();
			}
			else
			{
				setFlagsNE ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function setFlagsEQ ():Void {
			m_flags |= _FLAGS_EQ;
		}
		
		//------------------------------------------------------------------------------------------
		public function setFlagsNE ():Void {
			m_flags &= ~_FLAGS_EQ;
		}
		
		//------------------------------------------------------------------------------------------
		private function __evalNumber ():Float {
			var value:Dynamic /* */ = m_taskList[m_taskIndex++];
			
			if (Std.is (value, Float)) {
				return cast value /* as Float */;
			}
			
			if (Std.is (value, XNumber)) {
				var __number:XNumber = cast value; /* as XNumber */
				
				return __number.value;
			}
			
			return 0;
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoTask (__taskList:Array<Dynamic> /* <Dynamic> */, __findLabelsFlag:Bool = false):Void {
			kill ();
			
			__reset (__taskList, __findLabelsFlag);
			
			setManager (m_manager);
		}
		
		//------------------------------------------------------------------------------------------
		public function addTask (
			__taskList:Array<Dynamic> /* <Dynamic> */,
			__findLabelsFlag:Bool = true
		):XTask {
			
			return m_XTaskSubManager.addTask (__taskList, __findLabelsFlag);
		}
		
		//------------------------------------------------------------------------------------------
		public function changeTask (
			__task:XTask,
			__taskList:Array<Dynamic> /* <Dynamic> */,
			__findLabelsFlag:Bool = true
		):XTask {
			
			return m_XTaskSubManager.changeTask (__task, __taskList, __findLabelsFlag);
		}
		
		//------------------------------------------------------------------------------------------
		public function isTask (__task:XTask):Bool {
			return m_XTaskSubManager.isTask (__task);
		}		
		
		//------------------------------------------------------------------------------------------
		public function removeTask (__task:XTask):Void {
			m_XTaskSubManager.removeTask (__task);	
		}
		
		//------------------------------------------------------------------------------------------
		public function removeAllTasks ():Void {
			m_XTaskSubManager.removeAllTasks ();
		}
		
		//------------------------------------------------------------------------------------------
		public function addEmptyTask ():XTask {
			return m_XTaskSubManager.addEmptyTask ();
		}

		//------------------------------------------------------------------------------------------
		public function getEmptyTaskX ():Array<Dynamic> /* <Dynamic> */ {
			return m_XTaskSubManager.getEmptyTaskX ();
		}	
		
		//------------------------------------------------------------------------------------------
		public function gotoLogic (__logic:Dynamic /* Function */):Void {
			m_XTaskSubManager.gotoLogic (__logic);
		}
		
		//------------------------------------------------------------------------------------------
		// end class		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
	// end package
	//------------------------------------------------------------------------------------------
// }