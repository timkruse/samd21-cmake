# ARM Cortex M0+ - samd21 template (Building with CMake)


## Flashing

	$ ~/Applications/arm-dev/gcc-arm-none-eabi-9-2020-q2-update/bin/arm-none-eabi-gdb -iex "target extended-remote localhost:3333" -ex load -ex "monitor reset" -ex "kill inferiors 1" -ex "quit" build/samd21playground

## Debugging

	$ ~/Applications/arm-dev/gcc-arm-none-eabi-9-2020-q2-update/bin/arm-none-eabi-gdb -iex "target extended-remote localhost:3333" -ex load build/samd21playground
