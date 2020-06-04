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
package kx.world.logic;

	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	import kx.collections.*;
	import kx.geom.*;
	import kx.mvc.*;
	import kx.signals.XSignal;
	import kx.task.*;
	import kx.world.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	import kx.xml.*;
	import kx.type.*;

	// begin include "..\\..\\flash.h";
	import openfl.display.*;
	// end include "..\\..\\flash.h";
	
//------------------------------------------------------------------------------------------
// XLogicObject: Game object's that live in a "World".  These are essentially containers
// that wrap up neat-and-tidy, game logic, sprites, etc.
//
// XLogicObjects can either be instantiated dynamically from code or from an externally
// created level via a Level Manager.
//
// XLogicObjects that are created from a Level Manager are responsible for handling their
// own birth/death: XLogicObjects that stray outside the current viewport are automatically
// culled and returned back to the level.  Alternatively they can be "nuked": permanently
// removed from Level, never to return.  This system is based on Mario-like level management:
// when XLogicObjects in the Level enters the current viewPort, they are automatically spawned.
// When they leave the current viewPort (and +/- a certain threshold) they're culled. 
// They automatically get respawned when the object in the level reenters the current viewPort.
//
// When spawned, XLogicObject's can either live in the World (which is a scrollable area that
// can potentially be much larger than the current viewPort or in the HUD, which is an area
// that never scrolls.
//
// XLogicObjects can hold either XSprites or child XLogicObjects.
//------------------------------------------------------------------------------------------
	class XLogicObject extends XSprite0 {
//		public var xxx:XWorld;
		public var m_XLogicManager:XLogicManager;
		public var m_parent:XLogicObject;
		public var m_item:XMapItemModel;
		public var m_xml:XSimpleXMLNode;
		public var m_layer:Int;
		public var m_depth:Float;
		public var m_boundingRect:XRect;
		public var m_pos:XPoint;
		public var m_visible:Bool;
		public var m_masterVisible:Bool;
		public var m_relativeDepthFlag:Bool;
		public var m_masterDepth:Float;
		public var m_scaleX:Float;
		public var m_scaleY:Float;
		public var m_masterScaleX:Float;
		public var m_masterScaleY:Float;
		public var m_flipX:Float;
		public var m_flipY:Float;
		public var m_masterFlipX:Float;
		public var m_masterFlipY:Float;
		public var m_rotation:Float;
		public var m_masterRotation:Float;
		public var m_delayed:Int;
		public var m_XLogicObjects:Map<XLogicObject, Int>; // <XLogicObject, Int>
		public var m_worldSprites:Map<XDepthSprite, Int>; // <XDepthSprite, Int>
		public var m_hudSprites:Map<XDepthSprite, Int>; // <XDepthSprite, Int>
		public var m_childSprites:Map<Sprite, Sprite>; // <Sprite, Sprite>
		public var m_detachedSprites:Map<Sprite, Sprite>;  // <Sprite, Sprite>
		public var m_bitmaps:Map<String, XBitmap>; // <String, XBitmap>
		public var m_movieClips:Map<String, XMovieClip>; // <String, XMovieClip>
		public var m_textSprites:Map<XTextSprite, Int>; // <XTextSprite, Int>
		public var m_GUID:Int;
		public var m_alpha:Float;
		public var m_masterAlpha:Float;
		public var m_XSignals:Map<XSignal, Int>; // <XSignal, Int>
		public var self:XLogicObject;
		public var m_killSignal:XSignal;
		public var m_killSignalWithLogic:XSignal;
		public var m_XTaskSubManager0:XTaskSubManager;
		public var m_XTaskSubManager:XTaskSubManager;
		public var m_XTaskSubManagerCX:XTaskSubManager;
		public var m_isDead:Bool;
		public var m_cleanedUp:Bool;
		public var m_autoCulling:Bool;
		public var m_poolClass:Class<Dynamic>; // <Dynamic>
		public var m_viewPortRect:XRect;
		public var m_selfRect:XRect;
		public var m_itemRect:XRect;
		public var m_itemPos:XPoint;
		
		public var m_iX:Float;
		public var m_iY:Float;
		public var m_iScale:Float;
		public var m_iRotation:Float;
		public var m_iItem:XMapItemModel;
		public var m_iLayer:Int;
		public var m_iDepth:Float;
		public var m_iRelativeDepth:Bool;
		public var m_iClassName:String;
		
		private static var g_GUID:Int = 0;
						
//------------------------------------------------------------------------------------------
		public function new (__xxx:XWorld = null) {
			super ();
			
			self = this;
			m_item = null;
			m_parent = null;
			m_boundingRect = null;
			m_delayed = 1;
			m_layer = -1;
			m_isDead = false;
			m_cleanedUp = false;
			m_autoCulling = false;
		
			m_GUID = g_GUID++;
					
			iX = 0;
			iY = 0;
			iScale = 1.0;
			iRotation = 0.0;
			iItem = null;
			iDepth = 0;
			iRelativeDepth = false;
			iLayer = 0;
			iClassName = "";
				
			if (__xxx != null) {
				xxx = __xxx;
				
				m_XLogicObjects = new Map<XLogicObject, Int> (); // <XLogicObject, Int>
				m_worldSprites = new Map<XDepthSprite, Int> ();  // <XDepthSprite, Int>
				m_hudSprites = new Map<XDepthSprite, Int> (); // <XDepthSprite, Int>
				m_childSprites = new Map<Sprite, Sprite> (); // <Sprite, Sprite>
				m_detachedSprites = new Map<Sprite, Sprite> (); // <Sprite, Sprite>
				m_bitmaps = new Map<String, XBitmap>  (); // <String, XBitmap> 
				m_movieClips = new Map<String, XMovieClip> (); // <String, XMovieClip>
				m_textSprites = new Map<XTextSprite, Int> (); // <XTextSprite, Int>
				m_XSignals = new Map<XSignal, Int> (); // <XSignal, Int>
				m_XTaskSubManager0 = new XTaskSubManager (getXLogicManager ().getXTaskManager0 ());
				m_XTaskSubManager = new XTaskSubManager (getXLogicManager ().getXTaskManager ());
				m_XTaskSubManagerCX = new XTaskSubManager (getXLogicManager ().getXTaskManagerCX ());	
			}
		}
		
//------------------------------------------------------------------------------------------
		public function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {	
			m_masterScaleX = m_masterScaleY = 1.0;
			m_masterFlipX = m_masterFlipY = 1.0;
			m_masterRotation = 0;
			m_masterVisible = true;
			m_masterDepth = 0;
			m_masterAlpha = 1.0;
		
			oFlipX = 1.0;
			oFlipY = 1.0;
			
			m_isDead = false;
			m_cleanedUp = false;
			
			m_poolClass = null;
			
			if (xxx == null) {
				xxx = __xxx;
		
				m_XLogicObjects = new Map<XLogicObject, Int> (); // <XLogicObject, Int>
				m_worldSprites = new Map<XDepthSprite, Int> ();  // <XDepthSprite, Int>
				m_hudSprites = new Map<XDepthSprite, Int> (); // <XDepthSprite, Int>
				m_childSprites = new Map<Sprite, Sprite> (); // <Sprite, Sprite>
				m_detachedSprites = new Map<Sprite, Sprite> (); // <Sprite, Sprite>
				m_bitmaps = new Map<String, XBitmap>  (); // <String, XBitmap> 
				m_movieClips = new Map<String, XMovieClip> (); // <String, XMovieClip>
				m_textSprites = new Map<XTextSprite, Int> (); // <XTextSprite, Int>
				m_XSignals = new Map<XSignal, Int> (); // <XSignal, Int>
				m_XTaskSubManager0 = new XTaskSubManager (getXLogicManager ().getXTaskManager0 ());
				m_XTaskSubManager = new XTaskSubManager (getXLogicManager ().getXTaskManager ());
				m_XTaskSubManagerCX = new XTaskSubManager (getXLogicManager ().getXTaskManagerCX ());	
			}
			
			m_killSignal = createXSignal ();
			m_killSignalWithLogic = createXSignal ();
			
			m_pos = cast xxx.getXPointPoolManager ().borrowObject (); /* as XPoint */
			rp = cast xxx.getXPointPoolManager ().borrowObject (); /* as XPoint */
			
			setRegistration ();
			
			m_viewPortRect = cast xxx.getXRectPoolManager ().borrowObject (); /* as XRect; */
			m_selfRect = cast xxx.getXRectPoolManager ().borrowObject (); /* as XRect */
			m_itemRect = cast xxx.getXRectPoolManager ().borrowObject (); /* as XRect */
			m_itemPos = cast xxx.getXPointPoolManager ().borrowObject (); /* as XPoint */
			
			setVisible (false);			
			visible = false;
			
			setAlpha (1.0);
			alpha = 1.0;
		}

//------------------------------------------------------------------------------------------
		public function setupX ():Void {
		}

//------------------------------------------------------------------------------------------
		public function addKillListener (__listener:Dynamic /* Function */):Int {
			return m_killSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function fireKillSignal (__model:XModelBase):Void {
			m_killSignal.fireSignal (__model);
		}
	
//------------------------------------------------------------------------------------------
		public function addKillListenerWithLogic (__listener:Dynamic /* Function */):Int {
			return m_killSignalWithLogic.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function fireKillSignalWithLogic (__logicObject:XLogicObject):Void {
			m_killSignalWithLogic.fireSignal (__logicObject);
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():Void {
			/*
			xxx.getXPointPoolManager ().returnObject (m_pos);
			xxx.getXPointPoolManager ().returnObject (rp);
			xxx.getXRectPoolManager ().returnObject (m_viewPortRect);
			xxx.getXRectPoolManager ().returnObject (m_selfRect);
			xxx.getXRectPoolManager ().returnObject (m_itemRect);
			xxx.getXPointPoolManager ().returnObject (m_itemPos);
			*/
			
			returnBorrowedObjects ();
			
// if this item was spawned from a Level, decrement the item count and
// broadcast a "kill" signal.  it's possible for outsiders to subscribe
// to a the "kill" event.
			
			fireKillSignal (m_item);
			fireKillSignalWithLogic (this);
			
			if (m_item != null) {
//				fireKillSignal (m_item);
							
				m_item.inuse--;
				
				m_item = null;
			}
			
			removeAll ();

			if (m_poolClass != null) {
				xxx.getXLogicObjectPoolManager ().returnObject (m_poolClass, this);
			}
			
			isDead = true;
			cleanedUp = true;
		}

//------------------------------------------------------------------------------------------
		public function returnBorrowedObjects ():Void {
			xxx.getXPointPoolManager ().returnObject (m_pos);
			xxx.getXPointPoolManager ().returnObject (rp);		
			xxx.getXRectPoolManager ().returnObject (m_viewPortRect);
			xxx.getXRectPoolManager ().returnObject (m_selfRect);
			xxx.getXRectPoolManager ().returnObject (m_itemRect);
			xxx.getXPointPoolManager ().returnObject (m_itemPos);			
		}
		
//------------------------------------------------------------------------------------------
		public function nukeLater ():Void {
			if (m_item != null) {
				m_item.inuse++;
			}
			
			killLater ();
		}
		
//------------------------------------------------------------------------------------------
// kill this object and remove it from the World (delayed)
//------------------------------------------------------------------------------------------
		public function killLater ():Void {
			isDead = true;
			
			getXLogicManager ().killLater (this);
		}

//------------------------------------------------------------------------------------------
// kill this object and remove it from the World (now)
//------------------------------------------------------------------------------------------
		public function kill ():Void {
			isDead = true;
			
			getXLogicManager ().killLater (this);
		}

//------------------------------------------------------------------------------------------
		public function nuke ():Void {
			if (m_item != null) {
				m_item.inuse++;
			}
			
			kill ();
		}
		
//------------------------------------------------------------------------------------------
		public function removeAll ():Void {
			removeAllTasks ();
			removeAllXLogicObjects ();
			removeAllWorldSprites ();
			removeAllHudSprites ();
			removeAllXBitmaps ();
			removeAllMovieClips ();
			removeAllXTextSprites ();
			removeAllXSignals ();
			removeAllTasksCX ();
			
			if (getParent () != null) {
				getParent ().removeXLogicObject0 (this);
			}
		}
		
//------------------------------------------------------------------------------------------
// cull this object if it strays outside the current viewPort
//------------------------------------------------------------------------------------------	
		public function cullObject ():Void {
			if (autoCulling) {
				autoCullObject ();
				
				return;
			}
// if this object wasn't ever spawned from a level, don't perform any culling
			if (m_item == null) {
				return;
			}
			
// determine whether this object is outside the current viewPort
			var v:XRect = xxx.getViewRect();
			
			xxx.getXWorldLayer (m_layer).viewPort (v.width, v.height).copy2 (m_viewPortRect);
			m_viewPortRect.inflate (cullWidth (), cullHeight ());
			
			if (m_viewPortRect.intersects (m_itemRect)) {
				return;
			}
			
			m_boundingRect.copy2 (m_selfRect);
			m_selfRect.offsetPoint (getPos ());
			
			if (m_viewPortRect.intersects (m_selfRect)) {
				return;
			}
				
// yep, kill it
//			trace (": ---------------------------------------: ");
//			trace (": cull: ", this);
			
			killLater ();
		}

		//------------------------------------------------------------------------------------------
		// auto-cull this object if it strays outside the current viewPort
		//
		// auto-culled objects aren't spawned from a level so there's no
		// item object to retrieve a boundingRect from.  we're going to have
		// to provide a reasonable default for the boundingRect
		//------------------------------------------------------------------------------------------	
		public function autoCullObject ():Void {
			// determine whether this object is outside the current viewPort
			var v:XRect = xxx.getViewRect();
			
			var r:XRect = cast xxx.getXRectPoolManager ().borrowObject (); /* as XRect; */
			var i:XRect = cast xxx.getXRectPoolManager ().borrowObject (); /* as XRect */

			xxx.getXWorldLayer (m_layer).viewPort (v.width, v.height).copy2 (r);
			r.inflate (autoCullWidth (), autoCullHeight ());
			
			m_boundingRect.copy2 (i);
			i.offsetPoint (getPos ());
			
			function __dealloc ():Void {
				xxx.getXRectPoolManager ().returnObject (r);
				xxx.getXRectPoolManager ().returnObject (i);
			}
			
			if (r.intersects (i)) {
				__dealloc ();
				
				return;
			}
			
			__dealloc ();
			
			// yep, kill it
			trace (": ---------------------------------------: ");
			trace (": cull: ", this);
			
			killLater ();
		}

//------------------------------------------------------------------------------------------
		public function cullWidth ():Float {
			return 256;
		}
		
//------------------------------------------------------------------------------------------
		public function cullHeight ():Float {
			return 256;
		}
		
//------------------------------------------------------------------------------------------
		public function autoCullWidth ():Float {
			return 512;
		}
		
//------------------------------------------------------------------------------------------
		public function autoCullHeight ():Float {
			return 512;
		}
		
//------------------------------------------------------------------------------------------
		public function setParent (__parent:XLogicObject):Void {
			m_parent = __parent;
		}
		
//------------------------------------------------------------------------------------------
		public function getParent ():XLogicObject {
			return m_parent;
		}

//------------------------------------------------------------------------------------------
		
//------------------------------------------------------------------------------------------
		public function setPoolClass (__class:Class<Dynamic> /* <Dynamic> */):Void {
			m_poolClass = __class;
		}
		
//------------------------------------------------------------------------------------------
// get a map of all our child sprites that live in the World
//------------------------------------------------------------------------------------------	
		public function getSprites ():Map<XDepthSprite, Int> /* <XDepthSprite, Int> */ {
			return m_worldSprites;
		}
		
//------------------------------------------------------------------------------------------	
		public function sprites ():Map<XDepthSprite, Int> /* <XDepthSprite, Int> */ {
			return m_worldSprites;
		}
		
//------------------------------------------------------------------------------------------
// get a map of all our child sprites that live in the HUD
//------------------------------------------------------------------------------------------	
		public function getHudSprites ():Map<XDepthSprite, Int> /* <XDepthSprite, Int> */ {
			return m_hudSprites;
		}
		
//------------------------------------------------------------------------------------------
// get a map of all the our child XLogicObjects
//------------------------------------------------------------------------------------------	
		public function getXLogicObjects ():Map<XLogicObject, Int> /* <XLogicObject, Int> */ {
			return m_XLogicObjects;
		}

//------------------------------------------------------------------------------------------
		public function createXBitmap (__name:String):XBitmap {	
			var __bitmap:XBitmap = cast xxx.getXBitmapPoolManager ().borrowObject (); /* as XBitmap */
			__bitmap.setup ();
			__bitmap.initWithClassName (xxx, null, __name);
			__bitmap.alpha = 1.0;
			__bitmap.scaleX = __bitmap.scaleY = 1.0;
			
			m_bitmaps.set (__name, __bitmap);
			
			return __bitmap;
		}

//------------------------------------------------------------------------------------------
		public function createXMovieClip (__name:String):XMovieClip {
			var __xmovieClip:XMovieClip = cast xxx.getXMovieClipPoolManager ().borrowObject (); /* as XMovieClip */
			__xmovieClip.setup ();
			__xmovieClip.initWithClassName (xxx, null, __name);
			__xmovieClip.alpha = 1.0;
			__xmovieClip.scaleX = __xmovieClip.scaleY = 1.0;
			__xmovieClip.rotation = 0.0;
			
			m_movieClips.set (__name, __xmovieClip);
			
			return __xmovieClip;
		}
			
//------------------------------------------------------------------------------------------
		public function createXTextSprite (
			__width:Float=32,
			__height:Float=32,
			__text:String="",
			__fontName:String="Aller",
			__fontSize:Int=12,
			__color:Int=0x000000,
			__bold:Bool=false,
			__embedFonts:Bool=true
			):XTextSprite {
			
			var __textSprite:XTextSprite = new XTextSprite (
				__width,
				__height,
				__text,
				__fontName,
				__fontSize,
				__color,
				__bold,
				__embedFonts
			);

			m_textSprites.set (__textSprite, 0);
			
			return __textSprite;
		}
		
//------------------------------------------------------------------------------------------
		public function removeAllXBitmaps ():Void {
			XType.forEach (m_bitmaps, 
				function (__name:Dynamic /* */):Void {
					var __bitmap:XBitmap = cast m_bitmaps.get (__name); /* as XBitmap */
					
					__bitmap.cleanup ();
					
					xxx.getXBitmapPoolManager ().returnObject (__bitmap);
				}
			);
			
			XType.removeAllKeys (m_bitmaps);
		}
		
//------------------------------------------------------------------------------------------
		public function removeAllMovieClips ():Void {
			XType.forEach (m_movieClips, 
				function (__name:Dynamic /* */):Void {
					var __xmovieClip:XMovieClip = cast m_movieClips.get (__name); /* as XMovieClip */
					
					{
						__xmovieClip.cleanup ();
						
//						xxx.unloadClass (/* @:cast */ __name as String);
					}
					
					xxx.getXMovieClipPoolManager ().returnObject (__xmovieClip);
				}
			);
			
			XType.removeAllKeys (m_movieClips);
		}

//------------------------------------------------------------------------------------------
		public function removeXTextSprite (__textSprite:XTextSprite):Void {
			if (m_textSprites.exists (__textSprite)) {
				__textSprite.cleanup();
				
				m_textSprites.remove (__textSprite);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function removeAllXTextSprites ():Void {
			XType.forEach (m_textSprites, 
				function (x:Dynamic /* */):Void {
					var __textSprite:XTextSprite = cast x; /* as XTextSprite */
					
					__textSprite.cleanup ();
				}
			);
			
			XType.removeAllKeys (m_textSprites);
		}
		
//------------------------------------------------------------------------------------------
// add sprite to another sprite
//------------------------------------------------------------------------------------------
		public function addDetachedSprite (
			__sprite:Sprite,
			__sprite2:Sprite,
			__dx:Float, __dy:Float
			):Void {
	
			__sprite2.addChild (__sprite);
			
			__sprite.x = -__dx;
			__sprite.y = -__dy;
			
			m_detachedSprites.set (__sprite, __sprite2);
		}
		
//------------------------------------------------------------------------------------------
// add sprite to another sprite
//------------------------------------------------------------------------------------------
		public function addChildSprite (
			__sprite:Sprite,
			__sprite2:Sprite,
			__dx:Float, __dy:Float
			):Void {
	
			__sprite2.addChild (__sprite);
			
			__sprite.x = -__dx;
			__sprite.y = -__dy;
			
			m_childSprites.set (__sprite, __sprite2);
		}
		
//------------------------------------------------------------------------------------------
// add a sprite the World
//------------------------------------------------------------------------------------------	
		public function addSprite (__sprite:Sprite):XDepthSprite {
			return addSpriteAt (__sprite, 0, 0);
		}

//------------------------------------------------------------------------------------------
		public function addSpriteAt (__sprite:DisplayObject, __dx:Float, __dy:Float, __relative:Bool = false):XDepthSprite {
			if (m_layer == -1) {
				return addSpriteToHudAt (__sprite, __dx, __dy);
			}
			
			var __depthSprite:XDepthSprite;
			
			if (__relative || getRelativeDepthFlag ()) {
				__depthSprite = xxx.getXWorldLayer (m_layer).addSprite (__sprite, 0);
				__depthSprite.setRelativeDepthFlag (true);				
			}
			else
			{
				__depthSprite = xxx.getXWorldLayer (m_layer).addSprite (__sprite, getDepth ());
			}
				
			__depthSprite.setRegistration (__dx, __dy);
			
			m_worldSprites.set (__depthSprite, 0);
			
			return __depthSprite;
		}
				
//------------------------------------------------------------------------------------------
// remove a sprite from the World
//------------------------------------------------------------------------------------------	
		public function removeSprite (__sprite:XDepthSprite):Void {
			if (m_worldSprites.exists (__sprite)) {
				m_worldSprites.remove (__sprite);
				
				xxx.getXWorldLayer (m_layer).removeSprite (__sprite);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllWorldSprites ():Void {
			XType.forEach (m_worldSprites, 
				function (x:Dynamic /* */):Void {
					removeSprite (x);
				}
			);
		}
		
//------------------------------------------------------------------------------------------
// add a sprite to the HUD
//------------------------------------------------------------------------------------------	
		public function addSpriteToHud (__sprite:Sprite):XDepthSprite {
			return addSpriteToHudAt (__sprite, 0, 0);
		}

//------------------------------------------------------------------------------------------
		public function addSpriteToHudAt (__sprite:DisplayObject, __dx:Float, __dy:Float, __relative:Bool = false):XDepthSprite {
			var __depthSprite:XDepthSprite;
			
			if (__relative || getRelativeDepthFlag ()) {
				__depthSprite = xxx.getXHudLayer ().addSprite (__sprite, 0);
				__depthSprite.setRelativeDepthFlag (true);				
			}
			else
			{
				__depthSprite = xxx.getXHudLayer ().addSprite (__sprite, getDepth ());
			}
							
			__depthSprite.setRegistration (__dx, __dy);
			
			m_hudSprites.set (__depthSprite, 0);
			
			return __depthSprite;
		}
		
//------------------------------------------------------------------------------------------
// remove a sprite from the HUD
//------------------------------------------------------------------------------------------	
		public function removeSpriteFromHud (__sprite:XDepthSprite):Void {
			if (m_hudSprites.exists (__sprite)) {
				m_hudSprites.remove (__sprite);
				
				xxx.getXHudLayer ().removeSprite (__sprite);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllHudSprites ():Void {
			XType.forEach (m_hudSprites, 
				function (x:Dynamic /* */):Void {
					removeSpriteFromHud (x);
				}
			);
		}
		
//------------------------------------------------------------------------------------------
// add an XLogicObject to the World
//------------------------------------------------------------------------------------------	
		public function addXLogicObject (__XLogicObject:XLogicObject):XLogicObject {
			m_XLogicObjects.set (__XLogicObject, 0);
			
			return __XLogicObject;
		}
		
//------------------------------------------------------------------------------------------
// remove an XLogicObject from the World
//------------------------------------------------------------------------------------------	
		public function removeXLogicObject (__XLogicObject:XLogicObject):Void {
			if (m_XLogicObjects.exists (__XLogicObject)) {
				m_XLogicObjects.remove (__XLogicObject);
				
				if (!__XLogicObject.cleanedUp) {
					__XLogicObject.cleanup ();
				}
			}
		}
		
//------------------------------------------------------------------------------------------
// remove an XLogicObject from the World but don't kill it
//------------------------------------------------------------------------------------------	
		public function removeXLogicObject0 (__XLogicObject:XLogicObject):Void {
			if (m_XLogicObjects.exists (__XLogicObject)) {
				m_XLogicObjects.remove (__XLogicObject);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllXLogicObjects ():Void {
			XType.forEach (m_XLogicObjects, 
				function (x:Dynamic /* */):Void {
					removeXLogicObject (x);
				}
			);
		}
		
//------------------------------------------------------------------------------------------
// not implemented: XLogicObjects that are spawned from a level can contain intialization
// parameters
//------------------------------------------------------------------------------------------	
		public function getDefaultParams ():XSimpleXMLNode {
			return null;
		}

//------------------------------------------------------------------------------------------
		public var autoCulling (get, set):Bool;
		
		public function get_autoCulling ():Bool {
			return m_autoCulling;
		}
		
		public function set_autoCulling (__val:Bool): Bool {
			m_autoCulling = __val;
			
			if (autoCulling) {
				boundingRect = new XRect (-32, -32, 64, 64);
			}
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function setItem (__item:XMapItemModel):Void {
			m_item = __item;
			
			if (m_item != null) {
				m_boundingRect = __item.boundingRect.cloneX ();
				
				m_item.boundingRect.copy2 (m_itemRect);
				m_itemPos.x = m_item.x;
				m_itemPos.y = m_item.y;
				m_itemRect.offsetPoint (m_itemPos);
			}
		}

//------------------------------------------------------------------------------------------
		public var item (get, set):XMapItemModel;
		
		public function get_item ():XMapItemModel {
			return m_item;
		}
		
		public function set_item (__val:XMapItemModel): XMapItemModel {
			return null;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function setupItemParamsXML ():Void {
			m_xml = new XSimpleXMLNode ();
			
			if (item != null && item.params != null && item.params != "") {
				m_xml.setupWithXMLString (item.params);
			}
		}

//------------------------------------------------------------------------------------------
		public function setXML (__xml:XSimpleXMLNode):Void {
			m_xml = __xml;
		}
		
//------------------------------------------------------------------------------------------
		public function getXML ():XSimpleXMLNode {
			return m_xml;
		}
		
//------------------------------------------------------------------------------------------
		public function itemHasAttribute (__attr:String):Bool {
			return m_xml.hasAttribute (__attr);	
		}
		
//------------------------------------------------------------------------------------------
		public function itemGetAttribute (__attr:String):Dynamic /* */ {
			return m_xml.getAttribute (__attr);
		}

//------------------------------------------------------------------------------------------
		public function itemGetAttributeString (__attr:String):String {
			return m_xml.getAttributeString (__attr);
		}
	
//------------------------------------------------------------------------------------------
		public function itemGetAttributeFloat (__attr:String):Float {
			return m_xml.getAttributeFloat (__attr);
		}
		
//------------------------------------------------------------------------------------------
		public function itemGetAttributeInt (__attr:String):Int {
			return m_xml.getAttributeInt (__attr);
		}
		
//------------------------------------------------------------------------------------------
		public function itemGetAttributeBoolean (__attr:String):Bool {
			return m_xml.getAttributeBoolean (__attr);
		}
		
//------------------------------------------------------------------------------------------
		public function setLayer (__layer:Int):Void {
			if (__layer != m_layer && m_layer != -1) {
				XType.forEach (m_worldSprites, 
					function (x:Dynamic /* */):Void {
						xxx.getXWorldLayer (m_layer).moveSprite (x);
						xxx.getXWorldLayer (__layer).addDepthSprite (x);
					}
				);
			}
			
			m_layer = __layer;
		}

//------------------------------------------------------------------------------------------
		public function getLayer ():Int {
			return m_layer;
		}
		
//------------------------------------------------------------------------------------------
		public function setValues ():Void {		
			setRegistration (-getPos ().x, -getPos ().y);
		}

//------------------------------------------------------------------------------------------
		public function getArg(__args:Array<Dynamic> /* <Dynamic> */, i:Int):Dynamic /* */ {
			return __args[i];
		}
		
//------------------------------------------------------------------------------------------
		public var o (get, set):Dynamic;
			
		public function get_o ():Dynamic /* Object */ {
			return cast this /* as Object */;
		}	
	
		public function set_o (__val:Dynamic /* */): Dynamic {
			return 0;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var isDead (get, set):Bool;
			
		public function get_isDead ():Bool {
			return m_isDead;
		}
		
		public function set_isDead (__val:Bool): Bool {
			m_isDead = __val;
			
			return true;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var cleanedUp (get, set):Bool;
		
		public function get_cleanedUp ():Bool {
			return m_cleanedUp;
		}
		
		public function set_cleanedUp (__val:Bool): Bool {
			m_cleanedUp = __val;
			
			return true;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function collisionCallback ():Void {	
		}
		
//------------------------------------------------------------------------------------------
		public var oXLogicManager (get, set):XLogicManager;
		
		public function get_oXLogicManager ():XLogicManager {
			return m_XLogicManager;
		}
		
		public function set_oXLogicManager (__val:XLogicManager): XLogicManager {
			m_XLogicManager = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function getXLogicManager ():XLogicManager {
			return m_XLogicManager;
		}
		
//------------------------------------------------------------------------------------------
		public var boundingRect (get, set):XRect;

		// [Inline]
		public function get_boundingRect ():XRect {
			return m_boundingRect;
		}
		
		// [Inline]
		public function set_boundingRect (__val:XRect): XRect {
			m_boundingRect = __val;
			
			return __val;			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var pos (get, set):XPoint;
		
		// [Inline]
		public function get_pos ():XPoint{
			return m_pos;
		}
				
		// [Inline]
		public function set_pos (__pos:XPoint): XPoint {
			m_pos = __pos;
			
			return __pos;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var oX (get, set):Float;
		
		// [Inline]
		public function get_oX ():Float {
			return m_pos.x;
		}

		// [Inline]
		public function set_oX (__val:Float): Float {
			m_pos.x = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var oY (get, set):Float;
		
		// [Inline]
		public function get_oY ():Float {
			return m_pos.y;
		}		

		// [Inline]
		public function set_oY (__val:Float): Float {
			m_pos.y = __val;

			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		// [Inline]
		public function getPos ():XPoint {
			return m_pos;
		}
	
		// [Inline]
		public function setPos (__pos:XPoint):Void {
			m_pos = __pos;
		}
		
//------------------------------------------------------------------------------------------
		public var oAlpha (get, set):Float;
		
		// [Inline]
		public function get_oAlpha ():Float {
			return m_alpha;
		}
		
		// [Inline]
		public function set_oAlpha (__alpha:Float): Float {
			m_alpha = __alpha;
			
			return __alpha;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		// [Inline]
		public function getAlpha ():Float {
			return m_alpha;
		}
		
		// [Inline]
		public function setAlpha (__alpha:Float):Void {
			m_alpha = __alpha;
		}

//------------------------------------------------------------------------------------------		
		public function setMasterAlpha (__alpha:Float):Void {
			m_masterAlpha = __alpha;
		}
		
//------------------------------------------------------------------------------------------		
		public function getMasterAlpha ():Float {
			return m_masterAlpha;
		}
			
//------------------------------------------------------------------------------------------
		public var oVisible (get, set):Bool;
		
		public function get_oVisible ():Bool {
			return m_visible;
		}
		
		public function set_oVisible (__val:Bool): Bool {
			m_visible = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function getVisible ():Bool {
			return m_visible;
		}

		public function setVisible (__val:Bool):Void {
			m_visible = __val;
		}
		
//------------------------------------------------------------------------------------------		
		public function setMasterVisible (__visible:Bool):Void {
			m_masterVisible = __visible;
		}
		
//------------------------------------------------------------------------------------------		
		public function getMasterVisible ():Bool {
			return m_masterVisible;
		}
					
//------------------------------------------------------------------------------------------
		public var oRotation (get, set):Float;
		
		// [Inline]
		public function get_oRotation ():Float {
			return m_rotation;
		}
		
		// [Inline]
		public function set_oRotation (__val:Float): Float {
			m_rotation = __val % 360;
			
			return m_rotation;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		// [Inline]
		public function getRotation ():Float {
			return m_rotation;
		}
		
		// [Inline]
		public function setRotation (__rotation:Float):Void {
			m_rotation = __rotation % 360;
		}
		
//------------------------------------------------------------------------------------------		
		public function setMasterRotation (__rotation:Float):Void {
			m_masterRotation = __rotation % 360;
		}
		
//------------------------------------------------------------------------------------------		
		public function getMasterRotation ():Float {
			return m_masterRotation;
		}
				
//------------------------------------------------------------------------------------------
		public var oScale (get, set):Float;
		
		// [Inline]
		public function get_oScale ():Float {
			return m_scaleX;
		}

		// [Inline]
		public function set_oScale (__val:Float): Float {
			m_scaleX = m_scaleY = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		// [Inline]
		public function getScale ():Float {
			return m_scaleX;
		}
		
		// [Inline]
		public function setScale (__scale:Float):Void {
			m_scaleX = m_scaleY = __scale;
		}
		
//------------------------------------------------------------------------------------------
		public var oScaleX (get, set):Float;
		
		// [Inline]
		public function get_oScaleX ():Float {
			return m_scaleX;
		}
		
		// [Inline]
		public function set_oScaleX (__val:Float): Float {
			m_scaleX = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		// [Inline]
		public function getScaleX ():Float {
			return m_scaleX;
		}

		// [Inline]
		public function setScaleX (__scale:Float):Void {
			m_scaleX = __scale;
		}
		
//------------------------------------------------------------------------------------------
		public var oScaleY (get, set):Float;
		
		// [Inline]
		public function get_oScaleY ():Float {
			return m_scaleY;
		}
		
		// [Inline]
		public function set_oScaleY (__val:Float): Float {
			m_scaleY = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		// [Inline]
		public function getScaleY ():Float {
			return m_scaleY;
		}
		
		// [Inline]
		public function setScaleY (__scale:Float):Void {
			m_scaleY = __scale;
		}
		
//------------------------------------------------------------------------------------------
/*		
		public function setMasterScale (__scale:Float):Void {
			m_masterScaleX = m_masterScaleY = __scale;
		}
		
//------------------------------------------------------------------------------------------
		public function getMasterScale ():Float {
			return m_masterScaleX;
		}
*/

//------------------------------------------------------------------------------------------		
		public function setMasterScaleX (__scale:Float):Void {
			m_masterScaleX = __scale;
		}
		
//------------------------------------------------------------------------------------------		
		public function getMasterScaleX ():Float {
			return m_masterScaleX;
		}

//------------------------------------------------------------------------------------------		
		public function setMasterScaleY (__scale:Float):Void {
			m_masterScaleY = __scale;
		}
		
//------------------------------------------------------------------------------------------		
		public function getMasterScaleY ():Float {
			return m_masterScaleY;
		}
				
//------------------------------------------------------------------------------------------
		public var oFlipX (get, set):Float;
		
		// [Inline]
		public function get_oFlipX ():Float {
			return m_flipX;
		}
		
		// [Inline]
		public function set_oFlipX (__val:Float): Float {
			m_flipX = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var oFlipY (get, set):Float;
		
		// [Inline]
		public function get_oFlipY ():Float {
			return m_flipY;
		}		
		
		// [Inline]
		public function set_oFlipY (__val:Float): Float {
			m_flipY = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------		
		public function setMasterFlipX(__value:Float):Void {
			m_masterFlipX = __value;
		}
		
//------------------------------------------------------------------------------------------		
		public function getMasterFlipX ():Float {
			return m_masterFlipX;
		}
		
//------------------------------------------------------------------------------------------		
		public function setMasterFlipY(__value:Float):Void {
			m_masterFlipY = __value;
		}
		
//------------------------------------------------------------------------------------------		
		public function getMasterFlipY ():Float {
			return m_masterFlipY;
		}
		
//------------------------------------------------------------------------------------------
		// [Inline]
		public function getFlipX ():Float {
			return m_flipX;
		}
		
		// [Inline]
		public function setFlipX (__value:Float):Void {
			m_flipX = __value;
		}
		
//------------------------------------------------------------------------------------------
		// [Inline]
		public function getFlipY ():Float {
			return m_flipY;
		}
		
		// [Inline]
		public function setFlipY (__value:Float):Void {
			m_flipY = __value;
		}
		
//------------------------------------------------------------------------------------------
		// [Inline]
		public function setDepth (__depth:Float):Void {
			m_depth = __depth;
		}		
		
//------------------------------------------------------------------------------------------
		// [Inline]
		public function getDepth ():Float {
			return m_depth;
		}

//------------------------------------------------------------------------------------------		
		public function setMasterDepth (__depth:Float):Void {
			m_masterDepth = __depth;
		}
		
//------------------------------------------------------------------------------------------		
		public function getMasterDepth ():Float {
			return m_masterDepth;
		}
	
//------------------------------------------------------------------------------------------	
		public function setRelativeDepthFlag (__relative:Bool):Void {
			m_relativeDepthFlag = __relative;
		}		
		
//------------------------------------------------------------------------------------------
		public function getRelativeDepthFlag ():Bool {
			return m_relativeDepthFlag;
		}
					   
//------------------------------------------------------------------------------------------
// the function updates all the children that live inside the XLogicObject container
//
// children in the XLogicObject sense aren't DisplayObject children.  This is done
// so that the depth sorting on each child can be controlled explicitly.
//------------------------------------------------------------------------------------------	
		public function updateDisplay ():Void {
			if (m_delayed > 0) {
				m_delayed--;
				
				return;
			}

//------------------------------------------------------------------------------------------			
			var i:Dynamic /* */;

			var __x:Float = x;
			var __y:Float = y;
			var __visible:Bool = getMasterVisible ();
			var __scaleX:Float = getMasterScaleX ();
			var __scaleY:Float = getMasterScaleY ();
			var __flipX:Float = getMasterFlipX ();
			var __flipY:Float = getMasterFlipY ();
			var __rotation:Float = getMasterRotation ();
			var __depth:Float = getMasterDepth ();
			var __alpha:Float = getMasterAlpha ();
	
//------------------------------------------------------------------------------------------
			var logicObject:XLogicObject;
			
// update children XLogicObjects
			XType.forEach (m_XLogicObjects, 
				function (i:Dynamic /* */):Void {
					logicObject = cast i; /* as XLogicObject */
							
					if (logicObject != null) {	
						logicObject.x2 = __x;
						logicObject.y2 = __y;
						logicObject.rotation2 = __rotation;
						logicObject.visible = __visible;
						logicObject.scaleX2 = __scaleX * __flipX;
						logicObject.scaleY2 = __scaleY * __flipY;
						logicObject.alpha = __alpha;
						
						// propagate rotation, scale, visibility, alpha
						logicObject.setMasterRotation (logicObject.getRotation () + __rotation);
						logicObject.setMasterScaleX (logicObject.getScaleX () * __scaleX);
						logicObject.setMasterScaleY (logicObject.getScaleY () * __scaleY);
						logicObject.setMasterFlipX (logicObject.getFlipX () * __flipX);
						logicObject.setMasterFlipY (logicObject.getFlipY () * __flipY);
						logicObject.setMasterVisible (logicObject.getVisible () && __visible);
						if (logicObject.getRelativeDepthFlag ()) {
							logicObject.setMasterDepth (logicObject.getDepth () + __depth);
						}
						else
						{
							logicObject.setMasterDepth (logicObject.getDepth ());
						}
						logicObject.setMasterAlpha (logicObject.getAlpha () * __alpha);
						
						logicObject.updateDisplay ();
					}
				}
			);
			
//------------------------------------------------------------------------------------------
			var sprite:XDepthSprite;

// update child sprites that live as children of the Sprite
			XType.forEach (m_childSprites, 
				function (i:Dynamic /* */):Void {
				}
			);
								
// update child sprites that live in the World
			XType.forEach (m_worldSprites, 
				function (i:Dynamic /* */):Void {
					sprite = cast i; /* as XDepthSprite */
					
					if (sprite != null) {
						sprite.x2 = __x;
						sprite.y2 = __y;
						sprite.rotation2 = __rotation;
						sprite.visible = sprite.visible2 && __visible;
						if (sprite.relativeDepthFlag) {
							sprite.depth2 = sprite.depth + __depth;
						}
						else
						{
							sprite.depth2 = sprite.depth;
						}
						sprite.scaleX2 = __scaleX * __flipX;
						sprite.scaleY2 = __scaleY * __flipY;
						sprite.alpha = __alpha;
					}
				}
			);
			
// update child sprites that live in the HUD
			XType.forEach (m_hudSprites, 
				function (i:Dynamic /* */):Void {
					sprite = cast i; /* as XDepthSprite */
					
					if (sprite != null) {
						sprite.x2 = __x;
						sprite.y2 = __y;
						sprite.rotation2 = __rotation;
						sprite.visible = sprite.visible2 && __visible;
						if (sprite.relativeDepthFlag) {
							sprite.depth2 = sprite.depth + __depth;
						}
						else
						{
							sprite.depth2 = sprite.depth;
						}
						sprite.scaleX2 = __scaleX * __flipX;
						sprite.scaleY2 = __scaleY * __flipY;
						sprite.alpha = __alpha;
					}
				}
			);
		}

//------------------------------------------------------------------------------------------
		public function gotoAndPlay (__frame:Int):Void {
		}
		
//------------------------------------------------------------------------------------------
		public function gotoAndStop (__frame:Int):Void {
		}
		
//------------------------------------------------------------------------------------------
		public function createXSignal ():XSignal {
			var __signal:XSignal = xxx.getXSignalManager ().createXSignal ();
		
			if (!(m_XSignals.exists (__signal))) {
				m_XSignals.set (__signal, 0);
			}
			
			__signal.setParent (this);
			
			return __signal;
		}

//------------------------------------------------------------------------------------------
		public function removeXSignal (__signal:XSignal):Void {	
			if (m_XSignals.exists (__signal)) {
				m_XSignals.remove (__signal);
					
				xxx.getXSignalManager ().removeXSignal (__signal);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllXSignals ():Void {
			XType.forEach (m_XSignals, 
				function (x:Dynamic /* */):Void {
					removeXSignal (cast x /* as XSignal */);
				}
			);
		}

//------------------------------------------------------------------------------------------
// XTaskManager0
//------------------------------------------------------------------------------------------	
//		public function getXTaskManager0 ():XTaskManager {
//			return xxx.getXTaskManager0 ();
//		}
		
//------------------------------------------------------------------------------------------
		public function addTask0 (
			__taskList:Array<Dynamic> /* <Dynamic> */,
			__findLabelsFlag:Bool = true
		):XTask {
			
			var __task:XTask = m_XTaskSubManager0.addTask (__taskList, __findLabelsFlag);
			
			__task.setParent (this);
			
			return __task;
		}
		
//------------------------------------------------------------------------------------------
		public function changeTask0 (
			__task:XTask,
			__taskList:Array<Dynamic> /* <Dynamic> */,
			__findLabelsFlag:Bool = true
		):XTask {
			
			return m_XTaskSubManager0.changeTask (__task, __taskList, __findLabelsFlag);
		}
		
//------------------------------------------------------------------------------------------
		public function isTask0 (__task:XTask):Bool {
			return m_XTaskSubManager0.isTask (__task);
		}		
		
//------------------------------------------------------------------------------------------
		public function removeTask0 (__task:XTask):Void {
			m_XTaskSubManager0.removeTask (__task);	
		}
		
//------------------------------------------------------------------------------------------
		public function removeAllTasks0 ():Void {
			m_XTaskSubManager0.removeAllTasks ();
		}
		
//------------------------------------------------------------------------------------------
		public function addEmptyTask0 ():XTask {
			return m_XTaskSubManager0.addEmptyTask ();
		}
		
//------------------------------------------------------------------------------------------
//		public function getEmptyTask0$ ():Array /* <Dynamic> */ {
//			return m_XTaskSubManager0.getEmptyTaskX ();
//		}	
		
//------------------------------------------------------------------------------------------
		public function getEmptyTask0X ():Array<Dynamic> /* <Dynamic> */ {
			return m_XTaskSubManager0.getEmptyTaskX ();
		}	
		
//------------------------------------------------------------------------------------------
		public function gotoLogic0 (__logic:Dynamic /* Function */):Void {
			m_XTaskSubManager0.gotoLogic (__logic);
		}
		
//------------------------------------------------------------------------------------------
// XTaskManager
//------------------------------------------------------------------------------------------		
		public function getXTaskManager ():XTaskManager {
			return xxx.getXTaskManager ();
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
//		public function getEmptyTask$ ():Array /* <Dynamic> */ {
//			return m_XTaskSubManager.getEmptyTaskX ();
//		}	
			
//------------------------------------------------------------------------------------------
		public function getEmptyTaskX ():Array<Dynamic> /* <Dynamic> */ {
			return m_XTaskSubManager.getEmptyTaskX ();
		}	
		
//------------------------------------------------------------------------------------------
		public function gotoLogic (__logic:Dynamic /* Function */):Void {
			m_XTaskSubManager.gotoLogic (__logic);
		}
		
//------------------------------------------------------------------------------------------
// XTaskManagerCX
//------------------------------------------------------------------------------------------			
		public function getXTaskManagerCX ():XTaskManager {
			return xxx.getXTaskManagerCX ();
		}
		
//------------------------------------------------------------------------------------------
		public function addTaskCX (
			__taskList:Array<Dynamic> /* <Dynamic> */,
			__findLabelsFlag:Bool = true
		):XTask {
			
			var __task:XTask = m_XTaskSubManagerCX.addTask (__taskList, __findLabelsFlag);
			
			__task.setParent (this);
			
			return __task;
		}
		
//------------------------------------------------------------------------------------------
		public function changeTaskCX (
			__task:XTask,
			__taskList:Array<Dynamic> /* <Dynamic> */,
			__findLabelsFlag:Bool = true
		):XTask {
			
			return m_XTaskSubManagerCX.changeTask (__task, __taskList, __findLabelsFlag);
		}
		
//------------------------------------------------------------------------------------------
		public function isTaskCX (__task:XTask):Bool {
			return m_XTaskSubManagerCX.isTask (__task);
		}		
		
//------------------------------------------------------------------------------------------
		public function removeTaskCX (__task:XTask):Void {
			m_XTaskSubManagerCX.removeTask (__task);	
		}
		
//------------------------------------------------------------------------------------------
		public function removeAllTasksCX ():Void {
			m_XTaskSubManagerCX.removeAllTasks ();
		}
		
//------------------------------------------------------------------------------------------
		public function addEmptyTaskCX ():XTask {
			return m_XTaskSubManagerCX.addEmptyTask ();
		}
		
//------------------------------------------------------------------------------------------
//		public function getEmptyTaskCX$ ():Array /* <Dynamic> */ {
//			return m_XTaskSubManagerCX.getEmptyTaskX ();
//		}	
		
//------------------------------------------------------------------------------------------
		public function getEmptyTaskCX ():Array<Dynamic> /* <Dynamic> */ {
			return m_XTaskSubManagerCX.getEmptyTaskX ();
		}	
		
//------------------------------------------------------------------------------------------
		public function gotoLogicCX (__logic:Dynamic /* Function */):Void {
			m_XTaskSubManagerCX.gotoLogic (__logic);
		}

//------------------------------------------------------------------------------------------
		public function setCollisions ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public function updateLogic ():Void {
		}

//------------------------------------------------------------------------------------------
		public function updatePhysics ():Void {
		}
						
//------------------------------------------------------------------------------------------	
		public function createSprites ():Void {
		}
					
//------------------------------------------------------------------------------------------
		public function show ():Void {
			setVisible (true);
		}
		
//------------------------------------------------------------------------------------------
		public function hide ():Void {
			setVisible (false);
		}		

//------------------------------------------------------------------------------------------
// initializer setters
//
// for use by createXLogicObjectFromXML
//------------------------------------------------------------------------------------------
		public var iX (get, set):Float;
		
		public function get_iX ():Float {
			return m_iX;
		}
		
		public function set_iX (__val:Float): Float {
			m_iX = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var iY (get, set):Float;
		
		public function get_iY ():Float {
			return m_iY;
		}
		
		public function set_iY (__val:Float): Float {
			m_iY = __val;
			
			return __val;	
		}	
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var iScale (get, set):Float;
		
		public function get_iScale ():Float {
			return m_iScale;
		}
		
		public function set_iScale (__val:Float): Float {
			m_iScale = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var iRotation (get, set):Float;
		
		public function get_iRotation ():Float {
			return m_iRotation;
		}
		
		public function set_iRotation (__val:Float): Float {
			m_iRotation = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var iItem (get, set):XMapItemModel;
		
		public function get_iItem ():XMapItemModel {
			return m_iItem;
		}
		
		public function set_iItem (__val:XMapItemModel): XMapItemModel {
			m_iItem = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var iLayer (get, set):Int;
		
		public function get_iLayer ():Int {
			return m_iLayer;
		}
		
		public function set_iLayer (__val:Int): Int {
			m_iLayer = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var iDepth (get, set):Float;
		
		public function get_iDepth ():Float {
			return m_iDepth;
		}

		public function set_iDepth (__val:Float): Float {
			m_iDepth = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var iRelativeDepth (get, set):Bool;
		
		public function get_iRelativeDepth ():Bool {
			return m_iRelativeDepth;
		}

		public function set_iRelativeDepth (__val:Bool): Bool {
			m_iRelativeDepth = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public var iClassName (get, set):String;
		
		public function get_iClassName ():String {
			return m_iClassName;
		}
				
		public function set_iClassName (__val:String): String {
			m_iClassName = __val;
			
			return __val;	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// }
