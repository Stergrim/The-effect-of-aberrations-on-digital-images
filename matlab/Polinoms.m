function Polinom = Polinoms(M,N,n,m,good_visual)
% ������� ������������ �������� �������, �� �������� n � m

% � � N - ���������� ������� ������ �� ��������� � �����������

Polinom = zeros(M,N);

% ��������� ������� ��������
y = zeros(1,M);
x = zeros(1,N);

% �������� ������� ��������
R = zeros(M,N);
tt = zeros(M,N);

for a = 1:M
    y(a) = -1 + 2*(a-1)/(M-1);
    for b = 1:N
        x(b) = -1 + 2*(b-1)/(N-1);

        % ������� �� �������� ������� ��������� � ���������
        R(a,b) = sqrt(y(a)^2 + x(b)^2);
        if R(a,b) <= 1 % ����������� ������ ���������� �������

            tt(a,b) = atan2(x(b),y(a));
            
            % ������������ ��������
            if m < 0
                for s = 0:(n+m)/2
                    Polinom(a,b) = Polinom(a,b)+sqrt(2*(n+1))*...
                        (((-1)^s)*factorial(n-s)/(factorial(s)*factorial((n-m)/2-s)*factorial((n+m)/2-s)))*...
                        sin(-m*tt(a,b))*R(a,b)^(n-2*s);
                end
            elseif m == 0
                for s = 0:n/2
                    Polinom(a,b) = Polinom(a,b)+sqrt(n+1)*...
                        (((-1)^s)*factorial(n-s)/(factorial(s)*factorial(n/2-s)*factorial(n/2-s)))*...
                        R(a,b)^(n-2*s);
                end
            elseif m > 0
                for s = 0:(n-m)/2
                    Polinom(a,b) = Polinom(a,b)+sqrt(2*(n+1))*...
                        (((-1)^s)*factorial(n-s)/(factorial(s)*factorial((n-m)/2-s)*factorial((n+m)/2-s)))*...
                        cos(m*tt(a,b))*R(a,b)^(n-2*s);
                end
            end
        else
            if good_visual % ���������� ��� �������� ������������
                Polinom(a,b) = NaN;
            end
        end
    end
end

end
