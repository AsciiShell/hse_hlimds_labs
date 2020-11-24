int c_CarWaiting()
{
    printf("There's a car waiting on the other side. \n");
	printf("Initiate change sequence ...\n");
	sv_YellowLight(); // Включаем желтый
	sv_WaitForRed(); // Передаем управление в SystemVerilog
	sv_RedLight(); // Включаем красный 
	return 0;
}
