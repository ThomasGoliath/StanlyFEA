function CorrectionInclConst(step)

global Solver
global Constraints

if ~isempty(Constraints.Inclined)
    
    for i=1:size(Constraints.Inclined,1)
        
        % Extract values
        node=Constraints.Inclined(i,1);
        theta=Constraints.Inclined(i,2)*pi/180;
        phi=Constraints.Inclined(i,3)*pi/180;
        % Build rotation matrix
        R=[rotmat(theta,3) zeros(3); zeros(3) rotmat(theta,3)];
        R=R*[rotmat(phi,2) zeros(3); zeros(3) rotmat(phi,2)];
        % Find indices
        kk=1:max(max(Constraints.Dtab));
        jj=Constraints.Dtab(node,:);
        kk(jj)=[];        
        
        switch step
            
            case 1 % First step (K and F)
                %K(jj,jj)=R.'.*K(jj,jj)*R;
                Solver.K(:,jj)=Solver.K(:,jj)*R.';
                Solver.K(jj,:)=R*Solver.K(jj,:);
                Solver.F(jj)=R.'*Solver.F(jj);
                
            case 2 % Second step (X)
                Solver.x(jj)=R.'*Solver.x(jj);
                
            case 3 % Third step (R)
                Solver.React(node,:)=Solver.React(node,:)*R.';
                
            otherwise
                ErrorManager('Internal Error, Invalid step in CorrectionInclConst')
        end
    end
end
end
