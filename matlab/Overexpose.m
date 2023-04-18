function ImgEnd = Overexpose(YSize,XSize,ColorSize,ImgEnd,s)
% Функция переэкспонирования изображения

% s - коэффициент переэкспонирования

for c = 1:ColorSize
    for i = 1:YSize
        for j = 1:XSize
            ImgEnd(i,j,c) = ImgEnd(i,j,c)*s;
            if ImgEnd(i,j,c) > 1
                ImgEnd(i,j,c) = 1;
            end
        end
    end
end

end