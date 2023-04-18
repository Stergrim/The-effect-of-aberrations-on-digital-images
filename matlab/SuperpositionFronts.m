function Pupil = SuperpositionFronts(YSize,XSize,ColorSize,Pupil,Abberation,factor)
% Функция наложения волновых фронтом от изображения(объекта) и аберраций

% factor - множитель уменьшения входного зрачка, для учёта проявления дифракции

for c = 1:ColorSize
    for i = 1:YSize
        for j = 1:XSize
            if ((i-YSize/2)^(2)+(j-XSize/2)^(2))> ((XSize+YSize)/(4*factor))^(2)
                Pupil(i,j,c) = 0; % за пределами выходного зрачка поле ноль
            else
                Pupil(i,j,c) = Pupil(i,j,c)*exp(-sqrt(-1)*2*pi*Abberation(i,j));
            end
        end
    end
end

end