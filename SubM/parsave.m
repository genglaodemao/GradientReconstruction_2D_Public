function parsave(imgpath, folder1, folder, id, res)
save([imgpath folder1 folder '_Gradient_rfinal_temp' num2str(id,'%06i') '.mat'],'res');
end