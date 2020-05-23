if exist('.\model.stan','file'), delete('.\model.stan'), end
if exist('.\model.fstan','file'), delete('.\model.fstan'), end
copyfile('.\doc\model.stan','.\model.stan','f')
copyfile('.\doc\model.fstan','.\model.fstan','f');