
function f  = mle(x,n_obs,n_region,home,work,fhome,fwork, distance, income, wage,rent,age,residstr)
%disp(x)
% parameters
beta = 0.95;
gamma_w_1 = x(1:9);
gamma_w_2= x(10:14);
gamma_w_3 = zeros(n_region,1);
gamma_w_3(1:n_region-1) = x(14+1:14+n_region-1);
gamma_w_4 = zeros(n_region,1);
gamma_w_4(1:n_region-1) = x(28+1:28+n_region-1);
sigma_w = 1;
T=5;

lnC = zeros(n_region,n_region);

for h=1:n_region
    for j=1:n_region
        for i=1:40
            lnC(h,j) = lnC(h,j) + beta^(i)*(log(income(j,i))+gamma_w_1(7)/gamma_w_1(6)*rent(h,5)+gamma_w_1(1)/gamma_w_1(6)*(h~=j)+gamma_w_1(4)/gamma_w_1(6)*distance(h,j)+ ...
                gamma_w_1(5)/gamma_w_1(6)*distance(h,j)^2+gamma_w_1(8)/gamma_w_1(6)*age(j,5)+gamma_w_1(9)/gamma_w_1(6)*age(h,5)+gamma_w_3(h)/gamma_w_1(6)+gamma_w_4(j)/gamma_w_1(6));
        end
    end
end

lnC2=zeros(n_region,n_region);

for h=1:n_region
    for j=1:n_region
        for i=1:40
            lnC2(h,j) = lnC2(h,j) + beta^(i)*(log(income(j,i)+gamma_w_2(1))+gamma_w_1(7)/gamma_w_1(6)*rent(h,5)+gamma_w_1(1)/gamma_w_1(6)*(h~=j)+gamma_w_1(4)/gamma_w_1(6)*distance(h,j)+ ...
                gamma_w_1(5)/gamma_w_1(6)*distance(h,j)^2+gamma_w_1(8)/gamma_w_1(6)*age(j,5)+gamma_w_1(9)/gamma_w_1(6)*age(h,5)+gamma_w_2(2)/gamma_w_1(6)+ ...
                gamma_w_2(3)/gamma_w_1(6)*(h~=j)+gamma_w_2(4)/gamma_w_1(6)*(5+i)+gamma_w_2(5)/gamma_w_1(6)*(5+i)^2+gamma_w_3(h)/gamma_w_1(6)+gamma_w_4(j)/gamma_w_1(6));
        end
    end
end

V = zeros(T,2,n_region^2, n_region^2);
EV = zeros(T,n_region^2);

for t = T:-1:1
    for mom=0:1
        for fh=1:n_region
            for fj=1:n_region
                for h = 1:n_region % home
                    for j = 1:n_region % job
                        if mom==0
                            if t==T
                                temp1 = [(h~=j) (fh~=h) (fj~=j) distance(h,j) distance(h,j)^2 wage(j,t) rent(h,t) age(j,t) age(h,t)];
                                V(t, mom+1, n_region*(h-1)+j,n_region*(fh-1)+fj) = gamma_w_1(6)*lnC(h,j) +temp1*gamma_w_1 + gamma_w_3(h)+gamma_w_4(j);
                            else
                                temp1 = [(h~=j) (fh~=h) (fj~=j) distance(h,j) distance(h,j)^2 wage(j,t) rent(h,t) age(j,t) age(h,t)];
                                V(t, mom+1, n_region*(h-1)+j,n_region*(fh-1)+fj) = temp1*gamma_w_1+gamma_w_3(h)+gamma_w_4(j)+beta*EV(t,n_region*(h-1)+j);
                            end
                        else
                            if t==T
                                temp1 = [(h~=j) (fh~=h) (fj~=j) distance(h,j) distance(h,j)^2 log(exp(wage(j,t))+gamma_w_2(1)) rent(h,t) age(j,t) age(h,t) 1 (h~=j) t t^2];
                                V(t, mom+1, n_region*(h-1)+j,n_region*(fh-1)+fj) = gamma_w_1(6)*lnC2(h,j) +temp1(1:9)*gamma_w_1 +temp1(10:13)*gamma_w_2(2:5)+ gamma_w_3(h)+gamma_w_4(j);
                            else
                                temp1 = [(h~=j) (fh~=h) (fj~=j) distance(h,j) distance(h,j)^2 log(exp(wage(j,t))+gamma_w_2(1)) rent(h,t) age(j,t) age(h,t) 1 (h~=j) t t^2];
                                
                                V(t, mom+1, n_region*(h-1)+j,n_region*(fh-1)+fj) = temp1(1:9)*gamma_w_1+temp1(10:13)*gamma_w_2(2:5)+gamma_w_3(h)+gamma_w_4(j)+beta*EV(t,n_region*(h-1)+j);
                            end
                        end

                    end
                end
        
            end
        end
    end
    for h = 1:n_region
        for j = 1:n_region

            if t>1
            EV(t-1,n_region*(h-1)+j) = max(max(V(t,:,:,n_region*(h-1)+j)));
            end
        end
    end
end

ff = zeros(n_obs,T);

for t = 1:T
    for i = 1:n_obs
        ff(i,t) = (exp(V(t,residstr(i,t)+1,n_region*(home(i,t)-1)+work(i,t),n_region*(fhome(i,t)-1)+fwork(i,t))/sigma_w-max(max(V(t,:,:,n_region*(fhome(i,t)-1)+fwork(i,t))))))/sum(sum(exp(V(t,:,:,n_region*(fhome(i,t)-1)+fwork(i,t))/sigma_w-max(max(V(t,:,:,n_region*(fhome(i,t)-1)+fwork(i,t)))))));
    end
end

f = -sum(log(ff),'all');