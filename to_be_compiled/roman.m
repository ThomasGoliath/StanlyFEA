function r=roman(x)
%%
%  r=ROMAN(x)
%   transform x into roman numerals (r)
%   if x is a NxM matrix of integer numbers, r is a NxM matrix cell of
%   strings. It works only for x<10000;
%

    if max(x)>=10000
        error('This function works only for positive integer numbers between 0 and 9999 enclosed.')
        return
    end
    if max(max(floor(x)-x))
        error('integer numbers are required')
        return
    end
    if min(x)<0
        error('Positive numbers are required')
        return
    end
    
    R={'I' 'II' 'III' 'IV' 'V' 'VI' 'VII' 'VIII' 'IX'
       'X' 'XX' 'XXX' 'XL' 'L' 'LX' 'LXX' 'LXXX' 'XC'
       'C' 'CC' 'CCC' 'CD' 'D' 'DC' 'DCC' 'DCCC' 'CM'};
    [n,m]=size(x);
    r=cell(n,m);
    
    for i=1:n
        for j=1:m
            g='';
            f=num2str(x(i,j));
            ll=length(f);
            if ll==4, for ii=1:str2double(f(1)), g=strcat(g,'M'); end, ll=ll-1; end
            for t=ll:-1:1
                s=str2double(f(ll+1-t));
                if s~=0
                    g=strcat(g,R(t,s));
                end
            end 
            r(i,j)=g;
        end
    end
    r=cellstr(r);
end