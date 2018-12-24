function [U,S,V] = SVD_Implementation(A)
error = 1;
n = size(A, 2);
V = eye(n);
S = eye(n);
% tol = 1e-6;
while error > 1.e-5
    error = 0;
    for i = 1:n-1
        for j = i+1:n
            x = A(:,i);
            y = A(:,j);
            a = x'*x;   %Uki^2
            b = y'*y;   %Ukj^2
            c = x'*y;   %Uki*Ukj
            % => [a c; c b]
            
            % error = max(error,abs(c)/sqrt(a*b));

            error = sign(c)/(abs(c)+sqrt(1+c^2));
            
            %rotatie Jacobi
            e = (b - a)/(2*c);
            t = sign(e)/(abs(e) + sqrt(1 + e^2));
            cs = 1/sqrt(1+t^2);
            sn = cs*t;
            
            % update A
            x = A(:,i);
            A(:,i) = cs*x - sn*A(:,j);
            A(:,j) = sn*x + cs*A(:,j);
            
            % update V
            x = V(:,i);
            V(:,i) = cs*x - sn*V(:,j);
            V(:,j) = sn*x + cs*V(:,j);
 
        end
    end
end

U = A;
for i = 1:n
     S(i,i) = norm(A(:,i));
     U(:,i) = A(:,i)/S(i,i);
end
