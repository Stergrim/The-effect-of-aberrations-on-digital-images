function ImgEnd = ApplyAberrations(ImgName,VecParam,alignment,s)
% ������� ���������� �������� ��������� �� �����������
% ImgName - ������ �� �������������� �����������, ��������: 'Test.jpg';
% ����� ����� ���� �������� ����� - ������-����� ��� ��� �������� ������.
% VecParam ����� ��������� ����� [n1,m1,C1;n2,m2,C2,...], ��� n � m
% ���������� ��� ���������, � � - �������� ���������;
% alignment - ���/���� ������ ������������ �������������;
% s - ����������� ������������������.

% ������ ������ ������:
% ImgEnd = ApplicAberrat('Test.jpg',[3,-1,10;2,0,2],false,2);

ImgStart = imread(ImgName);   % �������� ��������� �����������

YSize = size(ImgStart,1);     % ������ �����������
XSize = size(ImgStart,2);     % ������ �����������
ColorSize = size(ImgStart,3); % ����� �������� �������

% ���/���� �������� ������������ ��������� �������. ��� ���������� ��
% �������������� ��������� �����������
good_visual = false;

% ������������ ���������
Abberation = 0;
for i = 1:size(VecParam,1)
    Abberation = Abberation + VecParam(i,3)*Polinoms(YSize,XSize,VecParam(i,1),VecParam(i,2),good_visual);
end

% ������ ����� ��������������
if ColorSize == 1             % ��� �����-������
    Pupil = fft2(ImgStart);
else                          % ��� ��������
    Pupil(:,:,1) = fft2(ImgStart(:,:,1));
    Pupil(:,:,2) = fft2(ImgStart(:,:,2));
    Pupil(:,:,3) = fft2(ImgStart(:,:,3));
end

% ������������� ����� �������
if ColorSize == 1
    Pupil = fftshift(Pupil);
else
    Pupil(:,:,1) = fftshift(Pupil(:,:,1));
    Pupil(:,:,2) = fftshift(Pupil(:,:,2));
    Pupil(:,:,3) = fftshift(Pupil(:,:,3));
end

% ��������� ��������� �� �����-����� �����������
factor = 1;                       % ��������� ���������� �������� ������
Pupil = SuperpositionFronts(YSize,XSize,ColorSize,Pupil,Abberation,factor);

% ��������������� ����� �������
if ColorSize == 1
    Pupil = ifftshift(Pupil);
else
    Pupil(:,:,1) = ifftshift(Pupil(:,:,1));
    Pupil(:,:,2) = ifftshift(Pupil(:,:,2));
    Pupil(:,:,3) = ifftshift(Pupil(:,:,3));
end

% �������� �������������� ����� � ����������� �� ��������
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

% ������ ������������ ������������� �� ����� ������� �����������
if alignment
    ImgEnd = Overexpose(YSize,XSize,ColorSize,ImgEnd,sum(ImgStart/max(ImgStart,[],'all'),'all')/sum(ImgEnd,'all'));
end

% ������������������ ����������� ��� ������������
ImgEnd = Overexpose(YSize,XSize,ColorSize,ImgEnd,s);

%  ������������ ���������, ���������� ����������� � ���������
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

