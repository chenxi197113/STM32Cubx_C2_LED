/*********************************************************************
 * 版权所有: Copyright (c) 2021-2022  LED Company. All rights reserved.
 * 系统名称: 
 * 文件名称: Led.h
 * 内容摘要: 简要描述本文件的内容，包括主要模块、函数及其功能的说明
 * 当前版本: 
 * 作    者: Flinger
 * 设计日期: 2021-06-18 11:19
 * 修改记录: 
 * 日    期          版    本          修改人          修改摘要
**********************************************************************/




#ifndef __LED_H__
#define __LED_H__
/********************************** 其它条件编译选项 ***********************************/


/********************************** 标准库头文件 ***********************************/


/********************************** 非标准库头文件 ***********************************/
#include "stm32f1xx_hal.h"


/********************************** 常量定义 ***********************************/


/********************************** 全局宏 ***********************************/
#define LED_ON		            0
#define LED_OFF		            1

#define LED_1_ON()              HAL_GPIO_WritePin(LED_1_GPIO_Port, LED_1_Pin, GPIO_PIN_RESET)
#define LED_2_ON()              HAL_GPIO_WritePin(LED_2_GPIO_Port, LED_2_Pin, GPIO_PIN_RESET)
#define LED_3_ON()              HAL_GPIO_WritePin(LED_3_GPIO_Port, LED_3_Pin, GPIO_PIN_RESET)
#define LED_4_ON()              HAL_GPIO_WritePin(LED_4_GPIO_Port, LED_4_Pin, GPIO_PIN_RESET)

#define LED_1_OFF()             HAL_GPIO_WritePin(LED_1_GPIO_Port, LED_1_Pin, GPIO_PIN_SET)
#define LED_2_OFF()             HAL_GPIO_WritePin(LED_2_GPIO_Port, LED_2_Pin, GPIO_PIN_SET)
#define LED_3_OFF()             HAL_GPIO_WritePin(LED_3_GPIO_Port, LED_3_Pin, GPIO_PIN_SET)
#define LED_4_OFF()             HAL_GPIO_WritePin(LED_4_GPIO_Port, LED_4_Pin, GPIO_PIN_SET)

/********************************** 数据类型 ***********************************/


/********************************** 函数声明 ***********************************/
void LED_Control(uint8_t status);

/********************************** 类定义 ***********************************/


/********************************** 模板 ***********************************/


#endif /* __LED_H__ */


