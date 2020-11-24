initial
begin
	#10 sv_GreenLight; // Включаем зеленый
	#10 c_CarWaiting; // Передаем управление в С код
	#10 sv_GreenLight; // Снова включаем зеленый
end
