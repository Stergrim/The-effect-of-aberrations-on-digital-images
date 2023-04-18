function ImgEnd = ApplyAberrations(ImgName,VecParam,alignment,s)
% Функция применения заданных аберраций на изображение
% ImgName - ссылка на обрабатываемое изображение, например: 'Test.jpg';
% может иметь одни цветовой канал - чёрное-белое или три цветовых канала.
% VecParam имеет следующую форму [n1,m1,C1;n2,m2,C2,...], где n и m
% определяют вид аберрации, а С - величину аберрации;
% alignment - вкл/выкл грубое выравнивание интенсивности;
% s - коэффициент переэкспонирования.

% Пример вызова метода:
% ImgEnd = ApplicAberrat('Test.jpg',[3,-1,10;2,0,2],false,2);

ImgStart = imread(ImgName);   % загрузка исходного изображения

YSize = size(ImgStart,1);     % высота изображения
XSize = size(ImgStart,2);     % ширина изображения
ColorSize = size(ImgStart,3); % число цветовых каналов

% Вкл/выкл красивую визуализацию полиномов Цернике. При включённой не
% рассчитывается искажённое изображение
good_visual = false;

% Формирование аберраций
Abberation = 0;
for i = 1:size(VecParam,1)
    Abberation = Abberation + VecParam(i,3)*Polinoms(YSize,XSize,VecParam(i,1),VecParam(i,2),good_visual);
end

% Прямое Фурье преобразование
if ColorSize == 1             % для чёрно-белого
    Pupil = fft2(ImgStart);
else                          % для цветного
    Pupil(:,:,1) = fft2(ImgStart(:,:,1));
    Pupil(:,:,2) = fft2(ImgStart(:,:,2));
    Pupil(:,:,3) = fft2(ImgStart(:,:,3));
end

% Центрирование Фурье спектра
if ColorSize == 1
    Pupil = fftshift(Pupil);
else
    Pupil(:,:,1) = fftshift(Pupil(:,:,1));
    Pupil(:,:,2) = fftshift(Pupil(:,:,2));
    Pupil(:,:,3) = fftshift(Pupil(:,:,3));
end

% Наложение аберрация на Фурье-образ изображения
factor = 1;                       % множитель уменьшения входного зрачка
Pupil = SuperpositionFronts(YSize,XSize,ColorSize,Pupil,Abberation,factor);

% Децентрирование Фурье спектра
if ColorSize == 1
    Pupil = ifftshift(Pupil);
else
    Pupil(:,:,1) = ifftshift(Pupil(:,:,1));
    Pupil(:,:,2) = ifftshift(Pupil(:,:,2));
    Pupil(:,:,3) = ifftshift(Pupil(:,:,3));
end

% Обратное преобразование Фурье с нормировкой на максимум
if ColorSize == 1
    ImgEnd = abs(ifft2(Pupil));
    if max(ImgEnd,[],'all') > 0
        ImgEnd = ImgEnd/max(ImgEnd,[],'all');
    end
else
    ImgEnd(:,:,1) = abs(ifft2(Pupil(:,:,1)));
    ImgEnd(:,:,2) = abs(ifft2(Pupil(:,:,2)));
    ImgEnd(:,:,3) = abs(ifft2(Pupil(:,:,3)));
    if max(ImgEnd,[],'all') > 0
        ImgEnd = ImgEnd/max(ImgEnd,[],'all');
    end
end

% Грубое выравнивание интенсивности по общей энергии изображения
if alignment
    ImgEnd = Overexpose(YSize,XSize,ColorSize,ImgEnd,sum(ImgStart/max(ImgStart,[],'all'),'all')/sum(ImgEnd,'all'));
end

% Переэкспонирование изображения для визуализации
ImgEnd = Overexpose(YSize,XSize,ColorSize,ImgEnd,s);

%  Визуализация исходного, искажённого изображения и аберраций
if good_visual
    surf(Abberation,'EdgeColor', 'none')
    colormap jet
else
    subplot(2,2,1), imshow(ImgStart)
    subplot(2,2,3), imshow(ImgEnd, [0 1])
    subplot(2,2,[2,4])
    surf(Abberation,'EdgeColor', 'none')
    colormap jet
end

end

