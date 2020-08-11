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
package gx.levels;
	
	import openfl.geom.*;
	import openfl.text.*;
	import openfl.utils.*;
	
	import gx.*;
	import gx.assets.*;
	
	import kx.*;
	import kx.collections.*;
	import kx.geom.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	import kx.xml.*;
		
//------------------------------------------------------------------------------------------
	class _LevelX extends XMapView {
		private var m_XApp:XApp;
		
		public var script:XTask;
		
		private var m_layerView:Array<XMapLayerView>; // <XMapLayerView>
		private var m_layerPos:Array<XPoint>; // <XPoint>
		private var m_layerShake:Array<XPoint>; // <XPoint>
		private var m_layerScroll:Array<XPoint>; // <XPoint>
		
		private var m_maxLayers:Int;
		
		private var m_levelSelectSignal:XSignal;
		private var m_gameStateChangedSignal:XSignal;
		private var m_levelCompleteSignal:XSignal;
		
		private var m_levelData:Dynamic /* */;
		private var m_levelProps:Dynamic /* */;
		
		private var m_viewRect:XRect;
		
//------------------------------------------------------------------------------------------
		public function new () {
			super ();
		}
	
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array<Dynamic> /* <Dynamic> */):Void {
			super.setup (__xxx, args);
			
			var __xml:XSimpleXMLNode = getArg (args, 0);
			m_XApp = getArg (args, 1);
			
			createModelFromXMLReadOnly (__xml, true);
			
			xxx.setXMapModel (getModel ());
			
			initSubmapPoolManager ();

			m_maxLayers = xxx.MAX_LAYERS;
			
			m_layerPos = new Array<XPoint> (); // <XPoint>
			m_layerShake = new Array<XPoint> (); // <XPoint>
			m_layerScroll = new Array<XPoint> (); // <XPoint>
			m_layerView = new Array<XMapLayerView> (); // <XMapLayerView>
			
			m_viewRect = new XRect ();
			
			var i:Int;
			
			for (i in 0 ... m_maxLayers) {
				m_layerPos.push (new XPoint (0, 0));
				m_layerShake.push (new XPoint (0, 0));
				m_layerScroll.push (new XPoint (0, 0));
				m_layerView.push (null);
			}
			
			createSprites9 ();

			m_levelSelectSignal = createXSignal ();
			m_gameStateChangedSignal = createXSignal ();
			m_levelCompleteSignal = createXSignal ();
		}

//------------------------------------------------------------------------------------------
		public override function setupX ():Void {
			super.setupX ();
			
			script = addEmptyTask ();
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():Void {
			super.cleanup ();
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public function createSprites9 ():Void {			
			var i:Int = 0;
			
			while (i < m_maxLayers) {
				m_layerView[i+0] = cast xxx.getXLogicManager ().initXLogicObject (
					// parent
					this,
					// logicObject
					cast new XMapLayerView () /* as XLogicObject */,
					// item, layer, depth
					null, 0, 1000,
					// x, y, z
					0, 0, 0,
					// scale, rotation
					1.0, 0,
					[
						// XMapView
						this,
						// XMapModel
						m_XMapModel,
						// layer
						i + 0,
						// logicClassNameToClass
						GX.appX.logicClassNameToClass
					]
				) /* as XMapLayerView */;
				
				addXLogicObject (m_layerView[i+0]);
				
				m_layerView[i+1] = cast xxx.getXLogicManager ().initXLogicObject (
					// parent
					this,
					// logicObject
					cast new XMapLayerCachedView () /* as XLogicObject */,
					// item, layer, depth
					null, 0, 1000,
					// x, y, z
					0, 0, 0,
					// scale, rotation
					1.0, 0,
					[
						// XMapView
						this,
						// XMapModel
						m_XMapModel,
						// layer
						i + 1
					]
				) /* as XMapLayerCachedView */;
				
				addXLogicObject (m_layerView[i+1]);	
				
				i += 2;
			}
			
			show ();
		}

//------------------------------------------------------------------------------------------
		public function addXMapItem (__item:XMapItemModel, __depth:Float):XLogicObject {	
			return m_layerView[0].addXMapItem (__item, __depth);
		}

//------------------------------------------------------------------------------------------
		public function getXLogicObject (__item:XMapItemModel):XLogicObject {		
			return m_layerView[0].getXLogicObject (__item);
		}
		
//------------------------------------------------------------------------------------------
		public override function scrollTo (__layer:Int, __x:Float, __y:Float):Void {
			m_layerPos[__layer].x = __x;
			m_layerPos[__layer].y = __y;
		}

//------------------------------------------------------------------------------------------
		public override function updateScroll ():Void {
			var i:Int;
			
			for (i in 0 ... m_maxLayers) {
				m_layerPos[i].copy2 (m_layerScroll[i]);
				
				m_layerScroll[i].x += m_layerShake[i].x;
				m_layerScroll[i].y += m_layerShake[i].y;
				
				xxx.getXWorldLayer (i).setPos (m_layerScroll[i]);
			}
		}
		
//------------------------------------------------------------------------------------------
		public override function updateFromXMapModel ():Void {
			var i:Int;
			
			for (i in 0 ... m_maxLayers) {
				m_layerView[i].updateFromXMapModel ();
			}
		}
		
//------------------------------------------------------------------------------------------
		public override function prepareUpdateScroll ():Void {
			var i:Int;
			
			for (i in 0 ... m_maxLayers) {
				m_layerPos[i].copy2 (m_layerScroll[i]);
				
				m_layerScroll[i].x += m_layerShake[i].x;
				m_layerScroll[i].y += m_layerShake[i].y;
			}

			for (i in 0 ... m_maxLayers) {
				m_viewRect.x = -m_layerScroll[i].x;
				m_viewRect.y = -m_layerScroll[i].y;
				m_viewRect.width = xxx.getViewRect ().width;
				m_viewRect.height = xxx.getViewRect ().height;
				
				m_layerView[i].updateFromXMapModelAtRect (m_viewRect);
			}
		}
		
//------------------------------------------------------------------------------------------
		public override function finishUpdateScroll ():Void {
			var i:Int;
			
			for (i in 0 ... m_maxLayers) {
				xxx.getXWorldLayer (i).setPos (m_layerScroll[i]);
			}			
		}

//------------------------------------------------------------------------------------------
		public function onEntry ():Void {
			FadeIn_Script ();
		}
		
//------------------------------------------------------------------------------------------
		public function onExit ():Void {
		}
		
//------------------------------------------------------------------------------------------
		public function setLevelAlpha (__alpha:Float):Void {
			GX.appX.setMaskAlpha (__alpha);
		}

//------------------------------------------------------------------------------------------
		public function addXShake (__count:Int=15, __delayValue:Float=0x0100):Void {
			function __setX (__dy:Float):Void {
				var i:Int;
				
				for (i in 0 ... m_maxLayers) {
					m_layerShake[i].x = __dy;
					m_layerShake[i].y = __dy;
				}
				
				updateScroll ();
			}
			
			var __delay:XNumber = new XNumber (0);
			__delay.value = __delayValue;
			
			addTask ([
				XTask.LABEL, "loop",
				function ():Void {__setX (-__count); }, XTask.WAIT, __delay,
				function ():Void {__setX ( __count); }, XTask.WAIT, __delay,
				
				XTask.FLAGS, function (__task:XTask):Void {
					__count--;
					
					__task.ifTrue (__count == 0);
				}, XTask.BNE, "loop",
				
				function ():Void {
					__setX (0);
				},
				
				XTask.RETN,
			]);
		}
		
//------------------------------------------------------------------------------------------
		public function addYShake (__count:Int=15, __delayValue:Float=0x0100):Void {
			function __setY (__dy:Float):Void {
				var i:Int;
				
				for (i in 0 ... m_maxLayers) {
					m_layerShake[i].x = __dy;
					m_layerShake[i].y = __dy;
				}
				
				updateScroll ();
			}
			
			var __delay:XNumber = new XNumber (0);
			__delay.value = __delayValue;
			
			addTask ([
				XTask.LABEL, "loop",
					function ():Void {__setY (-__count); }, XTask.WAIT, __delay,
					function ():Void {__setY ( __count); }, XTask.WAIT, __delay,
				
					XTask.FLAGS, function (__task:XTask):Void {
						__count--;
						
						__task.ifTrue (__count == 0);
					}, XTask.BNE, "loop",
					
					function ():Void {
						__setY (0);
					},
					
				XTask.RETN,
			]);
		}
		
		//------------------------------------------------------------------------------------------
		public function FadeOut_Script (__levelId:String=""):Void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
							
							XTask.FLAGS, function (__task:XTask):Void {
								setLevelAlpha (Math.max (0.0, GX.appX.getMaskAlpha () - 0.025));
								
								__task.ifTrue (GX.appX.getMaskAlpha () == 0.0 && __levelId != "");
							}, XTask.BNE, "loop",
							
							function ():Void {
								fireLevelSelectSignal (__levelId);
								
								nukeLater ();
							},
							
							XTask.GOTO, "loop",
						
						XTask.RETN,
					]);
					
				},
				
				//------------------------------------------------------------------------------------------
				// animation
				//------------------------------------------------------------------------------------------	
				XTask.LABEL, "loop",	
					XTask.WAIT, 0x0100,	
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		public function FadeOutAlpha_Script (__levelId:String=""):Void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
							
							XTask.FLAGS, function (__task:XTask):Void {
								oAlpha = Math.max (0.0, oAlpha - 0.025);
							},
							
							XTask.GOTO, "loop",
						
						XTask.RETN,
					]);
					
				},
				
				//------------------------------------------------------------------------------------------
				// animation
				//------------------------------------------------------------------------------------------	
				XTask.LABEL, "loop",	
					XTask.WAIT, 0x0100,	
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
			//------------------------------------------------------------------------------------------
		}
		
		//------------------------------------------------------------------------------------------
		public function FadeIn_Script ():Void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():Void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
							
							function ():Void {
								setLevelAlpha (Math.min (1.0, GX.appX.getMaskAlpha () + 0.05));
							},
							
							XTask.GOTO, "loop",
						
						XTask.RETN,
					]);
					
				},
				
				//------------------------------------------------------------------------------------------
				// animation
				//------------------------------------------------------------------------------------------	
				XTask.LABEL, "loop",	
					XTask.WAIT, 0x0100,	
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
		//------------------------------------------------------------------------------------------
		}
	
		//------------------------------------------------------------------------------------------
		public function getLevelProps ():Dynamic /* */ {
			return m_levelProps;
		}
		
		//------------------------------------------------------------------------------------------
		public function setLevelProps (__levelProps:Dynamic /* */):Void {
			m_levelProps = __levelProps;
		}
		
		//------------------------------------------------------------------------------------------
		public function addLevelSelectListener (__listener:Dynamic /* Function */):Int {
			return m_levelSelectSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireLevelSelectSignal (__levelId:String):Void {
			m_levelSelectSignal.fireSignal (__levelId);
		}
		
		//------------------------------------------------------------------------------------------
		public function addGameStateChangedListener (__listener:Dynamic /* Function */):Int {
			return m_gameStateChangedSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireGameStateChangedSignal (__gameState:Int):Void {
			m_gameStateChangedSignal.fireSignal (__gameState);
		}
		
		//------------------------------------------------------------------------------------------
		public function addLeveCompleteListener (__listener:Dynamic /* Function */):Int {
			return m_levelCompleteSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function fireLevelCompleteSignal ():Void {
			m_levelCompleteSignal.fireSignal ();
		}
		
	//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
// }