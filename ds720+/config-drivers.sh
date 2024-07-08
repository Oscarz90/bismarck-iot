# loading modules related with USB serial
for module in "usbserial" "ftdi_sio" "cdc-acm"; do
  echo "loading module: $module"
  modprobe $module
done

# load and copy drivers for sonoff zigbee device
URL_BASE="https://github.com/robertklep/dsm7-usb-serial-drivers/raw/main/modules/geminilake/dsm-7.2/"
# https://github.com/robertklep/dsm7-usb-serial-drivers/raw/main/modules/geminilake/dsm-7.2/rndis_host.ko
cd /lib/modules

for driver in "ch341" "cp210x" "pl2303" "rndis_host"; do
  if [-f "/lib/modules/${driver}.ko"]; then
    echo "file ${driver}.ko already exists, removing it..."
    rm -v "${driver}.ko"
  fi

  echo "downloading driver: $driver"
  wget "${URL_BASE}${driver}.ko"

  echo "loading module: $driver"
  insmod "${driver}.ko"
done

chmod 777 /dev/ttyUSB0
chmod 777 /dev/ttyACM0

for device in "ttyUSB0" "ttyACM0"; then
  if [-f "/dev/${device}"]; then
    chmod 777 "/dev/${device}"
  fi
done