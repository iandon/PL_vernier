function outputData(results, resp, correct,typeRespCue, cueLocation);



fprintf(fout,'\nDate:%02d/%02d/%4d  Time:%02d:%02d:%02i  \n\n', c(3),c(2),c(1),c(4),c(5),ceil(c(6)));
    fprintf(fout,'%s, 4, %s, %d, %d, %s, ', name, targetPic, i, resp, correct_ans);
    fprintf(fout,'%d, %1.4f , %d, ', target_color_num, resp_time, is_target_self);