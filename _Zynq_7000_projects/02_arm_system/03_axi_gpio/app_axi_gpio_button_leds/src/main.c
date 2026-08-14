#include <stdio.h>
#include <stdbool.h>
#include <xil_types.h>
#include <xstatus.h>
#include "xparameters.h"
#include "xgpio.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "xil_printf.h"

// ===========================================================
//  Определение
// ===========================================================
#define GPIO_BASEADDR XPAR_AXI_GPIO_0_BASEADDR
#define INTC_BASEADDR XPAR_INTC_BASEADDR
#define GPIO_INTERRUPT XPAR_AXI_GPIO_0_INTERRUPTS
// ===========================================================
// Глобальные переменные
// ===========================================================
XGpio Gpio; // Экземпляр AXI GPIO
XScuGic intc; // Экземпляр контроллера прерываний
volatile int button_presed = 0; // флаг нажатия кнопки

// ===========================================================
// Обработчик прерывания
// ===========================================================
void GpioHandler(void *CallbackRef) {
    // Сброс флага прерывания
    XGpio_InterruptDisable(&Gpio, 1);
    XGpio_InterruptClear(&Gpio, 1);

    // Чтение состояни кнопки
    u32 button_state = XGpio_DiscreteRead(&Gpio,2); // Канал 2 = кнопка

    if(button_state == 0) {
        // Кнопка нажата
        button_presed = 1;
        xil_printf("Button pressed\r\n");
    }
    // Включаю прерывание
    XGpio_InterruptEnable(&Gpio, 1);
}
// ===========================================================
// Настройка прерывания
// ===========================================================
int SetupInterupts() {
    int Status;
    // Инициализация контроллера прерываний
    XScuGic_Config *intcConfig = XScuGic_LookupConfig(INTC_BASEADDR);
    if(!intcConfig) {
        return XST_FAILURE;
    }
    Status = XScuGic_CfgInitialize(&intc, intcConfig,intcConfig->CpuBaseAddress);
    if(Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    // Настройка обработчика прерываний
    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler , &intc);

    // Подключаем прерывание от AXI GPIO к контроллеру
    Status = XScuGic_Connect(&intc, GPIO_INTERRUPT, (Xil_InterruptHandler)GpioHandler, (void*)&Gpio);
    if(Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    // Включаем прерывание в контроллере (PL)
    XScuGic_Enable(&intc, GPIO_INTERRUPT);

    // Настройка прерывания в AXI GPIO
    XGpio_InterruptEnable(&Gpio,1); // Вкл прерывание
    XGpio_InterruptGlobalEnable(&Gpio); // Глобальное разрешение

    // Вкл прерывание в процессоре (PS)
    Xil_ExceptionEnableMask(XIL_EXCEPTION_IRQ);

    return XST_SUCCESS;
}
// ===========================================================
// Инициализация AXI GPIO
// ===========================================================
int InitializeAxiGpio() {
    return XGpio_Initialize(&Gpio, GPIO_BASEADDR); // Возвращает XST_SUCCESS (0) при успехе
}
// ===========================================================
// Глобальная функция
// ===========================================================
int main() {

    int Status = 0;
    u32 led_state = 0;

    xil_printf("\r\n==== AXI GPIO Demo ===\r\n");

    // 1. Инициализация AXI GPIO
    if(InitializeAxiGpio() != XST_SUCCESS) {
        return XST_FAILURE; 
    }

    // 2. Настройка направления
    XGpio_SetDataDirection(&Gpio, 1, 0x00); // Канал 1 = выход (светодиод)
    XGpio_SetDataDirection(&Gpio, 2, 0x01); // Канал 2 = вход (кнопка)

    // 3. Настройка прерываний
    Status = SetupInterupts();
    if(Status != XST_SUCCESS) {
        xil_printf("Interrupt setup failed\r\n");
        return XST_FAILURE;
    }

    xil_printf("System ready. Press button to change LED state. \r\n");

    bool IsWorkWhile = true;
    u32 led_mask = 0x01;
    while (IsWorkWhile) {
        if(button_presed) { // Прерывание по нажатию
            led_state = !led_state;
            XGpio_DiscreteWrite(&Gpio, 1 ,led_mask);

            led_mask = led_mask << 1;

            if(led_mask >= 0x10) {
                led_mask = 0x01;
            }
            
            button_presed = 0;
        }
    }

    return XST_SUCCESS;
}