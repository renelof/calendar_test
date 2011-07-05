package classes.utils
{
	import classes.model.DataHolder;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.utils.ObjectUtil;
	
	import mxml_views.hourCell;
	import mxml_views.hourCellLeftStrip;
	
	/**
	 * COMMON UTILS CLASS CONATINS ALL COMMON FUNCTIONS/VARIABLES
	 * WHICH COULD BE USED BY DIFFERENT CLASSES OR VIEWS
	*/
	
	public class CommonUtils
	{	
		// used to send values to Event Form 
		[Bindable]
		public static var hour:int
		
		// used to send values to Event Form 
		[Bindable]
		public static var meridiem:int;
		
		// used to send values to Event Form 
		[Bindable]
		public static var mins:int;
		
		// used to send values to Event Form 
		[Bindable]
		public static var description:String;
		
		// used to send values to Event Form 
		[Bindable]
		public static var currentDate:Date;
		
		// Constructor 
		public function CommonUtils()
		{
		}
		
		/**
		 * returns day name for a particular day number in a week
		 */
		public static function getDayName(_intDayNumber:int):String
		{
			_intDayNumber++;
			switch (_intDayNumber)
			{
				case 1:
					return "Sunday";
					break;
				case 2:
					return "Monday";
					break;
				case 3:
					return "Tuesday";
					break;
				case 4:
					return "Wednesday";
					break;
				case 5:
					return "Thursday";
					break;
				case 6:
					return "Friday";
					break;
				case 7:
					return "Saturday";
					break;
				default:
					return "no day";
			}
		}
		  
		/**
		 * returns day count for a month 
		*/ 
		public static function getDaysCount(_intMonth:int, _intYear:int):int
		{
			_intMonth ++;
			switch (_intMonth)
			{
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					return 31;
					break;
				case 4:
				case 6:
				case 9:
				case 11:
					return 30;
					break;
				case 2:
					if((_intYear % 4 == 0 && _intYear % 100 != 0) || _intYear % 400 ==0)
					{
						return 29;
					}
					else
					{
						return 28;
					}
					break;
				default:
					return -1;
			}
		}
		
		/**
		 * creates blue color strip which shows hours in week and day view
		*/		
		public static function createLeftHourStrip(_parent:Canvas):void
		{
			for(var i:int=0; i<24; i++)
			{
				var strLabel:String = "";
				var objLeftStrip:hourCellLeftStrip = new hourCellLeftStrip();
				objLeftStrip.y = objLeftStrip.height * i;
				_parent.addChild(objLeftStrip);
				
				
				if(i == 0)
				{
					objLeftStrip.lblMins.text = "am";
				}		
				else if(i == 12)
				{
					objLeftStrip.lblMins.text = "pm";
				}
				else
				{
					objLeftStrip.lblMins.text = "00";
				}
				
				if(i == 0)
				{
					strLabel = "12";
				}
				else if(i>12)
				{
					strLabel = String(i-12);
				}
				else
				{
					strLabel = String(i);
				}
				
				strLabel = (strLabel.length < 2) ? ("0" + strLabel) : strLabel;
				
				objLeftStrip.lblHours.text = strLabel;
				
			}
		}
		
		/**
		 * creates right strip which shows buttons in week and day view. which allow user to set
		 * some new events on a particular time.
		*/
		public static function createRightHourStrip(_parent:Canvas, _savedDate:Date = null):void
		{
			
			for(var i:int=0; i<24; i++)
			{
				var strLabel:String;
				var objHourCell:hourCell = new hourCell();
				objHourCell.y = objHourCell.height * i;
				_parent.addChild(objHourCell);
				
				
				if(i == 0)
				{
					strLabel = "12";
				}
				else if(i>12)
				{
					strLabel = String(i-12);
				}
				else
				{
					strLabel = String(i);
				}
						
				
				strLabel = (strLabel.length < 2) ? ("0" + strLabel) : strLabel;
				var dt:* = _savedDate != null ? new Date(_savedDate.getFullYear(), _savedDate.month, _savedDate.date) : null;
				objHourCell.data = {date: dt, time: strLabel, meridiem: (i < 12? "am" : "pm")};
				
				// check if event already saved for current time then show its description
				for(var j:int=0; j<DataHolder.getInstance().dataProvider.length; j++)
				{
					var obj:Object = DataHolder.getInstance().dataProvider[j];
					if(ObjectUtil.dateCompare(obj.date, _savedDate) == 0)
					{
						if(obj.hour == strLabel && obj.meridiem == objHourCell.data.meridiem)
						{
							if(obj.mins == 0)
							{
								objHourCell.btnFirstHalf.label = obj.desc;
							}
							else
							{
								objHourCell.btnSecondHalf.label = obj.desc;
							}
						}
					}
				}
				
				// click event for buttons of first and second half
				objHourCell.btnFirstHalf.addEventListener(MouseEvent.CLICK, onDayViewClick);
				objHourCell.btnSecondHalf.addEventListener(MouseEvent.CLICK, onDayViewClick);
			}
		}
		
		/**
		 * Click event of buttons of First and Second half of a hour
		 * set various values like hour, meridiem, date 
		 * these values are used by Event Form 
		*/
		private static function onDayViewClick(event:MouseEvent):void
		{
			var btn:Button = Button(event.target);
			var objHourCell:hourCell = hourCell(btn.parent);
			if(event.target.toString().indexOf("btnFirstHalf") != -1)
			{
				hour = objHourCell.data.time == "12" ? 0 : int(objHourCell.data.time);
				meridiem = objHourCell.data.meridiem == "am"? 0 : 1;
				mins = 0;
			}
			else if(event.target.toString().indexOf("btnSecondHalf") != -1)
			{
				hour = objHourCell.data.time == "12" ? .5 : int(objHourCell.data.time) + .5;
				meridiem = objHourCell.data.meridiem == "am"? 0 : 1;
				mins = 1;
			}
			currentDate = objHourCell.data.date;
			description = btn.label;
			
		}

	}
}