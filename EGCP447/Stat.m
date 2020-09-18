function integer = Stat(stringIn,threshold)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
array = zeros(1,26);
modify = char(stringIn);

length = strlength(stringIn)
charlength = 0;
for i = 1:length
   check = modify(i);
   if (isletter(check))
       check = upper(check);
       checkN = double(check);
       checkN = mod(checkN, 65) + 1;
       array(checkN) = array(checkN) + 1;
       charlength = charlength +1; 
   else    
   end
end

for i = 0:25
    correlation = 0.0000;
    newarray = zeros(1,26);
    for s = 1:26
        x = s + 25;
        x = x - i;
        x = mod(x,26) + 1;
        newarray(x) = array(s);
    end
    correlation = correlation + (0.080*(newarray(1)/charlength));
    correlation = correlation + (0.015*(newarray(2)/charlength));
    correlation = correlation + (0.030*(newarray(3)/charlength));
    correlation = correlation + (0.040*(newarray(4)/charlength));
    correlation = correlation + (0.130*(newarray(5)/charlength));
    correlation = correlation + (0.020*(newarray(6)/charlength));
    correlation = correlation + (0.015*(newarray(7)/charlength));
    correlation = correlation + (0.060*(newarray(8)/charlength));
    correlation = correlation + (0.065*(newarray(9)/charlength));
    correlation = correlation + (0.005*(newarray(10)/charlength));
    correlation = correlation + (0.005*(newarray(11)/charlength));
    correlation = correlation + (0.035*(newarray(12)/charlength));
    correlation = correlation + (0.030*(newarray(13)/charlength));
    correlation = correlation + (0.070*(newarray(14)/charlength));
    correlation = correlation + (0.080*(newarray(15)/charlength));
    correlation = correlation + (0.020*(newarray(16)/charlength));
    correlation = correlation + (0.002*(newarray(17)/charlength));
    correlation = correlation + (0.065*(newarray(18)/charlength));
    correlation = correlation + (0.060*(newarray(19)/charlength));
    correlation = correlation + (0.090*(newarray(20)/charlength));
    correlation = correlation + (0.030*(newarray(21)/charlength));
    correlation = correlation + (0.010*(newarray(22)/charlength));
    correlation = correlation + (0.015*(newarray(23)/charlength));
    correlation = correlation + (0.005*(newarray(24)/charlength));
    correlation = correlation + (0.020*(newarray(25)/charlength));
    correlation = correlation + (0.002*(newarray(26)/charlength));
     
    if (correlation > threshold)
        output = "";
        output = strcat(output, num2str(i) + ", ");
        output = strcat(output, num2str(correlation) + ", ");
        stringCode = Decrypt(stringIn, i);
        output = strcat(output, stringCode);
        disp(output);
    end
end 
integer = 1;
end

