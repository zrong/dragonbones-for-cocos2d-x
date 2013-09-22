package control
{
	import dragonBones.objects.XMLDataParser;
	import dragonBones.utils.ConstValues;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import message.Message;
	import message.MessageDispatcher;
	
	import model.ImportDataProxy;
	import model.JSFLProxy;
	import model.SkeletonXMLProxy;
	
	import org.zengrong.file.plist.PDict;
	import org.zengrong.file.plist.Plist;
	import org.zengrong.file.plist.Plist10;
	import org.zengrong.file.zwoptex.ZwoptexFormat2File;
	import org.zengrong.file.zwoptex.ZwoptexFormat2Frame;
	
	import utils.BitmapDataUtil;
	import utils.GlobalConstValues;
	import utils.PNGEncoder;
	
	import zero.zip.Zip;
	
	public class ExportDataCommand
	{
		public static const instance:ExportDataCommand = new ExportDataCommand();
		
		
		private var _fileREF:FileReference;
		private var _exportType:uint;
		private var _isExporting:Boolean;
		private var _exportScale:Number;
		
		private var _importDataProxy:ImportDataProxy;
		
		private var _skeletonXMLProxy:SkeletonXMLProxy;
		private var _bitmapData:BitmapData;
		
		public function ExportDataCommand()
		{
			_fileREF = new FileReference();
			
			_importDataProxy = ImportDataProxy.getInstance();
		}
		
		public function export(exportType:uint, exportScale:Number):void
		{
			if(_isExporting)
			{
				return;
			}
			_isExporting = true;
			_exportType = exportType;
			_exportScale = exportScale;
			exportStart();
		}
		
		private function exportStart():void
		{
			var dataBytes:ByteArray;
			var zip:Zip;
			var date:Date;
			
			_skeletonXMLProxy = _importDataProxy.skeletonXMLProxy;
			_bitmapData = _importDataProxy.textureAtlas.bitmapData;
			
			if(_exportScale != 1)
			{
				_skeletonXMLProxy = _skeletonXMLProxy.copy();
				var subBitmapDataDic:Object;
				var movieClip:MovieClip = _importDataProxy.textureAtlas.movieClip;
				if(movieClip && movieClip.totalFrames >= 3)
				{
					subBitmapDataDic = {};
					for each (var displayName:String in _skeletonXMLProxy.getDisplayList())
					{
						movieClip.gotoAndStop(movieClip.totalFrames);
						movieClip.gotoAndStop(displayName);
						subBitmapDataDic[displayName] = movieClip.getChildAt(0);
					}
				}
				else
				{
					subBitmapDataDic = BitmapDataUtil.getSubBitmapDataDic(
						_bitmapData,
						_skeletonXMLProxy.getSubTextureRectDic()
					);
				}
				
				_skeletonXMLProxy.scaleData(_exportScale);
					
				_bitmapData = BitmapDataUtil.getMergeBitmapData(
					subBitmapDataDic,
					_skeletonXMLProxy.getSubTextureRectDic(),
					_skeletonXMLProxy.textureAtlasWidth,
					_skeletonXMLProxy.textureAtlasHeight,
					_exportScale
				);
			}
			
			switch(_exportType)
			{
				case 0:
					try
					{
						dataBytes = getSWFBytes();
						if(dataBytes)
						{
							exportSave(
								XMLDataParser.compressData(
									_skeletonXMLProxy.skeletonXML, 
									_skeletonXMLProxy.textureAtlasXML, 
									dataBytes
								), 
								_importDataProxy.skeletonName + GlobalConstValues.OUTPUT_SUFFIX + GlobalConstValues.SWF_SUFFIX
							);
							return;
						}
						break;
					}
					catch(_e:Error)
					{
						break;
					}
				case 1:
					try
					{
						dataBytes = getPNGBytes();
						if(dataBytes)
						{
							exportSave(
								XMLDataParser.compressData(
									_skeletonXMLProxy.skeletonXML, 
									_skeletonXMLProxy.textureAtlasXML, 
									dataBytes
								), 
								_importDataProxy.skeletonName + GlobalConstValues.OUTPUT_SUFFIX + GlobalConstValues.PNG_SUFFIX
							);
							return;
						}
						break;
					}
					catch(_e:Error)
					{
						break;
					}
				case 2:
				case 3:
					try
					{
						if(_exportType == 2)
						{
							dataBytes = getSWFBytes();
						}
						else
						{
							dataBytes = getPNGBytes();
						}
						
						if(dataBytes)
						{
							date = new Date();
							zip = new Zip();
							zip.add(
								dataBytes, 
								GlobalConstValues.TEXTURE_NAME + (_exportType == 2?GlobalConstValues.SWF_SUFFIX:GlobalConstValues.PNG_SUFFIX),
								date
							);
							zip.add(
								_skeletonXMLProxy.skeletonXML.toXMLString(), 
								GlobalConstValues.SKELETON_XML_NAME, 
								date
							);
							zip.add(
								_skeletonXMLProxy.textureAtlasXML.toXMLString(), 
								GlobalConstValues.TEXTURE_ATLAS_XML_NAME, 
								date
							);
							exportSave(
								zip.encode(), 
								_importDataProxy.skeletonName + GlobalConstValues.OUTPUT_SUFFIX + GlobalConstValues.ZIP_SUFFIX
							);
							zip.clear();
							return;
						}
						break;
					}
					catch(_e:Error)
					{
						break;
					}
				case 4:
				case 5:
					try
					{
						date = new Date();
						zip = new Zip();
						
						if(_skeletonXMLProxy == _importDataProxy.skeletonXMLProxy)
						{
							_skeletonXMLProxy = _skeletonXMLProxy.copy();
						}
						_skeletonXMLProxy.changePath();
						
						
						subBitmapDataDic = BitmapDataUtil.getSubBitmapDataDic(
							_bitmapData, 
							_skeletonXMLProxy.getSubTextureRectDic()
						);
						for(var subTextureName:String in subBitmapDataDic)
						{
							var subBitmapData:BitmapData = subBitmapDataDic[subTextureName];
							zip.add(
								PNGEncoder.encode(subBitmapData), 
								GlobalConstValues.TEXTURE_NAME + "/" + subTextureName + GlobalConstValues.PNG_SUFFIX, 
								date
							);
							subBitmapData.dispose();
						}
						//====2013-08-29 zrong start
						//原来的格式依然不变
						if(_exportType == 4)
						{
							zip.add(
								_skeletonXMLProxy.skeletonXML.toXMLString(), 
								GlobalConstValues.SKELETON_XML_NAME, 
								date
							);
							zip.add(
								_skeletonXMLProxy.textureAtlasXML.toXMLString(), 
								GlobalConstValues.TEXTURE_ATLAS_XML_NAME, 
								date
							);
						}
						//为了cocos2d-x需要，合并两个XML
						else
						{
							zip.add(
								mergeSkeletonAndTextureXML().toXMLString(), 
								//使用新的文件名
								GlobalConstValues.SKELETON_AND_TEXTURE_XML_NAME, 
								date
							);
						}
						//====2013-08-29 zrong end
						exportSave(
							zip.encode(), 
							_importDataProxy.skeletonName + GlobalConstValues.OUTPUT_SUFFIX + GlobalConstValues.ZIP_SUFFIX
						);
						zip.clear();
						return;
					}
					catch(_e:Error)
					{
						break;
					}
					//====2013-09-22 zrong start
					//生成单张PNG，同时生成plist文件
					case 6:
						try
						{
							dataBytes = getPNGBytes();
							if(dataBytes)
							{
								if(_skeletonXMLProxy == _importDataProxy.skeletonXMLProxy)
								{
									_skeletonXMLProxy = _skeletonXMLProxy.copy();
								}
								_skeletonXMLProxy.changePath();
								
								date = new Date();
								zip = new Zip();
								zip.add(
									dataBytes, 
									_importDataProxy.skeletonName + (GlobalConstValues.PNG_SUFFIX),
									date
								);
								zip.add(
									mergeSkeletonAndTextureXML().toXMLString(), 
									_importDataProxy.skeletonName + (GlobalConstValues.XML_SUFFIX), 
									date
								);
								zip.add(
									getPlistFile().toString(), 
									_importDataProxy.skeletonName + (GlobalConstValues.PLIST_SUFFIX), 
									date
								);
								exportSave(
									zip.encode(), 
									_importDataProxy.skeletonName + GlobalConstValues.OUTPUT_SUFFIX + GlobalConstValues.ZIP_SUFFIX
								);
								zip.clear();
								return;
							}
							break;
						}
						catch(_e:Error)
						{
							break;
						}
						//====2013-09-22 zrong end
				default:
					break;
			}
			_isExporting = false;
			MessageDispatcher.dispatchEvent(MessageDispatcher.EXPORT_ERROR);
		}
		
		//====2013-09-22 zrong start
		/**
		 * 合并骨骼和texture两个XML文件，为了cocos2d-x需要
		 */
		private function mergeSkeletonAndTextureXML():XML
		{
			var __skeletonXML:XML = _skeletonXMLProxy.skeletonXML.copy();
			__skeletonXML.appendChild(_skeletonXMLProxy.textureAtlasXML);
			return __skeletonXML;
		}
		
		private function getPlistFile():ZwoptexFormat2File
		{
			var __plist:ZwoptexFormat2File = new ZwoptexFormat2File();
			var __frames:PDict = new PDict();
			for each(var __subTexture:XML in _skeletonXMLProxy.textureAtlasXML[ConstValues.SUB_TEXTURE])
			{
				var __frame:ZwoptexFormat2Frame = new ZwoptexFormat2Frame();
				__frame.
					setFrame(int(__subTexture.@x.toString()), 
					int(__subTexture.@y.toString()), 
					int(__subTexture.@width.toString()), 
					int(__subTexture.@height.toString())).
					setOffset(0,0).
					setRotated(false).
					setSourceColorRect(0,0,int(__subTexture.@width.toString()), int(__subTexture.@height.toString())).
					setSourceSize(int(__subTexture.@width.toString()), int(__subTexture.@height.toString()));
				__plist.addFrame(__subTexture.@name.toString(), __frame);
//				__frame.addValue("frame", 
//					"{{"+__subTexture.@x.toString()+","+__subTexture.@y.toString()+
//					"},{"+__subTexture.@width.toString()+","+__subTexture.@height.toString()+"}}");
//				__frame.addValue("offset", "{0,0}"); 
//				__frame.addValue("rotated", false);
//				__frame.addValue("sourceColorRect",
//					"{{0,0},{"+
//					__subTexture.@width.toString()+","+__subTexture.@height.toString()+"}}");
//				__frame.addValue("sourceSize", "{"+__subTexture.@width.toString()+","+__subTexture.@height.toString()+"}"); 
//				__frames.addValue(__subTexture.@name.toString(), __frame as PDict);
			}
			var __name:String = _importDataProxy.skeletonName + (GlobalConstValues.PNG_SUFFIX);
			__plist.setRealTextureFileName(__name).setTextureFileName(__name).setSize(_bitmapData.width, _bitmapData.height);
//			var __metadata:PDict = new PDict();
//			__metadata.addValue("format", 2);
//			__metadata.addValue("realTextureFileName", __name);
//			__metadata.addValue("size", "{"+_bitmapData.width+","+_bitmapData.height+"}");
//			__metadata.addValue("textureFileName", __name);
//			var __rootDict:PDict = new PDict();
//			__rootDict.addValue("frames", __frames);
//			__rootDict.addValue("metadata", __metadata);
//			__plist.root = __rootDict;
			return __plist;
		}
		//====2013-09-22 zrong end
		
		private function getSWFBytes():ByteArray
		{
			if(_importDataProxy.textureAtlas.movieClip)
			{
				return _importDataProxy.textureBytes;
			}
			return null;
		}
		
		private function getPNGBytes():ByteArray
		{
			if(_importDataProxy.textureAtlas.movieClip)
			{
				return PNGEncoder.encode(_bitmapData);
			}
			else
			{
				if(_bitmapData && _bitmapData != _importDataProxy.textureAtlas.bitmapData)
				{
					return PNGEncoder.encode(_bitmapData);
				}
				return _importDataProxy.textureBytes;
			}
			return null;
		}
		
		private function exportSave(fileData:ByteArray, fileName:String):void
		{
			MessageDispatcher.dispatchEvent(MessageDispatcher.EXPORT, fileName);
			_fileREF.addEventListener(Event.CANCEL, onFileSaveHandler);
			_fileREF.addEventListener(Event.COMPLETE, onFileSaveHandler);
			_fileREF.addEventListener(IOErrorEvent.IO_ERROR, onFileSaveHandler);
			_fileREF.save(fileData, fileName);
		}
		
		private function onFileSaveHandler(e:Event):void
		{
			_fileREF.removeEventListener(Event.CANCEL, onFileSaveHandler);
			_fileREF.removeEventListener(Event.COMPLETE, onFileSaveHandler);
			_fileREF.removeEventListener(IOErrorEvent.IO_ERROR, onFileSaveHandler);
			_isExporting = false;
			switch(e.type)
			{
				case Event.CANCEL:
					MessageDispatcher.dispatchEvent(MessageDispatcher.EXPORT_CANCEL);
					break;
				case IOErrorEvent.IO_ERROR:
					MessageDispatcher.dispatchEvent(MessageDispatcher.EXPORT_ERROR);
					break;
				case Event.COMPLETE:
					if(_bitmapData && _bitmapData != _importDataProxy.textureAtlas.bitmapData)
					{
						_bitmapData.dispose();
						_bitmapData = null;
					}
					MessageDispatcher.dispatchEvent(MessageDispatcher.EXPORT_COMPLETE);
					break;
			}
		}
	}
}