# Setup USB Foot Pedal Keyboard

Configure a [VEC in-USB-3 Infinity 3 Digital USB Foot Control](https://www.amazon.com/VEC-USB-3-Infinity-Digital-Control/dp/B08CZZ3RBH). Used this article as a
reference: https://catswhisker.xyz/log/2018/8/27/use_vecinfinity_usb_foot_pedal_as_a_keyboard_under_linux/

## Verify Foot Pedal Hardware Is Recognized
Run the `dmesg` command then plug in the USB device.
```
dmesg -w
[ 5407.206868] usb 3-6.4.4.1: new low-speed USB device number 33 using xhci_hcd
[ 5407.296889] usb 3-6.4.4.1: device descriptor read/64, error -32
[ 5407.509060] usb 3-6.4.4.1: New USB device found, idVendor=05f3, idProduct=00ff, bcdDevice= 1.20
[ 5407.509066] usb 3-6.4.4.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 5407.509068] usb 3-6.4.4.1: Product: VEC USB Footpedal
[ 5407.509069] usb 3-6.4.4.1: Manufacturer: VEC 
[ 5407.515539] input: VEC  VEC USB Footpedal as /devices/pci0000:00/0000:00:14.0/usb3/3-6/3-6.4/3-6.4.4/3-6.4.4.1/3-6.4.4.1:1.0/0003:05F3:00FF.0022/input/input58
[ 5407.516100] hid-generic 0003:05F3:00FF.0022: input,hiddev98,hidraw4: USB HID v1.00 Device [VEC  VEC USB Footpedal] on usb-0000:00:14.0-6.4.4.1/input0
```

## Get Event Code
Run the `evtest` command and then push each button on the foot pedal.
```
sudo evtest /dev/input/event18
Input driver version is 1.0.1
Input device ID: bus 0x3 vendor 0x5f3 product 0xff version 0x100
Input device name: "VEC  VEC USB Footpedal"
Supported events:
  Event type 0 (EV_SYN)
  Event type 1 (EV_KEY)
    Event code 256 (BTN_0)
    Event code 257 (BTN_1)
    Event code 258 (BTN_2)
  Event type 4 (EV_MSC)
    Event code 4 (MSC_SCAN)
Properties:
Testing ... (interrupt to exit)
Event: time 1675747325.907012, type 4 (EV_MSC), code 4 (MSC_SCAN), value 90001
Event: time 1675747325.907012, type 1 (EV_KEY), code 256 (BTN_0), value 1
Event: time 1675747325.907012, -------------- SYN_REPORT ------------
Event: time 1675747326.131081, type 4 (EV_MSC), code 4 (MSC_SCAN), value 90001
Event: time 1675747326.131081, type 1 (EV_KEY), code 256 (BTN_0), value 0
Event: time 1675747326.131081, -------------- SYN_REPORT ------------
Event: time 1675747330.179046, type 4 (EV_MSC), code 4 (MSC_SCAN), value 90002
Event: time 1675747330.179046, type 1 (EV_KEY), code 257 (BTN_1), value 1
Event: time 1675747330.179046, -------------- SYN_REPORT ------------
Event: time 1675747330.459040, type 4 (EV_MSC), code 4 (MSC_SCAN), value 90002
Event: time 1675747330.459040, type 1 (EV_KEY), code 257 (BTN_1), value 0
Event: time 1675747330.459040, -------------- SYN_REPORT ------------
Event: time 1675747332.866933, type 4 (EV_MSC), code 4 (MSC_SCAN), value 90003
Event: time 1675747332.866933, type 1 (EV_KEY), code 258 (BTN_2), value 1
Event: time 1675747332.866933, -------------- SYN_REPORT ------------
Event: time 1675747333.130902, type 4 (EV_MSC), code 4 (MSC_SCAN), value 90003
Event: time 1675747333.130902, type 1 (EV_KEY), code 258 (BTN_2), value 0
Event: time 1675747333.130902, -------------- SYN_REPORT ------------
```

## Setup All Required Configs
```
sudo libinput list-devices # output shows no info for device /dev/input/event18
sudo cp  udev/rules.d/10-vec-usb-footpedal.rules /etc/udev/rules.d/ 
sudo udevadm info /sys/class/input/event18
sudo libinput list-devices # output now shows info for device /dev/input/event18
sudo cp udev/hwdb.d/10-vec-usb-footpedal.hwdb /etc/udev/hwdb.d/
sudo systemd-hwdb update
```

unplug the USB foot pedal and plug it back in.

**NOTE:** file /usr/include/linux/input-event-codes.h contains the keycodes that can be put into
the config files in directory `/etc/udev/hwdb.d/`. Convert them to lowercase and remove the `key_` prefix.

