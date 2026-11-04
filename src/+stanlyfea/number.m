function value = number(expression)
%NUMBER Parse a scalar arithmetic expression without executing MATLAB code.
% Supports pi, Inf, + - * / ^, parentheses and selected scalar math functions.
text = char(expression);
position = 1;
value = sumExpression();
spaces();
if position <= length(text) || ~isreal(value) || isnan(value)
    invalid();
end

    function x = sumExpression()
        x = product();
        while true
            if take('+'), x = x + product();
            elseif take('-'), x = x - product();
            else, return
            end
        end
    end
    function x = product()
        x = unary();
        while true
            if take('*'), x = x * unary();
            elseif take('/'), x = x / unary();
            else, return
            end
        end
    end
    function x = unary()
        if take('+'), x = unary();
        elseif take('-'), x = -unary();
        else, x = powerExpression();
        end
    end
    function x = powerExpression()
        x = atom();
        if take('^'), x = x ^ unary(); end
    end
    function x = atom()
        spaces();
        if take('(')
            x = sumExpression();
            if ~take(')'), invalid(); end
            return
        end
        token = regexp(text(position:end), ...
            '^(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?', 'match', 'once');
        if ~isempty(token)
            position = position + length(token);
            x = str2double(token);
            return
        end
        token = regexp(text(position:end), '^[A-Za-z][A-Za-z0-9]*', 'match', 'once');
        if isempty(token), invalid(); end
        position = position + length(token);
        switch lower(token)
            case 'pi', x = pi;
            case 'inf', x = Inf;
            otherwise
                if ~take('('), invalid(); end
                argument = sumExpression();
                if ~take(')'), invalid(); end
                switch lower(token)
                    case 'sqrt', x = sqrt(argument);
                    case 'abs', x = abs(argument);
                    case 'sin', x = sin(argument);
                    case 'cos', x = cos(argument);
                    case 'tan', x = tan(argument);
                    case 'sind', x = sind(argument);
                    case 'cosd', x = cosd(argument);
                    case 'tand', x = tand(argument);
                    case 'exp', x = exp(argument);
                    case 'log', x = log(argument);
                    case 'log10', x = log10(argument);
                    otherwise, invalid();
                end
        end
    end
    function yes = take(character)
        spaces();
        yes = position <= length(text) && text(position) == character;
        if yes, position = position + 1; end
    end
    function spaces()
        while position <= length(text) && isspace(text(position))
            position = position + 1;
        end
    end
    function invalid()
        error('Stanly:InvalidNumber', 'Invalid numeric expression: %s', text);
    end
end
