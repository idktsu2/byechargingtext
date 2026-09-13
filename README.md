# ByeAnnoyingChargingText

Tweak para iOS 15.8.8 (jailbreak Dopamine, rootless) que oculta el texto
"X% de carga" que aparece en la lockscreen cuando conectas el cargador
con el iPhone encendido.

## Requisitos

- Theos instalado (`export THEOS=~/theos`)
- Dispositivo con Dopamine (jailbreak rootless) accesible por SSH o USB
- iPhone 7, iOS 15.8.8

## Compilar e instalar

Como Dopamine es un jailbreak **rootless**, hay que decirle a Theos que
empaquete en modo rootless antes de compilar:

```bash
export THEOS_PACKAGE_SCHEME=rootless
export THEOS_DEVICE_IP=<ip-de-tu-iphone>
make package install
```

Si prefieres compilar en la Mac/Linux y pasar el .deb a mano (por Filza
o Sileo):

```bash
export THEOS_PACKAGE_SCHEME=rootless
make package
# el .deb queda en ./packages/
```

Luego transfiérelo al iPhone (AirDrop, scp, etc.) e instálalo con Filza
o `dpkg -i` desde una terminal en el dispositivo.

## Cómo funciona

El archivo `Tweak.xm` prueba tres clases candidatas distintas de
SpringBoard (el nombre exacto varía según el build de iOS):

1. `_SBLockScreenSingleBatteryChargingView` — vista dedicada al aviso
   de carga en la lockscreen clásica.
2. `SBDashBoardChargingViewController` — controlador del dashboard
   para el estado de carga.
3. `SBFLockScreenDateSubtitleDateView` — como respaldo, intercepta
   cualquier texto que contenga "%" junto con "carga"/"charg" y lo
   vacía antes de mostrarlo.

Logos (el lenguaje de Theos) ignora en silencio el `%hook` de una
clase que no exista en tu firmware, así que no hay riesgo de boot
loop por una clase equivocada — simplemente ese bloque no hace nada.

## Si no funciona a la primera

1. Instala el paquete `FLEXing` desde el repo de Chariz para inspeccionar
   la jerarquía de vistas y confirmar el nombre real de la clase en tu
   build específico.
2. Toca directamente el texto "X% de carga" en el inspector — te dará
   el nombre exacto de la clase y su superclase.
3. Edita `Tweak.xm` reemplazando el nombre de clase en el `%hook` que
   corresponda y vuelve a compilar.

## Desinstalar

Desde Sileo o Filza, elimina el paquete `com.idktsu2.byeannoyingchargintext`
y haz un respring.
