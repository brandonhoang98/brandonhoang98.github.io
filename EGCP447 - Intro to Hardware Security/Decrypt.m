function EncryptCaesar = Decrypt(stringIn,key)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
modify = char(stringIn); 
EncryptCaesar = "";
length = strlength(stringIn);
for i = 1:length
    check = modify(i);
    if ( isletter(check))
        check = upper(check);
        checkN = double(check);
        checkN = mod(checkN, 65);
        checkN = checkN + 26;
        checkN = checkN - key;
        checkN = mod(checkN, 26);
        checkN = checkN + 65;
        check = char(checkN);
        EncryptCaesar = strcat(EncryptCaesar, check);
    elseif (isspace(check))
        EncryptCaesar = strcat(EncryptCaesar, " ");
    else
    end 
end
disp(EncryptCaesar)
end

