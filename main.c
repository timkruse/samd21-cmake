#include <samd21.h>
#include <stdint.h>


/**
 * Connector for SPI0 info
 *  ______________PCB______________
 *  GND  | PAD1 | GND  | PAD2 | 3V3
 *  PAD0 | GND  | PAD3 | 3V3  | 3V3
 *
 *  In the current config:
 *  - PAD0(PA08 - green) - UART TX
 *  - PAD1(PA09 - blue) - UART Rx
 *  - GND(white)
 */

int main() {
	// configure XOSC@16MHz
	SYSCTRL_XOSC_Type xosc_config = { .reg = 0 };
	xosc_config.bit.STARTUP		  = 0xC; // 62.5ms startup
	xosc_config.bit.GAIN		  = 0x3; // gain for 16MHz operation
	xosc_config.bit.ONDEMAND	  = 1;
	xosc_config.bit.RUNSTDBY	  = 1;
	xosc_config.bit.XTALEN		  = 1;
	xosc_config.bit.ENABLE		  = 1;
	SYSCTRL->XOSC.reg			  = xosc_config.reg;
	while (SYSCTRL->PCLKSR.bit.XOSCRDY == 0)
		; // wait until XTAL has started

	// configure fdpll for 48MHz
	SYSCTRL_DPLLCTRLB_Type fpll_ctrlb_config = { .reg = 0 };
	fpll_ctrlb_config.bit.DIV				 = 8; // XOSC@16MHz / 8. dpll requires a maximum 2MHz as reference input
	fpll_ctrlb_config.bit.REFCLK			 = 1; // 0=xosc32, 1 = xosc, 2 = gclk_dpll
	fpll_ctrlb_config.bit.FILTER			 = 3; // 3=high damping filter
	SYSCTRL->DPLLCTRLB.reg					 = fpll_ctrlb_config.reg;

	SYSCTRL_DPLLRATIO_Type fpll_ratio_config = { .reg = 0 };
	fpll_ratio_config.bit.LDR				 = 23; // fref * (LDR + 1 + LDFRAC/16)
	fpll_ratio_config.bit.LDR				 = 0;
	SYSCTRL->DPLLRATIO.reg					 = fpll_ratio_config.reg;

	SYSCTRL_DPLLCTRLA_Type fpll_ctrla_config = { .reg = 0 };
	fpll_ctrla_config.bit.ONDEMAND			 = 1;
	fpll_ctrla_config.bit.RUNSTDBY			 = 1;
	fpll_ctrla_config.bit.ENABLE			 = 1;
	SYSCTRL->DPLLCTRLA.reg					 = fpll_ctrla_config.reg;
	while (SYSCTRL->DPLLSTATUS.bit.LOCK == 0)
		; // wait for the pll to be locked/ready

	// configure main clock (GCLK0) to 48MHz
	GCLK_GENDIV_Type gclk_gendiv_config = { .reg = 0 };
	gclk_gendiv_config.bit.ID			= 0; // Configure GCLK0
	gclk_gendiv_config.bit.DIV			= 1;
	GCLK->GENDIV.reg					= gclk_gendiv_config.reg;

	GCLK_GENCTRL_Type gclk_genctrl_config = { .reg = 0 };
	gclk_genctrl_config.bit.RUNSTDBY	  = 1;
	// gclk_genctrl_config.bit.DIVSEL = 0;
	// gclk_genctrl_config.bit.OE = 0;
	// gclk_genctrl_config.bit.OOV = 0;
	// gclk_genctrl_config.bit.IDC = 0;
	gclk_genctrl_config.bit.GENEN = 1;
	gclk_genctrl_config.bit.SRC	  = GCLK_GENCTRL_SRC_FDPLL_Val;
	gclk_genctrl_config.bit.ID	  = 0;
	GCLK->GENCTRL.reg			  = gclk_genctrl_config.reg;

	// configure peripheral clock
	// GCLK_CLKCTRL_Type gclk_clkctrl_config = { .reg = 0};
	// gclk_clkctrl_config.bit.ID = 0;
	// gclk_clkctrl_config.bit.
	// serial.print("System Initialized!");


	while (1) {
	}

	return 0;
}