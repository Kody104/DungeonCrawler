package Abilities 
{
	/**
	 * ...
	 * @author Kody104
	 */
	public class Ability 
	{
		protected var name:String;
		protected var castType:uint;
		protected var frontRow:String;
		protected var middleRow:String;
		protected var backRow:String;
		protected var damageType:uint;
		protected var baseDmg:uint;
		protected var mpCost:uint;
		protected var statusEffect:StatusEffect;
		protected var hpScale:Number;
		protected var mpScale:Number;
		protected var atkScale:Number;
		protected var magScale:Number;
		protected var spdScale:Number;
		protected var amrScale:Number;
		protected var mrScale:Number;
		
		public function Ability(Name:String, castType:uint, FrontRow:String, MiddleRow:String, BackRow:String, DamageType:uint=0, BaseDmg:uint=0, MpCost:uint=0, statusEffect:StatusEffect=null, HpScale:Number=0, MpScale:Number=0, AtkScale:Number=0, MagScale:Number=0, SpdScale:Number=0, AmrScale:Number=0, MrScale:Number=0) 
		{
			name = Name;
			this.castType = castType;
			frontRow = FrontRow;
			middleRow = MiddleRow;
			backRow = BackRow;
			damageType = DamageType;
			baseDmg = BaseDmg;
			mpCost = MpCost;
			this.statusEffect = statusEffect;
			hpScale = HpScale;
			mpScale = MpScale;
			atkScale = AtkScale;
			magScale = MagScale;
			spdScale = SpdScale;
			amrScale = AmrScale;
			mrScale = MrScale;
		}
		
		public function getName():String
		{
			return name;
		}
		
		public function getCastType():uint
		{
			return castType;
		}
		
		public function getFrontRow():String
		{
			return frontRow;
		}
		
		public function getMiddleRow():String
		{
			return middleRow;
		}
		
		public function getBackRow():String
		{
			return backRow;
		}
		
		public function getDamageType():uint
		{
			return damageType;
		}
		
		public function getBaseDmg():uint
		{
			return baseDmg;
		}
		
		public function getMpCost():uint
		{
			return mpCost;
		}
		
		public function getStatusEffect():StatusEffect
		{
			return statusEffect;
		}
		
		public function getHpScale():Number
		{
			return hpScale;
		}
		
		public function getMpScale():Number
		{
			return mpScale;
		}
		
		public function getAtkScale():Number
		{
			return atkScale;
		}
		
		public function getMagScale():Number
		{
			return magScale;
		}
		
		public function getSpdScale():Number
		{
			return spdScale;
		}
		
		public function getAmrScale():Number
		{
			return amrScale;
		}
		
		public function getMrScale():Number
		{
			return mrScale;
		}
		
	}

}