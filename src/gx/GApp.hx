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
package gx;
	
// GX
	import openfl.external.*;
	import openfl.net.*;
	import openfl.ui.*;
	import openfl.utils.*;
	
	import gx.assets.*;
	import gx.game.*;
	import gx.hud.*;
	import gx.levels.*;
	import gx.messages.*;
	import gx.messages.level.*;
	import gx.mickey.*;
	import gx.music.*;
	import gx.text.*;
	import gx.zone.*;
	
	import kx.*;
	import kx.bitmap.XBitmapDataAnim;
	import kx.collections.*;
	import kx.game.*;
	import kx.geom.*;
	import kx.keyboard.*;
	import kx.resource.*;
	import kx.signals.XSignal;
	import kx.task.*;
	import kx.texture.*;
	import kx.type.*;
	import kx.world.*;
	import kx.world.logic.*;
	import kx.xmap.*;
	import kx.xml.*;
	
	// begin include "..\\flash.h";
	import openfl.display.*;
	// end include "..\\flash.h";
	
//------------------------------------------------------------------------------------------
	class GApp extends Sprite {
		public var m_XApp:XApp;
		public var xxx:XWorld;
		public var m_app:GApp;
		public var m_assets:XAssets;
		
		public var m_player:XFlod;
		
		private var m_globalTextureManager:XSubTextureManager;
				
		public var m_XTaskSubManager:XTaskSubManager;
		
		public var m_states:Map<String, Dynamic>; // <String, Dynamic>
		public var m_gameStateObject:Gamestate;
		// deprecated
		public var m_gameState:Int;
		
		public var script:XTask;
		
		//------------------------------------------------------------------------------------------
		// gameplay?
		//------------------------------------------------------------------------------------------
		public var m_triggerSignal:XSignal;
		public var m_triggerXSignal:XSignal;
		public var m_pingSignal:XSignal;
		
		//------------------------------------------------------------------------------------------
		// gameplay
		//------------------------------------------------------------------------------------------
		public var m_mickeyObject:_MickeyX;
		public var m_mickeyCursorObject:_MickeyCursorX;
		public var m_levelObject:_LevelX;
		public var m_gameHudObject:_HudX;
		public var m_hudObject:XLogicObject;
		public var m_hudMessageObject:HudMessageX;
		public var PLAYFIELD_LAYER:Int = 0;
		public var m_levelData:Dynamic /* */;
		public var m_levelProps:LevelPropsX;
		public var m_levelName:String;
		public var m_levelComplete:Bool;	
		public var m_currentZone:Int;
		public var m_logicClassNameToClass:Map<String, Dynamic>; // <String, Dynamic>
		public var m_setMickeyToStartSignal:XSignal;
		public var m_zoneStartedSignal:XSignal;
		public var m_zoneFinishedSignal:XSignal;
		private var m_lives:Int;
		private var m_livesChangedSignal:XSignal;
		private var m_zoneManager:ZoneManager;
		private var m_paused:Bool;
		private var m_pausedObject:XLogicObject;
		public var m_mickeyDeathSignal:XSignal;
		
		//------------------------------------------------------------------------------------------
		public function new () {	
			super ();
			
			trace (": starting: ");
		}
		
		//------------------------------------------------------------------------------------------
		public function setup (
			__assetsClass:Class<Dynamic> /* <Dynamic> */,
			__mickeyClass:Class<Dynamic> /* <Dynamic> */,
			__parent:Dynamic /* */,
			__timerInterval:Float=32,
			__layers:Int=4
			):Void {
			
			m_app = this;
			
			m_XApp = new XApp ();
			m_XApp.setup (m_XApp.getDefaultPoolSettings ());
			
			xxx = createXWorld (__parent, m_XApp, __layers, __timerInterval);
			addChild (xxx);
			
			m_states = new Map<String, Dynamic> (); // <String, Dynamic>
			
			setupMask ();
			
			createViewRect ();
			
			xxx.grabFocus ();
			
			m_assets = Type.createInstance (__assetsClass, [m_XApp, __parent]);
			m_assets.load ();
		
			GX.setup (this, m_XApp);
			
			m_player = cast xxx.getXLogicManager ().initXLogicObject (
				// parent
				null,
				// logicObject
				cast new XFlod () /* as XLogicObject */,
				// item, layer, depth
				null, 0, 0,
				// x, y, z
				0, 0, 0,
				// scale, rotation
				1.0, 0
			) /* as XFlod */;
			
			m_gameState = 0;
			m_gameStateObject = null;
			
			m_livesChangedSignal = new XSignal ();
			
			m_zoneManager = createZoneManager ();
			
			m_XTaskSubManager = new XTaskSubManager (m_XApp.getXTaskManager ());
			
			script = addEmptyTask ();
		}

		//------------------------------------------------------------------------------------------
		public function createViewRect ():Void {
			xxx.setViewRect (704, 576);	
		}

		//------------------------------------------------------------------------------------------
		public function createXWorld (__parent:Dynamic /* */, __XApp:XApp, __layers:Int=8, __timerInterval:Float=32){
			return new XWorld (__parent, __XApp, __layers, __timerInterval);	
		}
		
		//------------------------------------------------------------------------------------------
		public function getWorld ():XWorld {
			return xxx;
		}
		
		//------------------------------------------------------------------------------------------
		public function getGamestateObject ():Gamestate {
			return m_gameStateObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function getCurrentState ():Gamestate {
			return m_gameStateObject;
		}
		
		//------------------------------------------------------------------------------------------
		// deprecated
		//------------------------------------------------------------------------------------------
		public function launchGamestate (__gameState:Class<Dynamic> /* <Dynamic> */):Void {
			m_XApp.getXTaskManager ().addTask ([
				XTask.WAIT, 0x0800,
				
				function ():Void {
					m_gameStateObject = cast xxx.getXLogicManager ().initXLogicObject (
						// parent
						null,
						// logicObject
						cast XType.createInstance (__gameState) /* as XLogicObject */,
						// item, layer, depth
						null, 0, 0,
						// x, y, z
						0, 0, 0,
						// scale, rotation
						1.0, 0
					) /* as Gamestate */;
				},
				
				XTask.RETN,
			]);
		}
		
		//------------------------------------------------------------------------------------------
		public function registerState (__name:String, __class:Class<Dynamic> /* <Dynamic> */):Void {
			if (!m_states.exists (__name)) {
				m_states.set (__name, __class);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function unregisterState (__name:String):Void {
			if (m_states.exists (__name)) {
				m_states.remove (__name);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoState (__name:String, __params:Array<Dynamic> /* <Dynamic> */ = null, __layer:Int = 0, __depth:Float = 0.0):Gamestate {
			if (m_states.exists (__name)) {
				var __class:Class<Dynamic> /* <Dynamic> */ = m_states.get (__name);
				
				if (m_gameStateObject != null) {
					m_gameStateObject.nukeLater ();
				}
				
				xxx.getXTaskManager ().addTask ([
					XTask.WAIT, 0x0100,
					
					function ():Void {
						m_gameStateObject = cast xxx.getXLogicManager ().initXLogicObject (
							// parent
							null,
							// logicObject
							cast XType.createInstance (__class) /* as XLogicObject */,
							// item, layer, depth
							null, 0, 0,
							// x, y, z
							0, 0, 0,
							// scale, rotation
							1.0, 0,
							// args
							__params
						) /* as Gamestate */;
					},
					
					XTask.RETN,
				]);
				
				return m_gameStateObject;
			}
			
			return null;
		}
		
		//------------------------------------------------------------------------------------------
		public function addTask (
			__taskList:Array<Dynamic> /* <Dynamic> */,
			__findLabelsFlag:Bool = true
		):XTask {
			
			var __task:XTask = m_XTaskSubManager.addTask (__taskList, __findLabelsFlag);
			
			__task.setParent (this);
			
			return __task;
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
		public function Null_HndlrX ():XLogicObject {
			return null;
		}
		
		//------------------------------------------------------------------------------------------
		public function getPaused ():Bool {
			return m_paused;
		}
		
		//------------------------------------------------------------------------------------------
		public function initGame ():Void {
		}
		
		//------------------------------------------------------------------------------------------
		public function initLevel (__levelName:String):Void {
		}
		
		//------------------------------------------------------------------------------------------
		public var m_mask:Sprite;
		
		//------------------------------------------------------------------------------------------
		public function setupMask ():Void {
			if (false /* CONFIG::starling */) {
			}
			else
			{
				m_mask = new flash.display.Sprite ();
				m_mask.mouseEnabled = false;
				m_mask.mouseChildren = false;
				
				m_mask.graphics.beginFill (0x000000);
				m_mask.graphics.drawRect (0, 0, 700, 550);
				
				addChild (m_mask);
				
				setMaskAlpha (1.0);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function getMaskAlpha ():Float {
			if (false /* CONFIG::starling */) {
				return 1.0;
			}
			else
			{
				return 1.0 - m_mask.alpha;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function setMaskAlpha (__alpha:Float):Void {
			if (false /* CONFIG::starling */) {
			}
			else
			{
				m_mask.alpha = 1.0 - Math.min (1.0, __alpha);
			}
		}

		//------------------------------------------------------------------------------------------
		public function cacheAllMovieClips ():Void {
			if (true /* CONFIG::flash */) {
//				return;
			}
			
			var t:XSubTextureManager = m_globalTextureManager = xxx.getTextureManager ().createSubManager ("__global__");
			
			t.start ();
			
			XType.forEach (m_XApp.getAllClassNames (), 
				function (x:Dynamic /* */):Void {
					t.add (cast(x, String) );					
				}
			);
			
			t.finish ();
		}
		
		//------------------------------------------------------------------------------------------
		public var player (get, set):XFlod;
		
		public function get_player ():XFlod {
			return m_player;
		}
		
		public function set_player (__val:XFlod): XFlod {
			return null;			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		public function setBGMVolume (__volume:Float):Void {
			m_player.setVolume (__volume);
		}
		
		//------------------------------------------------------------------------------------------
		public function getBGMVolume ():Float {
			return m_player.getVolume ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setSFXVolume (__volume:Float):Void {
			xxx.getSoundManager ().setSFXVolume (__volume);
		}
		
		//------------------------------------------------------------------------------------------
		public function getSFXVolume ():Float {
			return xxx.getSoundManager ().getSFXVolume ();
		}
		
		//------------------------------------------------------------------------------------------
		public function getSmallFontName ():String {
			return "SmallHiresFont:SmallHiresFont";	
		}
		
		//------------------------------------------------------------------------------------------
		public function openURLInBrowser (__url:String):Void {
			var __request:URLRequest = new URLRequest (__url);
			
			__request.method = URLRequestMethod.POST;
			
			__navigateToURL (__request, "_blank");	
		}
		
		//------------------------------------------------------------------------------------------
		public  function openURLInBrowserWithJavascript (url:Dynamic /* */, window:String = "_blank", specs:String=""):Void {
			var isString:Bool = XType.isType (url, String);
			var req:URLRequest = isString ? new URLRequest(url) : url;
			if (!ExternalInterface.available) {
				__navigateToURL(req, window);
			} else {
				var strUserAgent:String = Std.string (ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
				var msieIndex:UInt = XType.parseInt (strUserAgent.substr(strUserAgent.indexOf("msie") + 5, 3));
				if (strUserAgent.indexOf("firefox") != -1 || (strUserAgent.indexOf("msie") != -1 && msieIndex >= 7)) {
					ExternalInterface.call("window.open", req.url, window, specs);
				} else {
					__navigateToURL(req, window);
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function getNetworkingRestriction():String {
			return "";
		}
		
		//------------------------------------------------------------------------------------------
		// https://www.facebook.com/dialog/feed
		// ?app_id=1437483596500878
		// &caption=Octo-Tron%20Circus
		// &description=Building%20a%20better%20tomorrow%20by%20lending%20today!
		// &display=popup
		// &e2e=%7B%7D
		// &link=http%3A%2F%2Fwww.kablooey.com%2Fapps%2FOcto-Tron-Circus
		// &locale=en_US
		// &name=Play%20Octo-Tron%20Circus!
		// &next=http%3A%2F%2Fstatic.ak.facebook.com%2Fconnect%2Fxd_arbiter%2FoDB-fAAStWy.js%3Fversion%3D41%23cb%3Df7a5bb56%26domain%3Dwww.kablooey.com%26origin%3Dhttp%253A%252F%252Fwww.kablooey.com%252Ff1cb06720%26relation%3Dopener%26frame%3Df3b90fbe68%26result%3D%2522xxRESULTTOKENxx%2522
		// &picture=http%3A%2F%2Fwww.kablooey.com%3A8080%2Fapps%2FOcto-Tron-Circus%2Fimages%2FOcto-Tron-Circus-Facebook-Feed-Large.png
		// &sdk=joey
		//------------------------------------------------------------------------------------------
		public function generateFacebookShareLink (
			__app_id:String,
			__caption:String,
			__description:String,
			__link:String,
			__name:String,
			__picture:String
		):String {
			
			var __variables:URLVariables = new URLVariables();
			__variables.caption = __caption;
			__variables.description = __description;
			__variables.display = "popup";
			__variables.e2e = "{}";
			__variables.link = __link;
			__variables.local = "en_US";
			__variables.name = __name;
			__variables.next = "http://static.ak.facebook.com/connect/xd_arbiter/oDB-fAAStWy.js?version=41#cb=f7a5bb56&domain=www.kablooey.com&origin=http%3A%2F%2Fwww.kablooey.com%2Ff1cb06720&relation=opener&frame=f3b90fbe68&result=%22xxRESULTTOKENxx%22";
			__variables.picture = __picture;
			__variables.sdk = "joey";
			
			var __urlString:String = "http://www.facebook.com/dialog/feed?app_id=" + __app_id + "&" + __variables.toString ();
			
			trace (": ", __urlString);
			
			return __urlString;
		}
		
		//------------------------------------------------------------------------------------------
		private function __navigateToURL (__req:URLRequest, __url):Void {
			openfl.Lib.getURL(__req, __url);
		}
		
		//------------------------------------------------------------------------------------------
		//
		// gameplay
		//
		// in the future, possibly move some or all of the functionality to the gameplay state
		// retain interface methods in this class for backwards compatbility
		// we may keep level methods here in this class
		//
		//------------------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------------------
		public function setupSignals ():Void {
			m_setMickeyToStartSignal = new XSignal ();
			m_zoneStartedSignal = new XSignal ();
			m_zoneFinishedSignal = new XSignal ();
			m_triggerSignal = new XSignal ();
			m_triggerXSignal = new XSignal ();
			m_pingSignal = new XSignal ();
		}

		//------------------------------------------------------------------------------------------
		public function cleanupSignals ():Void {
			m_setMickeyToStartSignal.removeAllListeners ();
			m_zoneStartedSignal.removeAllListeners ();
			m_zoneFinishedSignal.removeAllListeners ();
			m_triggerSignal.removeAllListeners ();
			m_triggerXSignal.removeAllListeners ();
			m_pingSignal.removeAllListeners ();
		}

		//------------------------------------------------------------------------------------------
		public function cleanupCollisionLists ():Void {
			xxx.getXBulletCollisionManager ().cleanup ();
		}
		
		//------------------------------------------------------------------------------------------
		public function addXShake (__count:Int=15, __delayValue:Float=0x0100):Void {
			m_levelObject.addXShake (__count, __delayValue);
		}
		
		//------------------------------------------------------------------------------------------
		public function addYShake (__count:Int=15, __delayValue:Float=0x0100):Void {
			m_levelObject.addYShake (__count, __delayValue);
		}
	
		//------------------------------------------------------------------------------------------
		public function initLogicClassNames (__array:Array<Dynamic> /* <Dynamic> */):Void {
			m_logicClassNameToClass = XType.array2XDict (__array);	
		}
		
		//------------------------------------------------------------------------------------------
		public function logicClassNameToClass (__logicClassName:String):Dynamic /* */ {
			return null;
		}

		//------------------------------------------------------------------------------------------
		public function setLevelComplete (__complete:Bool):Void {
			m_levelComplete = __complete;
		}
		
		//------------------------------------------------------------------------------------------
		public function getLevelComplete ():Bool {
			return m_levelComplete;
		}

		//------------------------------------------------------------------------------------------
		public function setCurrentLevelProps (__levelProps:LevelPropsX):Void {
			m_levelProps = __levelProps;
		}
		
		//------------------------------------------------------------------------------------------
		public function getCurrentLevelProps ():LevelPropsX {
			return m_levelProps;
		}
		
		//------------------------------------------------------------------------------------------
		public function getLevelProps (__levelName:String):LevelPropsX {
			return null;
		}
		
		//------------------------------------------------------------------------------------------
		public function getLevelData (__levelName:String):Dynamic /* */ {
			return null;
		}
		
		//------------------------------------------------------------------------------------------
		public function createLevelProps (args:Array<Dynamic> /* <Dynamic> */):LevelPropsX {
			return (new LevelPropsX ()).setup (args);
		}

		//------------------------------------------------------------------------------------------
		public function loadLevel (__levelResourceName:String):XSimpleXMLNode {
			var __levelXMLString:ByteArray = XType.createInstance (xxx.getClass (__levelResourceName));
			__levelXMLString.uncompress (CompressionAlgorithm.ZLIB);
			
			var __xml:XSimpleXMLNode = new XSimpleXMLNode ();
			__xml.setupWithXMLString (__levelXMLString.toString ());
			
			return __xml;
		}
		
		//------------------------------------------------------------------------------------------
		public function initHudLayerObject ():Void {		
			m_hudObject = cast xxx.getXLogicManager ().initXLogicObject (
				// parent
				null,
				// logicObject
				cast new XLogicObject () /* as XLogicObject */,
				// item, layer, depth
				null, -1, 25000,
				// x, y, z
				0, 0, 0,
				// scale, rotation
				1.0, 0
			) /* as XLogicObject */;
			
			m_hudObject.show ();
		}
		
		//------------------------------------------------------------------------------------------
		public function getHudObject ():XLogicObject {
			return m_hudObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function getGameHudObject ():XLogicObject {
			return m_gameHudObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function getHudMessageObject ():HudMessageX {
			return m_hudMessageObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function setLevelObject (__levelObject:_LevelX):Void {
			m_levelObject = __levelObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function getLevelObject ():_LevelX {
			return m_levelObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function getLevelLayer (__layer:Int):XMapView { // XMapLayerView
			return m_levelObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function togglePauseGame ():Void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function pauseGame ():Void {		
		}
		
		//------------------------------------------------------------------------------------------
		public function unpauseGame ():Void {			
		}
		
		//------------------------------------------------------------------------------------------
		public function quitGame ():Void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function setupMickey (__mickey:_MickeyX):Void {
			var __x:Float = 2536-256;
			var __y:Float = 2536+256;
			
			m_mickeyObject = cast xxx.getXLogicManager ().initXLogicObject (
				// parent
				null,
				// logicObject
				cast __mickey /* as XLogicObject */,
				// item, layer, depth
				null, PLAYFIELD_LAYER, 10000,
				// x, y, z
				__x, __y, 0,
				// scale, rotation
				1.0, 0,
				[
					m_mickeyCursorObject
				]
			) /* as _MickeyX */;
		}
		
		//------------------------------------------------------------------------------------------
		public function initCursor ():Void {
			var __x:Float;
			var __y:Float;
			
			__x = 0;
			__y = 0;
			
			m_mickeyCursorObject = cast xxx.getXLogicManager ().initXLogicObject (
				// parent
				null,
				// logicObject
				cast new _MickeyCursorX () /* as XLogicObject */,
				// item, layer, depth
				null, PLAYFIELD_LAYER, 10000,
				// x, y, z
				__x, __y, 0,
				// scale, rotation
				1.0, 0
			) /* as _MickeyCursorX */;
		}
		
		//------------------------------------------------------------------------------------------
		public function __getMickeyCursorObject ():_MickeyCursorX {
			return m_mickeyCursorObject;	
		}
		
		//------------------------------------------------------------------------------------------
		public function setMickeyObject (__mickeyObject:_MickeyX):Void {
			m_mickeyObject = __mickeyObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function __getMickeyObject ():_MickeyX {
			return m_mickeyObject;
		}
		
		//------------------------------------------------------------------------------------------
		public function setMickeyMessage (__message:String):Void {
			m_mickeyObject.setMessage (__message);
		}

		//------------------------------------------------------------------------------------------
		public function createZoneManager ():ZoneManager {
			return new ZoneManager ();
		}
		
		//------------------------------------------------------------------------------------------
		public function getZoneManager ():ZoneManager {
			return m_zoneManager;
		}
		
		//------------------------------------------------------------------------------------------
		public function getCurrentZone ():Int {
			return m_currentZone;
		}

		//------------------------------------------------------------------------------------------
		public function setCurrentZone (__zone:Int):Void {
			getZoneManager ().setCurrentZone (__zone);
		}
		
		//------------------------------------------------------------------------------------------
		public function getAllGlobalItems ():Void {
			getZoneManager ().getAllGlobalItems ();
		}
		
		//------------------------------------------------------------------------------------------
		public function isValidZoneObjectItem (__itemName:String):Bool {
			return getZoneManager ().isValidZoneObjectItem (__itemName);
		}
		
		//------------------------------------------------------------------------------------------
		public function isZoneObjectItemNoKill (__itemName:String):Bool {
			return getZoneManager ().isZoneObjectItemNoKill (__itemName);
		}
		
		//------------------------------------------------------------------------------------------
		public function getZoneItems ():Map<Int, XMapItemModel> /* <Int, XMapItemModel> */ {
			return getZoneManager ().getZoneItems ();
		}
		
		//------------------------------------------------------------------------------------------
		public function getZoneItemObject (__zone:Int):ZoneX {
			return getZoneManager ().getZoneItemObject (__zone);
		}
		
		//------------------------------------------------------------------------------------------
		public function getStarterRingItems ():Map<Int, XMapItemModel> /* <Int, XMapItemModel> */ {
			return getZoneManager ().getStarterRingItems ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setMickeyToStartPosition (__zone:Int):Void {	
			getZoneManager ().setMickeyToStartPosition (__zone);
		}
		
		//------------------------------------------------------------------------------------------
		public function setMickeyToLevelStartPosition ():Void {
			getAllGlobalItems ();
			
			if (m_levelProps != null) {
				setCurrentZone (m_levelProps.getProperty ("zone"));
			}
			else
			{
				setCurrentZone (m_levelData.zone);		
			}
			
			m_levelObject.onEntry ();
			
			setMickeyToStartPosition (m_currentZone);
			
			m_mickeyObject.setXMapModel (m_mickeyObject.getLayer () + 1, xxx.getXMapModel (), m_levelObject);
		}
		
		//------------------------------------------------------------------------------------------
		public function resetZoneKillCount ():Void {
			getZoneManager ().resetZoneKillCount ();
		}
		
		//------------------------------------------------------------------------------------------
		public function addToZoneKillCount ():Void {
			getZoneManager ().addToZoneKillCount ();
		}
		
		//------------------------------------------------------------------------------------------
		public function removeFromZoneKillCount ():Void {
			getZoneManager ().removeFromZoneKillCount ();
		}
		
		//------------------------------------------------------------------------------------------
		public function getZoneKillCount ():Int {
			return getZoneManager ().getZoneKillCount ();
		}

		//------------------------------------------------------------------------------------------
		public function addZoneStartedListener (__function:Dynamic /* Function */):Int {
			return m_zoneStartedSignal.addListener (__function);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeZoneStartedListener (__id:Int):Void {
			m_zoneStartedSignal.removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireZoneStartedSignal ():Void {
			m_zoneStartedSignal.fireSignal (getCurrentZone ());
		}
		
		//------------------------------------------------------------------------------------------
		public function addZoneFinishedListener (__function:Dynamic /* Function */):Int {
			return m_zoneFinishedSignal.addListener (__function);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeZoneFinishedListener (__id:Int):Void {
			m_zoneFinishedSignal.removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireZoneFinishedSignal ():Void {
			m_zoneFinishedSignal.fireSignal (getCurrentZone ());
		}

		//------------------------------------------------------------------------------------------
		public var lives (get, set):Int;
		
		public function get_lives ():Int {
			return  m_lives;
		}
		
		public function set_lives (__val:Int): Int {
			m_lives = __val;
			
			m_livesChangedSignal.fireSignal ();
			
			return 0;			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		public function addLivesChangedListener (__listener:Dynamic /* Function */):Int {
			return m_livesChangedSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeLivesChangedListener (__id:Int):Void {
			m_livesChangedSignal.removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireMickeyDeathSignal (__trigger:Int):Void {
			m_mickeyDeathSignal.fireSignal (__trigger);
		}
		
		//------------------------------------------------------------------------------------------
		public function addMickeyDeathListener (__listener:Dynamic /* Function */):Int {
			return m_mickeyDeathSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeMickeyDeathListener (__id:Int):Void {
			m_mickeyDeathSignal.removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		public function addMickeyPlayingListener (__listener:Dynamic /* Function */):Int {
			return GX.appX.__getMickeyObject ().addPlayingListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeMickeyPlayingListener (__id:Int):Void {
			GX.appX.__getMickeyObject ().removePlayingListener (__id);
		}

		//------------------------------------------------------------------------------------------
		public function fireTriggerSignal (__trigger:Int):Void {
			m_triggerSignal.fireSignal (__trigger);
		}
		
		//------------------------------------------------------------------------------------------
		public function addTriggerListener (__listener:Dynamic /* Function */):Int {
			return m_triggerSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeTriggerListener (__id:Int):Void {
			m_triggerSignal.removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireTriggerXSignal (__trigger:String):Void {
			m_triggerXSignal.fireSignal (__trigger);
		}
		
		//------------------------------------------------------------------------------------------
		public function addTriggerXListener (__listener:Dynamic /* Function */):Int {
			return m_triggerXSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeTriggerXListener (__id:Int):Void {
			m_triggerXSignal.removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		public function addPingListener (__listener:Dynamic /* Function */):Int {
			return m_pingSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removePingListener (__id:Int):Void {
			m_pingSignal.removeListener (__id);
		}

		//------------------------------------------------------------------------------------------
		public function firePingSignal (
			__id:Int,
			__type:String,
			__logicObject:XLogicObject,
			__listener:Dynamic /* Function */
		):Void {
			m_pingSignal.fireSignal (__id, __type, __logicObject, __listener);
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }