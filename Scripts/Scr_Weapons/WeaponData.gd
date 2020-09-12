extends Resource

class_name WeaponStats

export var WeaponName := ''

enum FIRE_MODES{
	SEMI,
	BURST,
	AUTO
}

enum WEAPON_TYPE{
	PISTOL,
	SMG,
	SHOTGUN,
	RIFLE,
	DMR,
	SNIPER
}

enum AMMO_TYPE{
	LIGHT,
	MEDIUM,
	HEAVY,
	EXPOLOSIVE,
	CAUSTIC
}

export(WEAPON_TYPE) var WeaponType
export(AMMO_TYPE) var AmmoType

export(FIRE_MODES) var FireModeOne
export(FIRE_MODES) var FireModeTwo = 1
export(Curve) var RecoilPattern

export var hasMultiFire = false
export var isReloadable = true
export var canFire = true
export var canReload = true

export var aimFov = 90
export var restFov = 100

export var FireRate := 1.0
export var BurstRate := 1.0

export var reloadTime := .75
export var reloadFromEmpty := 1.5

export var Damage := 5.0
export var HeadshotMult := 1.5
