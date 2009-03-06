/*
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file "COPYING" in the main directory of this archive
 * for more details.
 *
 * Copyright (C) 2009 Florian Fainelli <florian@openwrt.org> 
 */

#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/platform_device.h>
#include <bcm63xx_cpu.h>
#include <bcm63xx_dev_spi.h>

static struct resource spi_resources[] = {
	{
		.start		= -1, /* filled at runtime */
		.end		= -1, /* filled at runtime */
		.flags		= IORESOURCE_MEM,
	},
	{
		.start		= -1, /* filled at runtime */
		.flags		= IORESOURCE_IRQ,
	},
};

static struct bcm63xx_spi_pdata spi_pdata = {
	.bus_num		= 0,
	.num_chipselect		= 4,
	.speed_hz		= 50000000,	/* Fclk */
};

static struct platform_device bcm63xx_spi_device = {
	.name		= "bcm63xx_spi",
	.id		= 0,
	.num_resources	= ARRAY_SIZE(spi_resources),
	.resource	= spi_resources,
	.dev.pdata	= &spi_pdata;
};

int __init bcm63xx_spi_register(void)
{
	spi_resources[0].start = bcm63xx_regset_address(RSET_SPI);
	spi_resources[0].end = spi_resources[0].start;
	spi_resources[0].end += RSET_SPI_SIZE - 1;
	spi_resources[1].start = bcm63xx_get_irq_number(IRQ_SPI);

	/* Fill in platform data */
	if (CPU_IS_BCM6338() || CPU_IS_BCM6348()) {
		spi_pdata.msg_fifo_size = SPI_BCM_6338_SPI_MSG_DATA_SIZE;
		spi_pdata.rx_fifo_size = SPI_BCM_6338_SPI_RX_DATA_SIZE;
	}

	if (CPU_IS_BCM6358()) {
		spi_pdata.msg_fifo_size = SPI_BCM_6358_SPI_MSG_DATA_SIZE;
		spi_pdata.rx_fifo_size =  SPI_BCM_6358_SPI_RX_DATA_SIZE;
	}
	
	return platform_device_register(&bcm63xx_spi_device);
}
