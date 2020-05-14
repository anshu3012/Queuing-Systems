clc
clear
tic
Nc = 10008;          
Tsys = zeros(1,Nc);    
Tia = zeros(1,Nc);     
Ta = zeros(1,Nc);      
Tsrv = zeros(1,Nc);    
Tnsrv = zeros(1,Nc);   
Txsys = zeros(1,Nc);    
WTqmc = zeros(1,Nc);   
MTqmc = zeros(1,Nc);   
MTsys = zeros(1,Nc);   
Tri1_min = 2; 
Tri1_mid = 3; 
Tri1_max = 5; 
Tri2_min = 1.8;
Tri2_mid = 2.8; 
Tri2_max = 4.5; 
pdat  = makedist('Triangular','a',Tri1_min,'b',Tri1_mid,'c',Tri1_max);
pdser = makedist('Triangular','a',Tri2_min,'b',Tri2_mid,'c',Tri2_max); 
Tia(1) = random(pdat);       
Ta(1) = Tia(1);              
Tsys(1) = Tsrv(1);           
Tnsrv(1) = Ta(1);            
Tsrv(1) = random(pdser);     
Txsys(1) = Ta(1) + Tsrv(1);  
WTqmc(1) = 0;                
MTqmc(1) = WTqmc(1);         
for i = 2:1:Nc
    
    Tia(i) = random(pdat);   
    Ta(i) = Ta(i-1) + Tia(i);
    Tsys(i) = Ta(i);
    if Ta(i) < Txsys(i-1)       
        Tnsrv(i) = Tnsrv(i-1) + Tsrv(i-1);
    else                        
        Tnsrv(i) = Ta(i);
    end
    Tsrv(i) = random(pdser);            
    Txsys(i) = Tnsrv(i) + Tsrv(i);      
    WTqmc(i) = Tnsrv(i)-Ta(i);          
    Tsys(i) = Txsys(i) - Ta(i);         
    MTqmc(i) = ((i-1)* MTqmc(i-1) + WTqmc(i))/i;    
    % MTsys(i) = ((i-1)* MTsys(i-1) + Tsys(i))/i;   
end
Tend = Txsys(Nc);
Nts = floor(Tend);          
dt = 1;
Time = zeros(1,Nts);        
Lq = zeros(1,Nts);
Time(1) = 0;
Lq(1) = 0;                  
for j = 2:1:Nts
    Time(j) = Time(j-1)+dt;
    Lq(j) = 0;
    for i = 1:1:Nc
        if (Ta(i) < Time(j) && Txsys(i) > Time(j) && Tnsrv(i) > Time(j))
            Lq(j) = Lq(j)+1;
        end
    end
end
MLqmc = mean(Lq)
MTqmc1 = MTqmc(Nc)
MTqmc_mean = mean(WTqmc)
SDmtamc = std(WTqmc)
SEmtamc = SDmtamc/sqrt(Nc)
toc

%Plot Outcomes
figure(1)
plot(1:Nc,MTqmc)
xlabel('Arrivals')
ylabel('Mean Time in Queue')
title('Queue Length vs Time')

mean1= (2+3+5)/3;
mean2=(1.8+2.8+4.5)/3;
var1=(4+9+25-2*3-2*5-3*5)/18;
var2=(1.8*1.8+2.8*2.8+4.5*4.5-1.8*2.8-1.8*4.5-2.8*4.5)/18;
rho= (1/mean1)/(1/mean2)
ca2= var1/mean1^2;
cs2=var2/mean2^2;
Lq=((rho^2)*(1+cs2)*(ca2+(rho^2)*cs2))/(2*(1-rho)*(1+(rho^2)*cs2));
wq=Lq/(1/mean1)

upperbound=((1/mean1)*(var1+var2))/(2*(1-rho)) % from IIT Kanpur
 
wqwiki=(rho/(1-rho))*((ca2+cs2)/2)*mean2 %from wiki


