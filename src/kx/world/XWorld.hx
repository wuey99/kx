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
package kx.world;

// Box2D classes
	/*
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	*/
	
	import openfl.display.Stage;
	import openfl.events.Event;
	import openfl.events.KeyboardEvent;
	import openfl.events.MouseEvent;
	import openfl.events.TimerEvent;
	import openfl.geom.Point;
	import openfl.system.*;
	import openfl.utils.Timer;
	
	import kx.*;
	import kx.bitmap.*;
	import kx.datasource.XDatasource;
	import kx.debug.*;
	import kx.document.*;
	import kx.game.*;
	import kx.gamepad.*;
	import kx.gamepad.XGamepad;
	import kx.gamepad.XGamepadSubManager;
	import kx.geom.*;
	import kx.keyboard.*;
	import kx.mvc.*;
	import kx.pool.*;
	import kx.resource.*;
	import kx.resource.manager.*;
	import kx.signals.*;
	import kx.sound.*;
	import kx.task.*;
	import kx.text.*;
	import kx.texture.*;
	import kx.utils.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.world.tiles.*;
	import kx.world.ui.*;
	import kx.xmap.*;
	import kx.xml.*;
	
//------------------------------------------------------------------------------------------
	class XWorld extends XSprite {
		public var m_ticks:Int;
//		public var m_world:b2World;
		public var m_iterations:Int = 20;
		public var m_timeStep:Float = 1.0/30.0;
		public var self:Dynamic /* */;
		public var m_parent:Dynamic /* */;	
		public var m_XApp:XApp;
		public var m_XLogicManager:XLogicManager;
		public var m_XLogicManager2:XLogicManager;
		public var m_XTaskManager:XTaskManager;
		public var m_XTaskManagerCX:XTaskManager;
		public var m_renderManager:XTaskManager;
		public var m_XMapModel:XMapModel;
		public var m_XWorldLayers:Array<XSpriteLayer>; // <XSpriteLayer>
		public var m_XHudLayer:XSpriteLayer;
		public var MAX_LAYERS:Int;
		public var m_inuse_ENTER_FRAME:Int;
		public var m_inuse_RENDER_FRAME:Int;
		public var m_XKeyboardManager:XKeyboardManager;
		private var m_viewRect:XRect;
		private var m_XBulletCollisionManager:XBulletCollisionManager;
		private var m_XObjectCollisionManager:XObjectCollisionManager;
		private var m_objectCollisionList:XObjectCollisionList;
		public var m_mouseX:Float;
		public var m_mouseY:Float;
		public var m_timer:Timer;
		public var m_timer1000:Timer;
		public var m_timer1000Signal:XSignal;
		public var m_frameCount:Float;
		public var m_FPS:Float;
		public var m_minimumFPS:Float;
		public var m_idealFPS:Float;
		public var m_FPSCounterObject:XFPSCounter;
		public var m_paused:Bool;
		public var m_soundManager:XSoundManager;
		public var m_XLogicObjectPoolManager:XClassPoolManager;
		public var m_beforeFrameSignal:XSignal;
		public var m_afterFrameSignal:XSignal;
		
		public var m_mouseOverSignal:XSignal;
		public var m_mouseDownSignal:XSignal;
		public var m_mouseMoveSignal:XSignal;
		public var m_polledMouseMoveSignal:XSignal;
		public var m_mouseUpSignal:XSignal;
		public var m_mouseOutSignal:XSignal;
		public var m_keyboardDownSignal:XSignal;
		public var m_keyboardUpSignal:XSignal;
		public var m_focusInSignal:XSignal;
		public var m_focusOutSignal:XSignal;
		
//------------------------------------------------------------------------------------------
		public var m_XWorld:XWorld;
		public var m_XLogicObject:XLogicObject;
		public var m_XMapItemModel:XMapItemModel;
		public var m_XDocument:XDocument;
		public var m_XButton:XButton;
		public var m_XWorldButton:XWorldButton;
		public var m_XWorldButton4:XWorldButton4;
		public var m_XSprite:XSprite;
		public var m_XTask:XTask;
		public var m_XDatasource:XDatasource;
		public var m_XTextSprite:XTextSprite;
		public var m_XProjectManager:XProjectManager;
		public var m_XSignals:XSignal;
		public var m_XBitmap:XBitmap;
		public var m_XSignalManager:XSignalManager;
		public var m_XSubmapTiles:XSubmapTiles;
		public var m_XSoundManager:XSoundManager;
		public var m_XSoundSubManager:XSoundSubManager;
		public var m_XDebugConsole:XDebugConsole;
		public var m_xmlDoc:XSimpleXMLDocument;
		public var m_xmlNode:XSimpleXMLNode;
		public var m_XPoint:XPoint;
		public var m_XRect:XRect;
		public var m_XMatrix:XMatrix;
		public var m_XMapLayerView:XMapLayerView;
		public var m_XMapView:XMapView;
		public var m_XSubXRectPoolManager:XSubObjectPoolManager;
		public var m_XSubXPointPoolManager:XSubObjectPoolManager;
		public var m_XMapLayerCachedView:XMapLayerCachedView;
		public var m_XBitmapDataAnimManager:XBitmapDataAnimManager;
		public var m_XControllerBase:XControllerBase;
		public var m_XMapItemCachedView:XMapItemCachedView;
		public var m_XMapItemXBitmapView:XMapItemXBitmapView;
		public var m_XTextureManager:XTextureManager;
		public var m_XSubTextureManager:XSubTextureManager;
		public var m_XMovieClipCacheManager:XMovieClipCacheManager;
		public var m_XTextLogicObject:XTextLogicObject;
		public var m_GUID:GUID;
		public var m_Domain:Domain;
		public var m_timely:Timely;
		public var m_gamepad:XGamepad;
		public var m_gamepadSubManager:XGamepadSubManager;
		
//------------------------------------------------------------------------------------------
		public function new (__parent:Dynamic /* */, __XApp:XApp, __layers:Int=8, __timerInterval:Float=32){
			super ();
			
			setup ();
			
			m_parent = __parent;
			m_XApp = __XApp;
			self = this;
			
			MAX_LAYERS = __layers;
			
			{
				mouseEnabled = true;
				mouseChildren = true;
			}
						
			m_inuse_ENTER_FRAME = 0;
			m_frameCount = 0;
			m_FPS = 0;
			m_minimumFPS = 20;
			m_idealFPS = 30;
			m_paused = false;
		
			if (true /* CONFIG::flash */) {
				addEventListener(Event.RENDER, onRenderFrame);
				m_inuse_RENDER_FRAME = 0;
			}
	
			/*
			// Create world AABB
			var worldAABB:b2AABB = new b2AABB ();
			worldAABB.lowerBound.Set (-100.0, -100.0);
			worldAABB.upperBound.Set (100.0, 100.0);
			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2 (0.0, 30.0);
			
			// Allow bodies to sleep
			var doSleep:Bool = true;
			
			// Construct a world object
			m_world = new b2World (worldAABB, gravity, doSleep);
			*/
			
			m_ticks = 0;
			
			m_XLogicManager = new XLogicManager (__XApp, this);
			m_XLogicManager2 = new XLogicManager (__XApp, this);

// deprecate this?
			m_XTaskManager = new XTaskManager (__XApp);
			m_XTaskManagerCX = new XTaskManager (__XApp);
			
			m_renderManager = new XTaskManager (__XApp);
			m_XSignalManager = new XSignalManager (__XApp);
			m_XBulletCollisionManager = new XBulletCollisionManager (this);
			m_XObjectCollisionManager = new XObjectCollisionManager (this);
			m_objectCollisionList = m_XObjectCollisionManager.addCollisionList ();
			
			m_XLogicObjectPoolManager = new XClassPoolManager ();
			
			m_timer1000 = new Timer (1000, 0);
			m_timer1000.start ();
			m_timer1000.addEventListener (TimerEvent.TIMER, onUpdateTimer1000);
			m_timer1000Signal = getXSignalManager ().createXSignal ();
			
			m_beforeFrameSignal = getXSignalManager ().createXSignal ();
			m_afterFrameSignal = getXSignalManager ().createXSignal ();
			
			initMouseScript ();
			
			m_XMapModel = null;
						
			m_XWorldLayers = new Array<XSpriteLayer> (); // <XSpriteLayer>
		
			for (i in 0 ... MAX_LAYERS) {
				m_XWorldLayers.push (null);
			}
			
			function __createLayer (i:Int):Void {
				m_XWorldLayers[i] = new XSpriteLayer ();
				m_XWorldLayers[i].setup ();
				m_XWorldLayers[i].xxx = self;
				addChild (m_XWorldLayers[i]);
				m_XWorldLayers[i].mouseEnabled = true;
				m_XWorldLayers[i].mouseChildren = true;
			}
			
			var i:Int = MAX_LAYERS-1;
//			for (var i:Number = MAX_LAYERS-1; i>=0; i--) {
			while (i >= 0) {
				__createLayer (i);
				
				i--;
			}
		
			m_XHudLayer = new XSpriteLayer ();
			m_XHudLayer.setup ();
			m_XHudLayer.xxx = this;
			addChild (m_XHudLayer);

			if (true /* CONFIG::flash */) {
				m_XHudLayer.mouseEnabled = true;
				m_XHudLayer.mouseChildren = true;
			}
			
			m_XKeyboardManager = new XKeyboardManager (this);
					
			m_mouseX = m_mouseY = 0;
			
			setupDebug ();
			
			addEventListener (Event.ENTER_FRAME, onFPSCounter);
			
			m_timer = null;
			
			if (__timerInterval > 0) {
				// Add event for main loop
				m_timer = new Timer (__timerInterval, 0);
				m_timer.start ();
				m_timer.addEventListener (TimerEvent.TIMER, onEnterFrame);
			}
			else
			{
				addEventListener (Event.ENTER_FRAME, onEnterFrame);		
			}
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
			
			quitMouseScript ();
			
			if (m_timer != null) {
				m_timer.removeEventListener (TimerEvent.TIMER, onEnterFrame);
				
				m_timer.stop ();
			} else {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);					
			}
			
			m_timer1000.removeEventListener (TimerEvent.TIMER, onUpdateTimer1000);
			m_timer1000.stop ();
			
			m_XLogicManager.cleanup ();
			m_XLogicManager2.cleanup ();
			
			// deprecate this?
			m_XTaskManager.removeAllTasks ();
			m_XTaskManagerCX.removeAllTasks ();
			
			m_renderManager.removeAllTasks ();
			m_XSignalManager.removeAllXSignals ();
			m_XBulletCollisionManager.cleanup ();
			
			removeEventListener (Event.RENDER, onRenderFrame);
			removeEventListener (Event.ENTER_FRAME, onFPSCounter);
			
			for (i in 0 ... MAX_LAYERS) {
				m_XWorldLayers[i].cleanup ();
				removeChild (m_XWorldLayers[i]);
			}
			
			m_XHudLayer.cleanup();
			removeChild (m_XHudLayer);
		}
		
//------------------------------------------------------------------------------------------
		public function setupDebug ():Void {
			// set debug draw
			
			
			m_FPSCounterObject = cast getXLogicManager2 ().initXLogicObject (
				// parent
				null,
				// logicObject
				cast new XFPSCounter () /* as XLogicObject */,
				// item, layer, depth
				null, -1, 1000000,
				// x, y, z
				0, 0, 0,
				// scale, rotation
				1.0, 0
			) /* as XFPSCounter */;
		}

//------------------------------------------------------------------------------------------
		public function onFPSCounter (e:Event):Void {
			m_frameCount++;
		}

//------------------------------------------------------------------------------------------
		public function onEnterFrame (e:Event):Void {
			__onEnterFrame ();
		}

//------------------------------------------------------------------------------------------
		public function onUpdateTimer1000 (e:Event):Void {	
			m_FPS = m_frameCount;
			
			m_frameCount = 0;
			
			m_timer1000Signal.fireSignal ();
		}
		
//------------------------------------------------------------------------------------------
		public function setFPS (__val:Float):Void {
			m_FPS = __val;
			
			m_frameCount = 0;
		}

//------------------------------------------------------------------------------------------
		public function getFPS ():Float {
			return m_FPS;
		}

//------------------------------------------------------------------------------------------
		public function setMinimumFPS (__val:Float):Void {
			m_minimumFPS = __val;	
		}
		
//------------------------------------------------------------------------------------------
		public function getMinimumFPS ():Float {
			return m_minimumFPS;
		}
		
//------------------------------------------------------------------------------------------
		public function setIdealFPS (__val:Float):Void {
			m_idealFPS = __val;	
		}
		
//------------------------------------------------------------------------------------------
		public function getIdealFPS ():Float {
			return m_idealFPS;
		}
		
//------------------------------------------------------------------------------------------
		public function addTimer1000Listener (__listener:Dynamic /* Function */):Int {
			return m_timer1000Signal.addListener (__listener);
		}

//------------------------------------------------------------------------------------------
		public function removeTimer1000Listener (__id:Int):Void {
			m_timer1000Signal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		private function __onEnterFrame ():Void {
			if (m_inuse_ENTER_FRAME > 0) {
				trace (": overflow: ENTER_FRAME: ");
				
				return;
			}
			
			m_inuse_ENTER_FRAME++;
			
			m_beforeFrameSignal.fireSignal ();
			
			getXLogicManager ().emptyKillQueue ();
			getXLogicManager2 ().emptyKillQueue ();
			
			getXLogicManager ().updateLogic ();
			getXLogicManager2 ().updateLogic ();
			
// will soon be deprecated?
			getXTaskManager ().updateTasks ();
			getXTaskManagerCX ().updateTasks ();
			
			if (!m_paused) {
				getXLogicManager ().updateTasks ();
			}
			getXLogicManager2 ().updateTasks ();
			
//			getXLogicManager ().updatePhysics ();
			
			getXLogicManager ().cullObjects ();
			getXLogicManager2 ().cullObjects ();
			
			if (true /* CONFIG::flash */) {
//				m_world.Step (m_timeStep, m_iterations);
			}
			
			getXLogicManager ().setValues ();
			getXLogicManager2 ().setValues ();
			
			getXLogicManager ().emptyKillQueue ();
			getXLogicManager2 ().emptyKillQueue ();
			
			m_XBulletCollisionManager.clearCollisions ();
			m_XObjectCollisionManager.clearCollisions ();
			
			getXLogicManager ().setCollisions ();
			getXLogicManager2 ().setCollisions ();
			
			getXLogicManager ().updateDisplay ();
			getXLogicManager2 ().updateDisplay ();
			
			m_afterFrameSignal.fireSignal ();
			
			for (i in 0 ... MAX_LAYERS) {
//				if (getXWorldLayer (i).forceSort) {
				if (true) {
					getXWorldLayer (i).depthSort ();
					getXWorldLayer (i).forceSort = false;
				}
			}
			
			getXHudLayer ().depthSort ();
			
			m_inuse_ENTER_FRAME--;			
		}

//------------------------------------------------------------------------------------------
		public function pause ():Void {
			m_paused = true;
			
			getSoundManager ().pause ();
		}
		
//------------------------------------------------------------------------------------------
		public function unpause ():Void {
			m_paused = false;
			
			getSoundManager ().resume ();
		}

//------------------------------------------------------------------------------------------
		public function isPaused ():Bool {
			return m_paused;
		}
		
//------------------------------------------------------------------------------------------
		public function addBeforeFrameListener (__listener:Dynamic /* Function */):Int {
			return m_beforeFrameSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removeBeforeFrameListener (__id:Int):Void {
			m_beforeFrameSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function addAfterFrameListener (__listener:Dynamic /* Function */):Int {
			return m_afterFrameSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removeAfterFrameListener (__id:Int):Void {
			m_afterFrameSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function onRenderFrame(e:Event):Void {
			if (m_inuse_RENDER_FRAME > 0) {
				trace (": overflow: RENDER_FRAME: ");
				
				return;
			}
			
			m_inuse_RENDER_FRAME++;
			
			getRenderManager ().updateTasks ();
			
			m_inuse_RENDER_FRAME--;		
		}	
		
//------------------------------------------------------------------------------------------
// returns the flash stage
//------------------------------------------------------------------------------------------
		public function getFlashStage ():Stage {
			return stage;
		}

//------------------------------------------------------------------------------------------
		public function initMouseScript ():Void {
			m_mouseOverSignal = new XSignal ();
			m_mouseDownSignal = new XSignal ();
			m_mouseMoveSignal = new XSignal ();
			m_polledMouseMoveSignal = new XSignal ();
			m_mouseUpSignal = new XSignal ();
			m_mouseOutSignal = new XSignal ();
			m_keyboardDownSignal = new XSignal ();
			m_keyboardUpSignal = new XSignal ();
			m_focusInSignal = new XSignal ();
			m_focusOutSignal = new XSignal ();
				
			/*
			getFlashStage ().addEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);
			getFlashStage ().addEventListener (KeyboardEvent.KEY_UP, onKeyboardUp);
			getFlashStage ().addEventListener (Event.ACTIVATE, onFocusInEvent);
			getFlashStage ().addEventListener (Event.DEACTIVATE, onFocusOutEvent);
			*/
			
			var __point:XPoint = new XPoint ();
			
			var __oldX:Float;
			var __oldY:Float;
			
			getXTaskManager ().addTask ([
				XTask.WAIT, 0x0100,
				
				XTask.LABEL, "wait",
					XTask.WAIT, 0x0100,
	
					XTask.FLAGS, function (__task:XTask):Void {
						__task.ifTrue (getFlashStage () != null);			
					}, XTask.BNE, "wait",
	
				function ():Void {
					getFlashStage ().addEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);
					getFlashStage ().addEventListener (KeyboardEvent.KEY_UP, onKeyboardUp);
					getFlashStage ().addEventListener (Event.ACTIVATE, onFocusInEvent);
					getFlashStage ().addEventListener (Event.DEACTIVATE, onFocusOutEvent);
				},
					
				function ():Void {
					// xxx.getParent ().stage.addEventListener (xxx.MOUSE_OVER, onMouseOver);
					getFlashStage ().addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
					getFlashStage ().addEventListener (MouseEvent.MOUSE_MOVE, onMouseMove);
					getFlashStage ().addEventListener (MouseEvent.MOUSE_UP, onMouseUp);
					getFlashStage ().addEventListener (MouseEvent.MOUSE_OUT, onMouseOut);
					
					__oldX = mouseX; __oldY = mouseY;
				},
				
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
						function ():Void {
							if (getFlashStage () != null && (__oldX != mouseX || __oldY != mouseY)) {
								__point.x = mouseX;
								__point.y = mouseY;
								
								m_polledMouseMoveSignal.fireSignal (__point);
								
								__oldX = mouseX; __oldY = mouseY;
							}
						},
						
					XTask.GOTO, "loop",
					
					XTask.RETN,
				]);
		}

//------------------------------------------------------------------------------------------
		public function quitMouseScript ():Void {
			m_mouseOverSignal.removeAllListeners ();
			m_mouseMoveSignal.removeAllListeners ();
			m_polledMouseMoveSignal.removeAllListeners ();
			m_mouseUpSignal.removeAllListeners ();
			m_mouseOutSignal.removeAllListeners ();
			m_keyboardDownSignal.removeAllListeners ();
			m_keyboardUpSignal.removeAllListeners ();
			m_focusInSignal.removeAllListeners ();
			m_focusOutSignal.removeAllListeners ();
			
			getFlashStage ().removeEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);
			getFlashStage ().removeEventListener (KeyboardEvent.KEY_UP, onKeyboardUp);
			getFlashStage ().removeEventListener (Event.ACTIVATE, onFocusInEvent);
			getFlashStage ().removeEventListener (Event.DEACTIVATE, onFocusOutEvent);
		}
		
//------------------------------------------------------------------------------------------
		public function onKeyboardDown (e:KeyboardEvent):Void {	
			m_keyboardDownSignal.fireSignal (e);
		}
		
//------------------------------------------------------------------------------------------
		public function onKeyboardUp (e:KeyboardEvent):Void {
			m_keyboardUpSignal.fireSignal (e);
		}
		
//------------------------------------------------------------------------------------------		
		public function addKeyboardDownListener (__listener:Dynamic /* Function */):Int {
			return m_keyboardDownSignal.addListener (__listener);
		}
		
		public function removeKeyboardDownListener (__id:Int):Void {
			m_keyboardDownSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------		
		public function addKeyboardUpListener (__listener:Dynamic /* Function */):Int {
			return m_keyboardUpSignal.addListener (__listener);
		}
		
		public function removeKeyboardUpListener (__id:Int):Void {
			m_keyboardUpSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function onMouseOver (e:MouseEvent):Void {
			m_mouseOverSignal.fireSignal (e);
		}
		
		public function addMouseOverListener (__listener:Dynamic /* Function */):Int {
			return m_mouseOverSignal.addListener (__listener);
		}

		public function removeMouseOverListener (__id:Int):Void {
			m_mouseOverSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function onMouseDown (e:MouseEvent):Void {	
			m_mouseDownSignal.fireSignal (e);
		}
		
		public function addMouseDownListener (__listener:Dynamic /* Function */):Int {
			return m_mouseDownSignal.addListener (__listener);
		}

		public function removeMouseDownListener (__id:Int):Void {
			m_mouseDownSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function onMouseMove (e:MouseEvent):Void {	
			m_mouseMoveSignal.fireSignal (e);
		}
		
		public function addMouseMoveListener (__listener:Dynamic /* Function */):Int {
			return m_mouseMoveSignal.addListener (__listener);
		}

		public function removeMouseMoveListener (__id:Int):Void {
			m_mouseMoveSignal.removeListener (__id);
		}

//------------------------------------------------------------------------------------------		
		public function addPolledMouseMoveListener (__listener:Dynamic /* Function */):Int {
			return m_polledMouseMoveSignal.addListener (__listener);
		}
		
		public function removePolledMouseMoveListener (__id:Int):Void {
			m_polledMouseMoveSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function onMouseUp (e:MouseEvent):Void {	
			m_mouseUpSignal.fireSignal (e);
		}
		
		public function addMouseUpListener (__listener:Dynamic /* Function */):Int {
			return m_mouseUpSignal.addListener (__listener);
		}

		public function removeMouseUpListener (__id:Int):Void {
			m_mouseUpSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function onMouseOut (e:MouseEvent):Void {	
			m_mouseOutSignal.fireSignal (e);
		}
		
		public function addMouseOutListener (__listener:Dynamic /* Function */):Int {
			return m_mouseOutSignal.addListener (__listener);
		}

		public function removeMouseOutListener (__id:Int):Void {
			m_mouseOutSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		/* @:override get, set mouseX Float */
		
		public override function get_mouseX ():Float {
			return getFlashStage ().mouseX;
		}
		
		public  function set_mouseX (__val:Float): Float {
			return 0;
			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:override get, set mouseY Float */
		
		public override function get_mouseY ():Float {
			return getFlashStage ().mouseY;
		}
		
		public function set_mouseY (__val:Float): Float {
			return 0;
			
		}
		/* @:end */

//------------------------------------------------------------------------------------------	
		public function onFocusInEvent (e:Event):Void {
		}
		
//------------------------------------------------------------------------------------------	
		public function onFocusOutEvent (e:Event):Void {
			fireFocusOutSignal ();	
		}
	
//------------------------------------------------------------------------------------------		
		public function addFocusInListener (__listener:Dynamic /* Function */):Int {
			return m_focusInSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removeFocusInListener (__id:Int):Void {
			m_focusInSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function fireFocusInSignal ():Void {
			m_focusInSignal.fireSignal ();
		}
		
//------------------------------------------------------------------------------------------		
		public function addFocusOutListener (__listener:Dynamic /* Function */):Int {
			return m_focusOutSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removeFocusOutListener (__id:Int):Void {
			m_focusOutSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function fireFocusOutSignal ():Void {
			m_focusOutSignal.fireSignal ();
		}
		
//------------------------------------------------------------------------------------------
		public function getXGamepadManager ():XGamepadManager {
			return m_XApp.getXGamepadManager ();
		}
		
//------------------------------------------------------------------------------------------
		public function getParent ():Dynamic /* */ {
			return m_parent;
		}
		
//------------------------------------------------------------------------------------------
		public function getXApp ():XApp {
			return m_XApp;
		}
		
//------------------------------------------------------------------------------------------
		public function show ():Void {
			visible = true;
		}	

//------------------------------------------------------------------------------------------
		public function hide ():Void {
			visible = false;
		}
		
//------------------------------------------------------------------------------------------
		/*
		public function getWorld ():b2World {
			return m_world;
		}
		*/
		
//------------------------------------------------------------------------------------------
		public function getMaxLayers ():Int {
			return MAX_LAYERS;
		}
		
//------------------------------------------------------------------------------------------
		public function setXMapModel (__XMapModel:XMapModel):Void {
			m_XMapModel = __XMapModel;
		}
		
//------------------------------------------------------------------------------------------
		public function getXMapModel ():XMapModel {
			return m_XMapModel;
		}

//------------------------------------------------------------------------------------------
		public function getXLogicObjectPoolManager ():XClassPoolManager {
			return m_XLogicObjectPoolManager;
		}

//------------------------------------------------------------------------------------------		
		public function getSoundManager ():XSoundManager {
			return m_XApp.getSoundManager ();
		}
		
//------------------------------------------------------------------------------------------
		public function getXLogicManager ():XLogicManager {
			return m_XLogicManager;
		}

//------------------------------------------------------------------------------------------
		public function getXLogicManager2 ():XLogicManager {
			return m_XLogicManager2;
		}
		
//------------------------------------------------------------------------------------------
		public function getXBulletCollisionManager ():XBulletCollisionManager {
			return  m_XBulletCollisionManager;
		}

//------------------------------------------------------------------------------------------
		public function getXObjectCollisionManager ():XObjectCollisionManager {
			return  m_XObjectCollisionManager;
		}

//------------------------------------------------------------------------------------------
		public function getObjectCollisionList ():XObjectCollisionList {
			return  m_objectCollisionList;
		}
				
//------------------------------------------------------------------------------------------
		public function createXSignal ():XSignal {
			return  m_XSignalManager.createXSignal ();
		}
		
//------------------------------------------------------------------------------------------
		public function getXSignalManager ():XSignalManager {
			return m_XSignalManager;
		}
		
//------------------------------------------------------------------------------------------
// deprecate and instead return XTaskManager from m_XLogicManager?
//------------------------------------------------------------------------------------------		
		public function getXTaskManager ():XTaskManager {
			return m_XTaskManager;
		}

//------------------------------------------------------------------------------------------
// deprecate and instead return XTaskManager from m_XLogicManager?
//------------------------------------------------------------------------------------------
		public function getXTaskManagerCX ():XTaskManager {
			return m_XTaskManagerCX;
		}
		
//------------------------------------------------------------------------------------------
		public function getXRectPoolManager ():XObjectPoolManager {
			return m_XApp.getXRectPoolManager ();
		}
		
//------------------------------------------------------------------------------------------
		public function getXPointPoolManager ():XObjectPoolManager {
			return m_XApp.getXPointPoolManager ();
		}

//------------------------------------------------------------------------------------------
		public function getXDepthSpritePoolManager ():XObjectPoolManager {
			return m_XApp.getXDepthSpritePoolManager ();
		}

//------------------------------------------------------------------------------------------
		public function getXBitmapPoolManager ():XObjectPoolManager {
			return m_XApp.getXBitmapPoolManager ();
		}

//------------------------------------------------------------------------------------------
		public function getXMovieClipPoolManager ():XObjectPoolManager {
			return m_XApp.getXMovieClipPoolManager ();
		}
	
//------------------------------------------------------------------------------------------
		public function getXTilemapPoolManager ():XObjectPoolManager {
			return m_XApp.getXTilemapPoolManager ();
		}
		
//------------------------------------------------------------------------------------------
		public function getTilePoolManager ():XObjectPoolManager {
			return m_XApp.getTilePoolManager ();
		}
				
//------------------------------------------------------------------------------------------
		public function getXMapItemModelPoolManager ():XObjectPoolManager {
			return m_XApp.getXMapItemModelPoolManager ();
		}
		
//------------------------------------------------------------------------------------------
		public function getMovieClipCacheManager ():XMovieClipCacheManager {
			return m_XApp.getMovieClipCacheManager ();
		}
		
//------------------------------------------------------------------------------------------
		public function getBitmapCacheManager ():XBitmapCacheManager {
			return m_XApp.getBitmapCacheManager ();
		}

//------------------------------------------------------------------------------------------
		public function getBitmapDataAnimManager ():XBitmapDataAnimManager {
			return m_XApp.getBitmapDataAnimManager ();
		}

//------------------------------------------------------------------------------------------
		public function getTextureManager ():XTextureManager {
			return m_XApp.getTextureManager ();
		}
		
//------------------------------------------------------------------------------------------
		public function useTilemaps ():Bool {
			return m_XApp.useTilemaps ();
		}
		
//------------------------------------------------------------------------------------------
		public function useBGTilemaps ():Bool {
			return m_XApp.useBGTilemaps ();
		}
		
//------------------------------------------------------------------------------------------
		public function grabFocus ():Void {
			m_XKeyboardManager.grabFocus ();
		}
		
//------------------------------------------------------------------------------------------
		public function releaseFocus():Void {
			m_XKeyboardManager.releaseFocus ();
		}
		
//------------------------------------------------------------------------------------------
		public function getKeyCode (__c:UInt):Bool {
			return m_XKeyboardManager.getKeyCode (__c);
		}

//------------------------------------------------------------------------------------------
		public function getRenderManager ():XTaskManager {
			return m_renderManager;
		}
				
//------------------------------------------------------------------------------------------
		public function getXWorldLayer (__layer:Int):XSpriteLayer {
			return m_XWorldLayers[__layer];
		}

//------------------------------------------------------------------------------------------
		public function getXHudLayer ():XSpriteLayer {
			return m_XHudLayer;
		}
		
//------------------------------------------------------------------------------------------
		public function getClass (__className:String):Class<Dynamic> /* <Dynamic> */ {
			return m_XApp.getClass (__className);
		}					

//------------------------------------------------------------------------------------------
		public function unloadClass (__className:String):Bool {
			return m_XApp.unloadClass (__className);
		}	
		
//------------------------------------------------------------------------------------------
			public var MOUSE_DOWN (get, set):String;	
		public function get_MOUSE_DOWN ():String {
				return MouseEvent.MOUSE_DOWN;	
			}
			
		public function set_MOUSE_DOWN (__val:String): String {
				return "";			
			}
			/* @:end */
			
			public var MOUSE_UP (get, set):String;	
		public function get_MOUSE_UP ():String {
				return MouseEvent.MOUSE_UP;	
			}
			
		public function set_MOUSE_UP (__val:String): String {
				return "";			
			}
			/* @:end */
			
			public var MOUSE_MOVE (get, set):String;	
		public function get_MOUSE_MOVE ():String {
				return MouseEvent.MOUSE_MOVE;	
			}
			
		public function set_MOUSE_MOVE (__val:String): String {
				return "";			
			}
			/* @:end */
			
			public var MOUSE_OVER (get, set):String;	
		public function get_MOUSE_OVER ():String {
				return MouseEvent.MOUSE_OVER;	
			}
			
		public function set_MOUSE_OVER (__val:String): String {
				return "";			
			}
			/* @:end */
			
			public var MOUSE_OUT (get, set):String;	
		public function get_MOUSE_OUT ():String {
				return MouseEvent.MOUSE_OUT;	
			}
			
		public function set_MOUSE_OUT (__val:String): String {
				return "";			
			}
			/* @:end */

//------------------------------------------------------------------------------------------
// http://www.flipcode.com/archives/Fast_Approximate_Distance_Functions.shtml
//------------------------------------------------------------------------------------------
		public function approxDistance (dx:Float, dy:Float):Float {
			var min:Float, max:Float, approx:Float;
			
			if ( dx < 0 ) dx = -dx;
			if ( dy < 0 ) dy = -dy;
			
			if ( dx < dy ) {
				min = dx;
				max = dy;
			}
			else
			{
				min = dy;
				max = dx;
			}
			
			approx = ( max * 1007 ) + ( min * 441 );
//			if ( max < ( min << 4 ))
			if ( max < ( min * 16 ))
				approx -= ( max * 40 );
			
			// add 512 for proper rounding
//			return (( approx + 512 ) >> 10 );
			return (( approx + 512 ) / 1024 );	
		}

//------------------------------------------------------------------------------------------
		public function realDistance (dx:Float, dy:Float):Float {
			return Math.sqrt (dx*dx + dy*dy);		
		}
		
//------------------------------------------------------------------------------------------
		public function globalToWorld (__layer:Int, __p:XPoint):XPoint {
			var __x:Point;
			
			if (__layer < 0) {
				__x = getXHudLayer ().globalToLocal (__p);
			}
			else 
			{
				__x = getXWorldLayer (__layer).globalToLocal (__p);
			}
			
			return new XPoint (__x.x, __x.y);
		}

//------------------------------------------------------------------------------------------
		public function globalToWorld2 (__layer:Int, __src:XPoint, __dst:XPoint):XPoint {
			var __x:Point;
			
			if (__layer < 0) {
				__x = getXHudLayer ().globalToLocal (__src);
			}
			else 
			{
				__x = getXWorldLayer (__layer).globalToLocal (__src);
			}
			
			__dst.x = __x.x; __dst.y = __x.y;
			
			return __dst;
		}
							
//------------------------------------------------------------------------------------------
		public function setViewRect (
			__width:Float, __height:Float
			):Void {
				
			m_viewRect = new XRect (0, 0, __width, __height);
		}

//------------------------------------------------------------------------------------------	
		public function getViewRect ():XRect {
			return m_viewRect;
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
// }
