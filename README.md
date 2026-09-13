# ByeAnnoyingChargingText

tweak for ios 15 n mode rootless for arm64 devices

## requirements

- theos in your laptop (`export THEOS=~/theos`)

## compile the package

well its rootless so u have to say to theos that its rootless

```bash
export THEOS_PACKAGE_SCHEME=rootless
export THEOS_DEVICE_IP=<your-iphone-ip-idk>
make package install
```

or if u want js to make the deb without transfer:

```bash
export THEOS_PACKAGE_SCHEME=rootless
make package
# check ./packages/
```

